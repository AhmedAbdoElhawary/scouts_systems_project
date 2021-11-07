import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/custom_container_students.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view/events/select-students.dart';
import 'package:scouts_system/view_model/students.dart';

class StudentsEventPage extends StatelessWidget {
  String eventDocId;
  String seasonDocId;
  StudentsEventPage(
      {required this.eventDocId, required this.seasonDocId});

  Widget build(BuildContext context) {
    StudentsLogic provider = context.watch<StudentsLogic>();
    if (provider.selectedStudents.isEmpty &&
    provider.stateOfSelectedFetching != StateOfSelectedStudents.loaded) {
      provider.preparingStudentsInEvent(eventDocId:eventDocId,seasonDocId: seasonDocId);
      return CircularProgress();
    } else
    return buildScaffold(provider,context);
  }

  Scaffold buildScaffold(StudentsLogic provider,BuildContext context) {
    return Scaffold(
    appBar: AppBar(),
    body: provider.selectedStudents.isEmpty
        ? emptyMessage("student")
        :  buildListView(provider),
    floatingActionButton: buildFloatingActionButton(provider,context),
  );
  }
  
  FloatingActionButton buildFloatingActionButton(StudentsLogic provider,BuildContext context) {
    return FloatingActionButton(
    onPressed: () async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectStudentsList(
                seasonDocId: seasonDocId,
                    eventDocId: eventDocId,
                  remainingStudents: provider.remainingStudents,
                  )));
    },
    child: Icon(Icons.add),
  );
  }

  ListView buildListView(StudentsLogic provider) {
    return ListView.separated(
    itemCount: provider.selectedStudents.length,
    separatorBuilder: (BuildContext context, int index) => const Divider(),
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: buildTheItemOfTheList(
            provider.selectedStudents[index], index),
      );
    },
  );
  }

  SafeArea buildTheItemOfTheList(Students model, int index) {
    return SafeArea(
      child: InkWell(
        onTap: () async {  },
        child:CustomContainerStudents(modelStudents: model,index: index)
      ),
    );
  }
}
