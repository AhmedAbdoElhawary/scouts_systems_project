import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view/events/select_students.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class StudentsEventPage extends StatelessWidget {
  String eventDocId, seasonDocId;
  StudentsEventPage(
      {Key? key, required this.eventDocId, required this.seasonDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fetchingSelectedStudents(context);
  }

  fetchingSelectedStudents(BuildContext context) {
    StudentsProvider provider = context.watch<StudentsProvider>();
    if (provider.selectedStudents.isEmpty &&
        provider.stateOfSelectedFetching != StateOfSelectedStudents.loaded) {
      provider.preparingStudentsInEvent(
          eventDocId: eventDocId, seasonDocId: seasonDocId);
      return const CircularProgress();
    } else {
      return buildScaffold(provider, context);
    }
  }

  Scaffold buildScaffold(StudentsProvider provider, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students")),
      body: provider.selectedStudents.isEmpty
          ? emptyMessage("student")
          : listView(provider),
      floatingActionButton: floatingActionButton(provider, context),
    );
  }

  FloatingActionButton floatingActionButton(
      StudentsProvider provider, BuildContext context) {
    return FloatingActionButton(
      onPressed: () => pushToSelectStudentsPage(context),
      child: const Icon(Icons.edit),
    );
  }

  pushToSelectStudentsPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectStudentsScreen(
                  seasonDocId: seasonDocId,
                  eventDocId: eventDocId,
                )));
  }

  ListView listView(StudentsProvider provider) {
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

  SafeArea listTitleItem(Student model, int index) {
    return SafeArea(
      child: InkWell(onTap: () {}, child: listTitleItemBody(index, model)),
    );
  }

  PrimaryListItem listTitleItemBody(int index, Student model) {
    return PrimaryListItem(
      index: index,
      rightTopText: model.name,
      rightBottomText: model.description,
      leftTopText: model.volunteeringHours,
      leftBottomText: model.birthdate,
      isStudentSelected: true,
      studentImageUrl: model.imageUrl,
    );
  }
}
