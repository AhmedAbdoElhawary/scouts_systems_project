import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/toast_show.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';
import 'package:scouts_system/view_model/seasons.dart';

class AddSeasonScreen extends StatefulWidget {
  const AddSeasonScreen({Key? key}) : super(key: key);

  @override
  State<AddSeasonScreen> createState() => _AddSeasonScreenState();
}

class _AddSeasonScreenState extends State<AddSeasonScreen> {
  final TextEditingController _controller = TextEditingController(text: "");
//if you want to add another season ,just add it here
  List<String> seasonsList = ["winter", "summer"];

  String seasonSelected = "winter";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: columnBody(context),
        ),
      ),
    );
  }

  Column columnBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [rowOfField(), AddButton(context)],
    );
  }

  Row rowOfField() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      textFieldOfYears(),
      dropdownButtonSeasons(),
    ]);
  }

//i can't make it smaller
  DropdownButtonHideUnderline dropdownButtonSeasons() {
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

  Expanded textFieldOfYears() {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "year",
        ),
      ),
    );
  }

  Container AddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton(
          onPressed: () => addSeasonAndPop(), child: textOfAdd()),
    );
  }

  addSeasonAndPop() {
    if (_controller.text != "") {
      FirestoreSeasons()
          .addSeason(year: _controller.text, season: seasonSelected);
      updatePreviousScreenData();
      Navigator.pop(context);
    } else {
      ToastShow().redToast("Write something !");
    }
  }

  updatePreviousScreenData() {
    SeasonsProvider provider = context.read<SeasonsProvider>();
    provider.preparingSeasons();
    provider.stateOfFetchingSeasons = StateOfSeasons.initial;
  }

  Text textOfAdd() {
    return const Text(
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
