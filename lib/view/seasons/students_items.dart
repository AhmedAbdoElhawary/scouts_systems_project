import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class StudentSeasonsPage extends StatelessWidget {
  final List<dynamic> studentsDocIds;
  final String seasonDocId;
  StudentSeasonsPage({Key? key, required this.studentsDocIds,required this.seasonDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fetchingNeededStudents(context);
  }

  fetchingNeededStudents(BuildContext context) {
    StudentsProvider provider = context.watch<StudentsProvider>();
    if (studentsDocIds.isNotEmpty &&
        provider.neededStudents.isEmpty &&
        provider.stateOfSpecificFetching != StateOfSpecificStudents.loaded) {
      provider.preparingNeededStudents(studentsDocIds: studentsDocIds,seasonDocId:seasonDocId);
      return const CircularProgress();
    } else {
      return buildScaffold(provider);
    }
  }

  Scaffold buildScaffold(StudentsProvider provider) {
    return Scaffold(
        appBar: AppBar(title: Text("Students")),
        body: provider.neededStudents.isEmpty
            ? emptyMessage("student")
            : listView(provider));
  }

  ListView listView(StudentsProvider provider) {
    return ListView.separated(
      itemCount: provider.neededStudents.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return listTile(provider, index);
      },
    );
  }

  ListTile listTile(StudentsProvider provider, int index) {
    return ListTile(
      title: listItem(provider.neededStudents[index], index),
    );
  }

  InkWell listItem(Student model, int index) {
    return InkWell(
      onTap: () {},
      child: studentContainerBody(index, model),
    );
  }

  PrimaryListItem studentContainerBody(int index, Student model) {
    return PrimaryListItem(
        index: index,
        rightTopText: model.name,
        rightBottomText: model.description,
        leftTopText: model.volunteeringHours,
        leftBottomText: model.birthdate);
  }
}
