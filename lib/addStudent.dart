import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/studentsPage.dart';

class addNewStudent extends StatefulWidget {
  @override
  State<addNewStudent> createState() => _addNewStudentState();
}

class _addNewStudentState extends State<addNewStudent> {
  bool userNameValidate = false;
  bool userDesValidate = false;
  bool userDateValidate = false;
  bool userVolValidate = false;

  final controlName = TextEditingController();

  final controlDescription = TextEditingController();

  final controlDate = TextEditingController();

  final controlVolunteering = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPressed: onPressedSaveButton(),
      ),
    );
  }
  onPressedSaveButton(){
    if (validateTextField(controlName.text) &&
        validateTextField(controlDescription.text) &&
        validateTextField(controlDate.text) &&
        validateTextField(controlVolunteering.text)) {
      setState(() {
        list.add({
          "name": controlName.text,
          "description": controlDescription.text,
          "date": controlDate.text,
          "vol": controlVolunteering.text,
        });
      });
      Navigator.pop(context);
    }
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
                buildTextFormField(controlName, "Name"),
                const Divider(),
                buildTextFormField(controlDescription, "Description"),
                const Divider(),
                buildTextFormField(controlDate, "Date"),
                const Divider(),
                buildTextFormField(controlVolunteering, "Volunteering Hours"),
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
