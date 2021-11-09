import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class StudentSeasonsPage extends StatelessWidget {
  List<dynamic> studentsDocIds;
  StudentSeasonsPage({Key? key, required this.studentsDocIds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //fetching data
    StudentsLogic provider = context.watch<StudentsLogic>();
    if (studentsDocIds.isNotEmpty &&
        provider.specificStudents.isEmpty &&
        provider.stateOfSpecificFetching != StateOfSpecificStudents.loaded) {
      provider.preparingSpecificStudents(studentsDocIds: studentsDocIds);
      //------------>
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
            : listView(provider));
  }

  ListView listView(StudentsLogic provider) {
    return ListView.separated(
      itemCount: provider.specificStudents.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return listTile(provider, index);
      },
    );
  }

  ListTile listTile(StudentsLogic provider, int index) {
    return ListTile(
      title: listTitleItem(provider.specificStudents[index], index),
    );
  }

  SafeArea listTitleItem(Students model, int index) {
    return SafeArea(
      child: InkWell(
        onTap: () async {},
        child: primaryContainer(index, model),
      ),
    );
  }

  PrimaryContainer primaryContainer(int index, Students model) {
    return PrimaryContainer(
          index: index,
          rightTopText: model.name,
          rightBottomText: model.description,
          leftTopText: model.volunteeringHours,
          leftBottomText: model.birthdate);
  }
}
