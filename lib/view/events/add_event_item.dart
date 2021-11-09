import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/view/events/students_items.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class AddEventInfo extends StatefulWidget {
  TextEditingController controlEventID;
  TextEditingController controlLocation;
  TextEditingController controlEventDay;
  String dropdownValueLeader;
  bool checkForUpdate;
  String eventDocId;
  List<SeasonsFormat> seasonsFormat;
  AddEventInfo(
      {Key? key,
      required this.controlEventID,
      required this.seasonsFormat,
      required this.controlLocation,
      required this.dropdownValueLeader,
      required this.controlEventDay,
      required this.checkForUpdate,
      required this.eventDocId})
      : super(key: key);
  @override
  State<AddEventInfo> createState() => _AddEventInfoState();
}

class _AddEventInfoState extends State<AddEventInfo> {
  String seasonDocId = "";
  String? dropDownSeason;
  var listOfLeader = List<String>.generate(10, (i) => "leader ${i + 1}");
  bool eventIdValidate = false;
  bool locationValidate = false;
  bool userDateValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildContainerOfFields(),
            buildContainerOfButtons(context),
          ],
        ),
      ),
    );
  }

  SizedBox buildContainerOfButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildCancelButton(context),
          buildSaveButton(context),
        ],
      ),
    );
  }

  Expanded buildCancelButton(BuildContext context) {
    return Expanded(
      child: TextButton(
          child: textOfCancel(), onPressed: () => Navigator.pop(context)),
    );
  }

  Text textOfCancel() {
    return const Text("Cancel",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  Expanded buildSaveButton(BuildContext context) {
    return Expanded(
      child: TextButton(child: textOfSave(), onPressed: () => onPressedSave()),
    );
  }

  Text textOfSave() {
    return const Text("Save",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  onPressedSave() async {
    if (validateTextField(widget.controlEventID.text) &&
        validateTextField(widget.controlLocation.text) &&
        validateTextField(widget.controlEventDay.text)) {
      widget.checkForUpdate ? updateEvent() : addEvent();
      //to update data in the previous page
      EventsLogic provider = context.read<EventsLogic>();
      provider.stateOfFetching = StateOfEvents.initial;
      provider.preparingEvents();
      context.read<SeasonsLogic>().preparingSeasons();
      //--------------------------------->
      Navigator.pop(context);
    }
  }

  addEvent() {
    FirestoreEvents().addEvent(
      eventId: widget.controlEventID.text,
      location: widget.controlLocation.text,
      date: widget.controlEventDay.text,
      leader: widget.dropdownValueLeader,
    );
  }

  updateEvent() {
    FirestoreEvents().updateEvent(
      eventId: widget.controlEventID.text,
      location: widget.controlLocation.text,
      date: widget.controlEventDay.text,
      leader: widget.dropdownValueLeader,
      eventDocId: widget.eventDocId,
    );
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        eventIdValidate = true;
        locationValidate = true;
        userDateValidate = true;
      });
      return false;
    }
    setState(() {
      eventIdValidate = false;
      locationValidate = false;
      userDateValidate = false;
    });
    return true;
  }

  Expanded buildContainerOfFields() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: childrenOfColumn(),
          ),
        ),
      ),
    );
  }

  List<Widget> childrenOfColumn() {
    return [
      buildTextFormField(eventIdValidate, widget.controlEventID, "ID"),
      const Divider(),
      buildTextFormField(locationValidate, widget.controlLocation, "Location"),
      const Divider(),
      buildTextFormField(userDateValidate, widget.controlEventDay, "Event Day"),
      const Divider(),
      buildDropdownButton(widget.dropdownValueLeader),
      widget.checkForUpdate
          ? buildDropdownButton(dropDownSeason)
          : const Divider(),
      widget.checkForUpdate && seasonDocId != ""
          ? studentsButton()
          : emptyMessage(),
    ];
  }

  ElevatedButton studentsButton() {
    return ElevatedButton(
        onPressed: () => onPressedButton(),
        child: buildTextOfButton("Students"));
  }

  onPressedButton() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      StudentsLogic provider = context.read<StudentsLogic>();
      provider.selectedStudentsCleared();
      provider.stateOfSelectedFetching = StateOfSelectedStudents.initial;
      buildPush();
    });
  }

  Text buildTextOfButton(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  Future<dynamic> buildPush() {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentsEventPage(
                eventDocId: widget.eventDocId, seasonDocId: seasonDocId)));
  }

  Column emptyMessage() {
    return Column(
      children: const [
        Text("Save the event first"),
        Text("And then you can select students !")
      ],
    );
  }

//I can't make it smaller
  DropdownButtonHideUnderline buildDropdownButton(String? dropDownValue) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropDownValue,
        isExpanded: false,
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        iconSize: 20,
        hint: const Text("select item"),
        elevation: 16,
        style: const TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w300),
        onChanged: (n) {
          setState(() {
            if (widget.checkForUpdate && dropDownValue == dropDownSeason) {
              dropDownSeason = n!;
              seasonDocId = dropDownSeason!;
            } else {
              widget.dropdownValueLeader = n!;
            }
          });
        },
        items: widget.checkForUpdate && dropDownValue == dropDownSeason
            ? listMapOfSeasons(widget.seasonsFormat)?.toList()
            : listMapOfLeaders(listOfLeader)?.toList(),
      ),
    );
  }
}

Iterable<DropdownMenuItem<String>>? listMapOfLeaders(List<String>? list) {
  return list?.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  });
}

Iterable<DropdownMenuItem<String>>? listMapOfSeasons(
    List<SeasonsFormat>? list) {
  return list?.map<DropdownMenuItem<String>>((SeasonsFormat value) {
    return DropdownMenuItem<String>(
        value: value.seasonDocId, child: Text(value.season));
  });
}

TextFormField buildTextFormField(
    bool validate, TextEditingController controller, String text) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
        errorText: validate ? "invalid $text" : null),
  );
}
