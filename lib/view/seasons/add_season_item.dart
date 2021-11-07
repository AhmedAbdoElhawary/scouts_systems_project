import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/toast_show.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';
import 'package:scouts_system/view_model/seasons.dart';

class AddYear extends StatefulWidget {
  @override
  State<AddYear> createState() => _AddYearState();
}

class _AddYearState extends State<AddYear> {
  TextEditingController _controller = TextEditingController(text: "");

  List<String> seasonsList = ["winter", "summer", "autumn", "spring"];

  String seasonSelected = "winter";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildColumn(context),
        ),
      ),
    );
  }

  Column buildColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [buildRow(), buildAddTextButton(context)],
    );
  }

  Row buildRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      fieldOfYears(),
      DropdownButtonSeasons(),
    ]);
  }

  DropdownButtonHideUnderline DropdownButtonSeasons() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: seasonSelected,
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
    );
  }

  Expanded fieldOfYears() {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "year",
        ),
      ),
    );
  }

  Container buildAddTextButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextButton(onPressed: () => onPressedAdd(), child: textOfAdd()),
    );
  }

  onPressedAdd() {
    if (_controller.text != "") {
      FirestoreSeasons()
          .addSeason(year: _controller.text, season: seasonSelected);
      //To rebuild the previous page
      context.read<SeasonsLogic>().preparingSeasons();
      context.read<SeasonsLogic>().stateOfFetchingSeasons =
          StateOfSeasons.initial;
      //-------------------------->
      Navigator.pop(context);
    } else {
      ToastShow().showRedToast("Write something !");
    }
  }

  Text textOfAdd() {
    return Text(
      "   add   ",
      style: TextStyle(fontSize: 20, color: Colors.white),
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
