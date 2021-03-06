import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/show_dialog_image.dart';
import 'package:scouts_system/view_model/students.dart';
import 'student_info.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fetchingStudents(context);
  }

  Widget fetchingStudents(BuildContext context) {
    StudentsProvider provider = context.watch<StudentsProvider>();
    if (provider.studentsList.isEmpty &&
        provider.stateOfFetching != StateOfStudents.loaded) {
      provider.preparingStudents();
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, StudentsProvider provider) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students")),
      body: provider.studentsList.isEmpty
          ? emptyMessage("students")
          : listView(context, provider.studentsList),
      floatingActionButton: floatingActionButton(context),
    );
  }

  ListView listView(BuildContext context, List<Student> studentsList) {
    return ListView.separated(
      itemCount: studentsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            leading: circleAvatarOfImage(context, studentsList, index),
            title: studentItem(studentsList[index], index, context));
      },
    );
  }

  InkWell circleAvatarOfImage(
      BuildContext context, List<Student> studentsList, int index) {
    return InkWell(
        onTap: () => showDialogImage(context, studentsList[index].imageUrl),
        child: circleAvatarOfStudent(studentsList[index].imageUrl));
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => pushStudentInfoScreen(context),
        child: const Icon(Icons.add));
  }

  pushStudentInfoScreen(BuildContext context) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => studentInfoScreen()));
  }

  StudentInformationScreen studentInfoScreen() {
    return StudentInformationScreen(
        //default values(i can't make them with the constructor)
        controllerOfName: TextEditingController(text: ""),
        controllerOfDescription: TextEditingController(text: ""),
        birthdate: "Select Date",
        controllerOfHours: TextEditingController(text: ""));
  }

  InkWell studentItem(Student studentInfo, int index, BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(context, studentInfo, index),
      child: studentListItem(index, studentInfo),
    );
  }

  PrimaryListItem studentListItem(int index, Student studentInfo) {
    return PrimaryListItem(
      index: index,
      rightTopText: studentInfo.name,
      rightBottomText: studentInfo.description,
      leftTopText: studentInfo.volunteeringHours,
      leftBottomText: studentInfo.birthdate,
      isStudentSelected: false,
      studentImageUrl: studentInfo.imageUrl,
    );
  }

  onTapItem(BuildContext context, Student studentInfo, int index) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => studentInfoScreenItem(studentInfo)));
  }

  StudentInformationScreen studentInfoScreenItem(Student studentInfo) {
    return StudentInformationScreen(
      controllerOfName: TextEditingController(text: studentInfo.name),
      controllerOfDescription:
          TextEditingController(text: studentInfo.description),
      birthdate: studentInfo.birthdate,
      controllerOfHours:
          TextEditingController(text: studentInfo.volunteeringHours),
      studentDocId: studentInfo.docId,
      checkForUpdate: true,
      imageUrl: studentInfo.imageUrl,
      reportUrl: studentInfo.reportUrl,
      stateOfTheReport: studentInfo.stateOfTheReport,
      theReportName: studentInfo.theReportName,
    );
  }
}
