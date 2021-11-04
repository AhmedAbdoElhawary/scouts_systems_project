import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/common%20UI/buildTheBlueTextButton.dart';
import 'package:scouts_system/common%20UI/showTheTextMessage.dart';
import 'package:scouts_system/model/add%20data%20firestore/addFirestoreEvents.dart';
import 'package:scouts_system/view/events/StudentsListInEventItem.dart';

class AddEventInfo extends StatefulWidget {
  TextEditingController controlEventID;
  TextEditingController controlLocation;
  TextEditingController controlDate;
  String dropdownValueLeader;
  bool checkForUpdate;
  String EventDocId;
  List<String> listOfYearsDropButton;
  Map<String, List<String>> listOfSeasonsData;

  AddEventInfo(
      {required this.listOfYearsDropButton,
      required this.controlEventID,
      required this.controlLocation,
      required this.dropdownValueLeader,
      required this.controlDate,
      required this.checkForUpdate,
      required this.listOfSeasonsData,
      required this.EventDocId});
  @override
  State<AddEventInfo> createState() => _AddEventInfoState();
}

class _AddEventInfoState extends State<AddEventInfo> {
  String? dropDownYears;
  String? dropDownSeasons;
  var listOfLeader = List<String>.generate(10, (i) => "leader ${i + 1}");
  bool eventIdValidate = false;
  bool LocationValidate = false;
  bool userDateValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildContainerOfFields(),
            buildContainerOfUnderButtons(context),
          ],
        ),
      ),
    );
  }

  Container buildContainerOfUnderButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
        child: Text("Cancel",
            style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.normal)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Expanded buildSaveButton(BuildContext context) {
    return Expanded(
      child: TextButton(
          child: Text("Save",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
          onPressed: () async {
            if (validateTextField(widget.controlEventID.text) &&
                validateTextField(widget.controlLocation.text) &&
                validateTextField(widget.controlDate.text)) {
              if (!widget.checkForUpdate) {
                addFirestoreEvents().addDataFirestoreEvents(
                  eventId: widget.controlEventID.text,
                  location: widget.controlLocation.text,
                  date: widget.controlDate.text,
                  leader: widget.dropdownValueLeader,
                );
              } else {
                addFirestoreEvents().updateDataFirestoreEvents(
                  eventId: widget.controlEventID.text,
                  location: widget.controlLocation.text,
                  date: widget.controlDate.text,
                  leader: widget.dropdownValueLeader,
                  eventDocId: widget.EventDocId,
                );
              }
              Navigator.pop(context);
            }
          }),
    );
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        eventIdValidate = true;
        LocationValidate = true;
        userDateValidate = true;
      });
      return false;
    }
    setState(() {
      eventIdValidate = false;
      LocationValidate = false;
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
              children: [
                buildTextFormField(
                    eventIdValidate, widget.controlEventID, "ID"),
                const Divider(),
                buildTextFormField(
                    LocationValidate, widget.controlLocation, "Location"),
                const Divider(),
                buildTextFormField(
                    userDateValidate, widget.controlDate, "Date"),
                const Divider(),
                buildDropdownButton(widget.dropdownValueLeader, listOfLeader),
                widget.EventDocId != ""
                    ? Row(children: [
                        Expanded(
                            child: buildDropdownButton(
                                dropDownYears, widget.listOfYearsDropButton)),
                        buildDropdownButton(dropDownSeasons,
                            widget.listOfSeasonsData[dropDownYears]),
                      ])
                    : const Divider(),
                widget.EventDocId == "" ||
                        dropDownYears == null ||
                        dropDownSeasons == null
                    ? ((dropDownYears == null || dropDownSeasons == null)
                        ? buildShowMessage("season")
                        : Column(
                            children: [
                              Container(child: Text("save the event first")),
                              Container(
                                  child: Text(
                                      "and then you can select students !"))
                            ],
                          ))
                    : BuildBlueTextButton(
                        text: "  students  ",
                        pop: false,
                        moveToPage: StudentEventPage(
                            eventDocId: widget.EventDocId,
                            year: dropDownYears ?? "2021",
                            season: dropDownSeasons ?? "winter"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownButtonHideUnderline buildDropdownButton(
      String? dropDownValue, List<String>? listOfDropDown) {
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
            dropDownValue == dropDownYears
                ? dropDownYears = n!
                : (dropDownValue == dropDownSeasons
                    ? dropDownSeasons = n!
                    : widget.dropdownValueLeader = n!);
            // dropDownValue = n!;
          });
        },
        items: buildListMap(listOfDropDown)?.toList(),
      ),
    );
  }
}

Iterable<DropdownMenuItem<String>>? buildListMap(List<String>? list) {
  return list?.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
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
