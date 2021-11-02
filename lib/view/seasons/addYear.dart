import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scouts_system/model/add%20data%20firestore/addFirestoreSeasons.dart';

class AddYear extends StatefulWidget {
  @override
  State<AddYear> createState() => _AddYearState();
}

class _AddYearState extends State<AddYear> {
  TextEditingController _controller = TextEditingController(text: "");

  List<String> seasonsList = ["winter", "summer", "autumn", "spring"];

  String seasonSelected = "summer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "year",
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value:seasonSelected,
                  isExpanded: false,
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  iconSize: 20,
                  elevation: 16,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 17, fontWeight: FontWeight.w300),
                  onChanged: (n) {
                    setState(() {
                      seasonSelected = n!;
                    });
                  },
                  items: buildListMap(seasonsList).toList(),
                ),
              ),
            ]),
            Container(
              color: Colors.blue,
              child: TextButton(
                  onPressed:(){
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      if (_controller.text != "") {
                        addFirestoreSeasons().addDataFirestoreSeasons(year:_controller.text ,season:seasonSelected );
                      }
                        Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "   add   ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
  Iterable<DropdownMenuItem<String>> buildListMap(List<String> list) {
    return list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    });
  }
}
