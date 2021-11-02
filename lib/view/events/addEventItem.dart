import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/common%20UI/buildDropDownButton.dart';
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

  AddEventInfo(
      {required this.listOfYearsDropButton,
      required this.controlEventID,
      required this.controlLocation,
      required this.dropdownValueLeader,
      required this.controlDate,
      required this.checkForUpdate,
      required this.EventDocId});
  @override
  State<AddEventInfo> createState() => _AddEventInfoState();
}

class _AddEventInfoState extends State<AddEventInfo> {
  String dropDownYears = "2021";
  String dropDownSeasons = "winter";
  var listOfLeader = List<String>.generate(10, (i) => "leader ${i + 1}");
  List<String> listOfSeason = ["winter", "summer"];
  bool eventIdValidate = false;
  bool LocationValidate = false;
  bool userDateValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
      color: Colors.blue,
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
                color: Colors.white,
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
                  color: Colors.white,
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
                DropDownButton(dropDownValue:widget.dropdownValueLeader,listOfDropDown: listOfLeader),
                const Divider(),
                Row(children: [
                  Expanded(
                      child: DropDownButton(
                          dropDownValue: dropDownYears,listOfDropDown: widget.listOfYearsDropButton)),
                  DropDownButton(dropDownValue: dropDownSeasons,listOfDropDown: listOfSeason)
                ]),
                Center(
                  child: Container(
                    color: Colors.blue,
                    child: TextButton(
                        onPressed: () async {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentEventPage(
                                      eventDocId: widget.EventDocId,
                                      year: dropDownYears,
                                      season: dropDownSeasons)),
                            );
                          });
                        },
                        child: Text(
                          "  students  ",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
}
