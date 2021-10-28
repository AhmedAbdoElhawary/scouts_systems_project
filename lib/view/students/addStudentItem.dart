import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/firestore.dart';

class addNewStudent extends StatefulWidget {
  TextEditingController controlName;
  TextEditingController controlDescription;
  TextEditingController controlDate;
  TextEditingController controlVolunteeringHours;
  int index;
  String id;
  bool checkForUpdate;



  addNewStudent(
      {
        required this.id,
        required this.controlName,
      required this.controlDescription,
      required this.controlVolunteeringHours,
      required this.controlDate,
      required this.index,
      required this.checkForUpdate
      });
  @override
  State<addNewStudent> createState() => _addNewStudentState();
}

class _addNewStudentState extends State<addNewStudent> {
  bool userNameValidate = false;
  bool userDesValidate = false;
  bool userDateValidate = false;
  bool userVolValidate = false;

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
          onPressed: () {
            if (validateTextField(widget.controlName.text) &&
                validateTextField(widget.controlDescription.text) &&
                validateTextField(widget.controlDate.text) &&
                validateTextField(widget.controlVolunteeringHours.text)) {
              if (widget.checkForUpdate) {
                FirestoreOperation().updateDataFirestoreStudents(
                    name:widget.controlName.text,
                    description:widget.controlDescription.text,
                    volunteeringHours:widget.controlVolunteeringHours.text,
                    date:widget.controlDate.text,
                  id: widget.id,

                );
              } else {
                FirestoreOperation().addDataFirestoreStudents(
                  name:widget.controlName.text,
                  description:widget.controlDescription.text,
                  volunteeringHours:widget.controlVolunteeringHours.text,
                  date:widget.controlDate.text,

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
        userNameValidate = true;
        userDesValidate = true;
        userDateValidate = true;
        userVolValidate = true;
      });
      return false;
    }
    setState(() {
      userNameValidate = false;
      userDesValidate = false;
      userDateValidate = false;
      userVolValidate = false;
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
                buildTextFormField(widget.controlName, "Name"),
                const Divider(),
                buildTextFormField(widget.controlDescription, "Description"),
                const Divider(),
                buildTextFormField(widget.controlDate, "Date"),
                const Divider(),
                buildTextFormField(
                    widget.controlVolunteeringHours, "Volunteering Hours"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String text) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: text,
          errorText: userNameValidate ? "invalid ${text}" : null),
    );
  }
}
