import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/common_ui/primary_button.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/view/events/students_items.dart';
import 'package:scouts_system/view_model/seasons.dart';

class AddEventInfo extends StatefulWidget {
  TextEditingController controlEventID;
  TextEditingController controlLocation;
  TextEditingController controlDate;
  String dropdownValueLeader;
  bool checkForUpdate;
  String eventDocId;
  List<SeasonsFormat> seasonsFormat;
  AddEventInfo(
      {required this.controlEventID,
      required this.seasonsFormat,
      required this.controlLocation,
      required this.dropdownValueLeader,
      required this.controlDate,
      required this.checkForUpdate,
      required this.eventDocId});
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

  Container buildContainerOfButtons(BuildContext context) {
    return Container(
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
          child: TextOfCancel(), onPressed: () => Navigator.pop(context)),
    );
  }

  Text TextOfCancel() {
    return Text("Cancel",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  Expanded buildSaveButton(BuildContext context) {
    return Expanded(
      child: TextButton(child: TextOfSave(), onPressed: () => onPressedSave()),
    );
  }

  Text TextOfSave() {
    return Text("Save",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  onPressedSave() async {
    if (validateTextField(widget.controlEventID.text) &&
        validateTextField(widget.controlLocation.text) &&
        validateTextField(widget.controlDate.text)) {
      widget.checkForUpdate ? updateEvent() : addEvent();
      Navigator.pop(context);
    }
  }

  addEvent() {
    FirestoreEvents().addEvent(
      eventId: widget.controlEventID.text,
      location: widget.controlLocation.text,
      date: widget.controlDate.text,
      leader: widget.dropdownValueLeader,
    );
  }

  updateEvent() {
    FirestoreEvents().updateEvent(
      eventId: widget.controlEventID.text,
      location: widget.controlLocation.text,
      date: widget.controlDate.text,
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
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: childrenOfColumn(),
            ),
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
      buildTextFormField(userDateValidate, widget.controlDate, "Date"),
      const Divider(),
      buildDropdownButton(widget.dropdownValueLeader),
      widget.checkForUpdate ? buildDropdownButton(dropDownSeason) : Divider(),
      widget.checkForUpdate && seasonDocId != ""
          ? PrimaryButton(
              text: "Students",
              moveToPage: StudentsEventPage(
                  eventDocId: widget.eventDocId, seasonDocId: seasonDocId))
          : emptyMessage(),
    ];
  }

  Column emptyMessage() {
    return Column(
      children: [
        Container(child: Text("Save the event first")),
        Container(child: Text("And then you can select students !"))
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
        hint: Text("select item"),
        elevation: 16,
        style: const TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w300),
        onChanged: (n) {
          setState(() {
            if (widget.checkForUpdate && dropDownValue == dropDownSeason) {
              dropDownSeason = n!;
              seasonDocId = dropDownSeason!;
            } else
              widget.dropdownValueLeader = n!;
          });
        },
        items: widget.checkForUpdate && dropDownValue == dropDownSeason
            ? ListMapOfSeasons(widget.seasonsFormat)?.toList()
            : ListMapOfLeaders(listOfLeader)?.toList(),
      ),
    );
  }
}

Iterable<DropdownMenuItem<String>>? ListMapOfLeaders(List<String>? list) {
  return list?.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  });
}

Iterable<DropdownMenuItem<String>>? ListMapOfSeasons(
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
        border: OutlineInputBorder(),
        labelText: text,
        errorText: validate ? "invalid ${text}" : null),
  );
}
