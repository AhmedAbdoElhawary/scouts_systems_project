import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/model/firestore/add_students.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';
import 'memberships_screen.dart';

// ignore: must_be_immutable
class StudentInformationScreen extends StatefulWidget {
  TextEditingController controllerOfName;
  TextEditingController controllerOfDescription;
  TextEditingController controllerOfBirthdate;
  TextEditingController controllerOfHours;
  String studentDocId;
  bool checkForUpdate;
  StudentInformationScreen(
      {Key? key,
      this.studentDocId = "",
      required this.controllerOfBirthdate,
      required this.controllerOfDescription,
      required this.controllerOfHours,
      required this.controllerOfName,
      this.checkForUpdate = false})
      : super(key: key);
  @override
  State<StudentInformationScreen> createState() =>
      _StudentInformationScreenState();
}

class _StudentInformationScreenState extends State<StudentInformationScreen> {
  bool userNameValidate = false;
  bool userDescriptionValidate = false;
  bool userBirthdateValidate = false;
  bool userHoursValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          buildTextFields(),
          buildSaveAndCancelButtons(context),
        ],
      ),
    );
  }

  SizedBox buildSaveAndCancelButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: buildRowOfButtons(context),
    );
  }

  Row buildRowOfButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buttonOfCancel(context),
        buttonOfSave(context),
      ],
    );
  }

  Expanded buttonOfCancel(BuildContext context) {
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

  Expanded buttonOfSave(BuildContext context) {
    return Expanded(
      child: TextButton(child: textOfSave(), onPressed: () => onPressedSave()),
    );
  }

  Text textOfSave() {
    return const Text("Save",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  onPressedSave() {
    //Check for => are text fields empty or not ?
    //He can't add or update if them empty.
    if (validateTextField(widget.controllerOfName.text) &&
            validateTextField(widget.controllerOfDescription.text) &&
            validateTextField(widget.controllerOfBirthdate.text) &&
            widget.checkForUpdate
        ? validateTextField(widget.controllerOfHours.text)
        : true) {
      StudentsLogic provider = context.read<StudentsLogic>();
      //To rebuild the students page(previous screen) by notifyListeners in the provider
      provider.preparingStudents();
      widget.checkForUpdate ? updateStudent() : addStudent();
      Navigator.pop(context);
    }
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        userNameValidate = true;
        userDescriptionValidate = true;
        userBirthdateValidate = true;
        userHoursValidate = true;
      });
      return false;
    }
    setState(() {
      userNameValidate = false;
      userDescriptionValidate = false;
      userBirthdateValidate = false;
      userHoursValidate = false;
    });
    return true;
  }

  updateStudent() {
    FirestoreStudents().updateStudent(
      name: widget.controllerOfName.text,
      description: widget.controllerOfDescription.text,
      volunteeringHours: widget.controllerOfHours.text,
      date: widget.controllerOfBirthdate.text,
      studentDocId: widget.studentDocId,
    );
  }

  addStudent() {
    FirestoreStudents().addStudent(
      name: widget.controllerOfName.text,
      description: widget.controllerOfDescription.text,
      volunteeringHours: widget.controllerOfHours.text,
      date: widget.controllerOfBirthdate.text,
    );
  }

  Expanded buildTextFields() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: buildTextFieldsColumn(),
        ),
      ),
    );
  }

  Column buildTextFieldsColumn() {
    return Column(
      //I can't replace divider with (space between) or any something else
      children: [
        const Divider(),
        buildTextFormField(widget.controllerOfName, "Name"),
        const Divider(),
        buildTextFormField(widget.controllerOfDescription, "Description"),
        const Divider(),
        buildTextFormField(widget.controllerOfBirthdate, "Birthdate"),
        const Divider(),
        widget.checkForUpdate
            ? buildTextFormField(widget.controllerOfHours, "Volunteering Hours")
            : const Divider(),
        widget.checkForUpdate ? showMembershipsButton() : emptyMessage(),
      ],
    );
  }

  ElevatedButton showMembershipsButton() {
    return ElevatedButton(
        onPressed: () => onPressedMemberships(), child: membershipsText());
  }

  Text membershipsText() {
    return const Text(
      "memberships",
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  onPressedMemberships() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //get memberships ready
      SeasonsLogic provider = context.read<SeasonsLogic>();
      provider.stateOfFetchingMemberships = StateOfMemberships.initial;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MembershipsOfStudent(widget.studentDocId)));
    });
  }

  Column emptyMessage() {
    return Column(
      children: const [
        Text("save the student first"),
        Text("and then you can select memberships !")
      ],
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String text) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: text,
          errorText: userNameValidate ? "invalid $text" : null),
    );
  }
}
