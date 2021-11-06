import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/custom_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';
import 'add_student_Item.dart';

class StudentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StudentsLogic provider = context.watch<StudentsLogic>();
    if (provider.studentsList.isEmpty &&
        provider.stateOfFetching != StateOfStudents.loading) {
      provider.preparingStudents();
      return CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, StudentsLogic provider) {
    return Scaffold(
      appBar: AppBar(),
      body: provider.studentsList.isEmpty
          ? emptyMessage("students")
          : buildListView(context, provider.studentsList),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  ListView buildListView(BuildContext context, List<Students> studentsList) {
    return ListView.separated(
      itemCount: studentsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: buildStudentItem(studentsList[index], index, context),
        );
      },
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => onPressedFloating(context), child: Icon(Icons.add));
  }

  onPressedFloating(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => studentInformationScreen(
                //default value(i can't make them with the constructor)
                // -------------------------------------->
                controllerOfName: TextEditingController(text: ""),
                controllerOfDescription: TextEditingController(text: ""),
                controllerOfBirthdate: TextEditingController(text: ""),
                controllerOfHours: TextEditingController(text: ""))));
    // --------------------------------------->
  }

  InkWell buildStudentItem(
      Students studentInfo, int index, BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(context, studentInfo),
      child: CustomContainer(index: index, model: studentInfo),
    );
  }

  onTapItem(BuildContext context, Students studentInfo) {
    //clear lists from previous data
    context.read<SeasonsLogic>().membershipsListCleared();
    context.read<SeasonsLogic>().seasonsListCleared();
    context.read<SeasonsLogic>().remainingMembershipsCleared();
    //------------------------------->
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => studentInformationScreen(
                controllerOfName: TextEditingController(text: studentInfo.name),
                controllerOfDescription:
                    TextEditingController(text: studentInfo.description),
                controllerOfBirthdate:
                    TextEditingController(text: studentInfo.birthdate),
                controllerOfHours:
                    TextEditingController(text: studentInfo.volunteeringHours),
                studentDocId: studentInfo.docId,
                checkForUpdate: true)));
  }
}
