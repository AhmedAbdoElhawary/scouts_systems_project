import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/model/firestore/add_students.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';
import 'memberships_screen.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class StudentInformationScreen extends StatefulWidget {
  TextEditingController controllerOfName,
      controllerOfDescription,
      controllerOfHours;
  String birthdate, studentDocId;
  bool checkForUpdate;
  StudentInformationScreen(
      {Key? key,
      this.studentDocId = "",
      required this.birthdate,
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
  bool userHoursValidate = false;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.controllerOfName.text), actions: actionsWidgets()),
      body: Column(
        children: [
          textFields(),
          saveAndCancelButtons(context),
        ],
      ),
    );
  }

  List<Widget> actionsWidgets() {
    if (widget.studentDocId.isNotEmpty) {
      return [
        IconButton(
            onPressed: () {
              FirestoreStudents().deleteStudent(widget.studentDocId);
              updatePreviousScreenData();
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete))
      ];
    } else {
      return [];
    }
  }

  SizedBox saveAndCancelButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: rowOfButtons(context),
    );
  }

  Row rowOfButtons(BuildContext context) {
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
      child: TextButton(
          child: textOfSave(), onPressed: () => checkValidationFields()),
    );
  }

  Text textOfSave() {
    return const Text("Save",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  checkValidationFields() {
    if (validateTextField(widget.controllerOfName.text) &&
            validateTextField(widget.controllerOfDescription.text) &&
            widget.checkForUpdate
        ? validateTextField(widget.controllerOfHours.text)
        : true) {
      updatePreviousScreenData();
      widget.checkForUpdate ? updateStudent() : addStudent();
      Navigator.pop(context);
    }
  }

  updatePreviousScreenData() {
    StudentsProvider provider = context.read<StudentsProvider>();
    provider.preparingStudents();
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        userNameValidate = true;
        userDescriptionValidate = true;
        userHoursValidate = true;
      });
      return false;
    }
    setState(() {
      userNameValidate = false;
      userDescriptionValidate = false;
      userHoursValidate = false;
    });
    return true;
  }

  updateStudent() {
    FirestoreStudents().updateStudent(
      name: widget.controllerOfName.text,
      description: widget.controllerOfDescription.text,
      volunteeringHours: widget.controllerOfHours.text,
      date: getBirthdate(),
      studentDocId: widget.studentDocId,
    );
  }

  addStudent() {
    FirestoreStudents().addStudent(
      name: widget.controllerOfName.text,
      description: widget.controllerOfDescription.text,
      volunteeringHours: widget.controllerOfHours.text,
      date: getBirthdate(),
    );
  }

  Expanded textFields() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: textFieldsColumn(),
        ),
      ),
    );
  }

  Column textFieldsColumn() {
    return Column(
      //I can't replace divider with (space between) or any something else
      children: [
        const Divider(),
        textFormField(widget.controllerOfName, "Name"),
        const Divider(),
        textFormField(widget.controllerOfDescription, "Description"),
        columnOfPickDate(),
        const Divider(),
        widget.checkForUpdate
            ? textFormField(widget.controllerOfHours, "Volunteering Hours")
            : const Divider(),
        widget.checkForUpdate ? membershipsButton() : emptyMessage(),
      ],
    );
  }

  Column columnOfPickDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textOfBirthdate(),
        containerOfDate(),
      ],
    );
  }

  InkWell containerOfDate() {
    return InkWell(
      onTap: () => pickDate(context),
      child: containerBody(),
    );
  }

  Container containerBody() {
    return Container(
        width: double.infinity,
        height: 60,
        decoration: boxDecoration(),
        child: rowOfDate());
  }

  Row rowOfDate() {
    return Row(
      children: [getTextOfDate()],
    );
  }

  Expanded getTextOfDate() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(getBirthdate(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            textAlign: TextAlign.start),
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(6));
  }

  Padding textOfBirthdate() {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text("Birthdate"),
    );
  }

  String getBirthdate() {
    if (date == null) {
      return widget.birthdate;
    } else {
      return DateFormat('MM/dd/yyyy').format(date!);
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime(DateTime.now().year - 5);
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime(DateTime.now().year - 5),
    );
    if (newDate == null) return;
    setState(() => date = newDate);
  }

  ElevatedButton membershipsButton() {
    return ElevatedButton(
        onPressed: () => pushToMembershipsPage(), child: membershipsText());
  }

  Text membershipsText() {
    return const Text(
      "Memberships",
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  pushToMembershipsPage() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getReadyForMemberships();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MembershipsOfStudent(widget.studentDocId)));
    });
  }

  getReadyForMemberships() {
    SeasonsProvider provider = context.read<SeasonsProvider>();
    provider.stateOfFetchingMemberships = StateOfMemberships.initial;
    provider.clearMembershipsList();
    provider.clearStudentMembershipsList();
    provider.clearMembershipsIds();
  }

  Column emptyMessage() {
    return Column(
      children: const [
        Text("save the student first"),
        Text("and then you can select memberships !")
      ],
    );
  }

  TextFormField textFormField(TextEditingController controller, String text) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: text,
          errorText: userNameValidate ? "invalid $text" : null),
    );
  }
}
