import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container_students.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view/events/select_students.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class StudentsEventPage extends StatelessWidget {
  String eventDocId;
  String seasonDocId;
  StudentsEventPage(
      {Key? key, required this.eventDocId, required this.seasonDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      //fetching data
    StudentsLogic provider = context.watch<StudentsLogic>();
    if (provider.selectedStudents.isEmpty &&
        provider.stateOfSelectedFetching != StateOfSelectedStudents.loaded) {
      provider.preparingStudentsInEvent(
          eventDocId: eventDocId, seasonDocId: seasonDocId);
      //------------>
      return const CircularProgress();
    } else {
      return buildScaffold(provider, context);
    }
  }

  Scaffold buildScaffold(StudentsLogic provider, BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: provider.selectedStudents.isEmpty
          ? emptyMessage("student")
          : listView(provider),
      floatingActionButton: floatingActionButton(provider, context),
    );
  }

  FloatingActionButton floatingActionButton(
      StudentsLogic provider, BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressedFloating(context),
      child: const Icon(Icons.add),
    );
  }

  onPressedFloating(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectStudentsList(
                  seasonDocId: seasonDocId,
                  eventDocId: eventDocId,
                )));
  }

  ListView listView(StudentsLogic provider) {
    return ListView.separated(
      itemCount: provider.selectedStudents.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: listTitleItem(provider.selectedStudents[index], index),
        );
      },
    );
  }

  SafeArea listTitleItem(Students model, int index) {
    return SafeArea(
      child: InkWell(
          onTap: () async {},
          child: PrimaryContainerStudents(modelStudents: model, index: index)),
    );
  }
}
