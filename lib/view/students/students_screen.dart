import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/students.dart';

import 'add_student.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StudentsLogic provider = context.watch<StudentsLogic>();
    if (provider.studentsList.isEmpty &&
        provider.stateOfFetching != StateOfStudents.loaded) {
      provider.preparingStudents();
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, StudentsLogic provider) {
    return Scaffold(
      appBar: AppBar(),
      body: provider.studentsList.isEmpty
          ? emptyMessage("students")
          : listView(context, provider.studentsList),
      floatingActionButton: floatingActionButton(context),
    );
  }

  ListView listView(BuildContext context, List<Students> studentsList) {
    return ListView.separated(
      itemCount: studentsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: studentItem(studentsList[index], index, context),
        );
      },
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => onPressedFloating(context),
        child: const Icon(Icons.add));
  }

  onPressedFloating(BuildContext context) {
    return Navigator.push(context,
        MaterialPageRoute(builder: (context) => studentInfoScreenFloating()));
  }

  StudentInformationScreen studentInfoScreenFloating() {
    return StudentInformationScreen(
        //default value(i can't make them with the constructor)
        controllerOfName: TextEditingController(text: ""),
        controllerOfDescription: TextEditingController(text: ""),
        birthdate: "Select Date",
        controllerOfHours: TextEditingController(text: ""));
    // -------------------------------------->
  }

  InkWell studentItem(Students studentInfo, int index, BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(context, studentInfo),
      child: primaryContainer(index, studentInfo),
    );
  }

  PrimaryContainer primaryContainer(int index, Students studentInfo) {
    return PrimaryContainer(
        index: index,
        rightTopText: studentInfo.name,
        rightBottomText: studentInfo.description,
        leftTopText: studentInfo.volunteeringHours,
        leftBottomText: studentInfo.birthdate);
  }

  onTapItem(BuildContext context, Students studentInfo) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => studentInfoScreenItem(studentInfo)));
  }

  StudentInformationScreen studentInfoScreenItem(Students studentInfo) {
    return StudentInformationScreen(
        controllerOfName: TextEditingController(text: studentInfo.name),
        controllerOfDescription:
            TextEditingController(text: studentInfo.description),
        birthdate: studentInfo.birthdate,
        controllerOfHours:
            TextEditingController(text: studentInfo.volunteeringHours),
        studentDocId: studentInfo.docId,
        checkForUpdate: true);
  }
}
