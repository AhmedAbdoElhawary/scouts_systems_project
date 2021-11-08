import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/custom_container_students.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class StudentSeasonsPage extends StatelessWidget {
  List<dynamic> studentsDocIds;
  StudentSeasonsPage({Key? key, required this.studentsDocIds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    StudentsLogic provider = context.watch<StudentsLogic>();
    if (studentsDocIds.isNotEmpty&&provider.specificStudents.isEmpty &&
        provider.stateOfSpecificFetching != StateOfSpecificStudents.loaded) {
      provider.preparingSpecificStudents(studentsDocIds: studentsDocIds);
      return const CircularProgress();
    } else {
      return buildScaffold(provider);
    }
  }

  Scaffold buildScaffold(StudentsLogic provider) {
    return Scaffold(
        appBar: AppBar(),
        body: provider.specificStudents.isEmpty
            ? emptyMessage("student")
            : buildListView(provider));
  }

  ListView buildListView(StudentsLogic provider) {
    return ListView.separated(
      itemCount: provider.specificStudents.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return buildListTile(provider, index);
      },
    );
  }

  ListTile buildListTile(StudentsLogic provider, int index) {
    return ListTile(
      title: buildTheItemOfTheList(provider.specificStudents[index], index),
    );
  }

  SafeArea buildTheItemOfTheList(var model, int index) {
    return SafeArea(
      child: InkWell(
        onTap: () async {},
        child: CustomContainerStudents(modelStudents: model, index: index),
      ),
    );
  }
}
