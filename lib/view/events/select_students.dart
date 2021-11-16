import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class SelectStudentsScreen extends StatefulWidget {
  final String seasonDocId, eventDocId;
  SelectStudentsScreen(
      {Key? key, required this.eventDocId, required this.seasonDocId})
      : super(key: key);

  @override
  _SelectStudentsScreenState createState() => _SelectStudentsScreenState();
}

class _SelectStudentsScreenState extends State<SelectStudentsScreen> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context.watch<StudentsProvider>());
  }

  Scaffold buildScaffold(StudentsProvider seasonsProvider) {
    return Scaffold(
      appBar: AppBar(title: Text("Students")),
      body: seasonsProvider.studentsOfEvent.isEmpty
          ? emptyMessage("student")
          : listView(seasonsProvider),
      floatingActionButton:
          _floatingActionButton(seasonsProvider.studentsOfEvent),
    );
  }

  ListView listView(StudentsProvider seasonsProvider) {
    return ListView.builder(
      itemBuilder: (builder, index) {
        bool checkSelection = seasonsProvider.selectedStudentsIds
            .contains(seasonsProvider.studentsOfEvent[index].docId);

        selectedFlag[index] = selectedFlag[index] ?? checkSelection;
        bool? isSelected = selectedFlag[index];
        return listTile(seasonsProvider.studentsOfEvent, isSelected, index);
      },
      itemCount: seasonsProvider.studentsOfEvent.length,
    );
  }

  ListTile listTile(
      List<Student> studentsOfEvent, bool? isSelected, int index) {
    return ListTile(
      onTap: () => onTapTitle(isSelected!, index),
      leading: _selectIcon(isSelected!, index),
      title: Text(studentsOfEvent[index].name),
      subtitle: Text(studentsOfEvent[index].description),
    );
  }

  void onTapTitle(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  Widget _selectIcon(bool isSelected, int index) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
      color: Colors.blue,
    );
  }

  Widget? _floatingActionButton(List<Student> students) {
    return FloatingActionButton(
      onPressed: () => addItems(students),
      child: const Icon(
        Icons.add,
      ),
    );
  }

  addItems(List<Student> students) {
    for (int i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i] == true) {
        FirestoreEvents().addStudentsInEvent(
            studentDocId: students[i].docId, eventDocId: widget.eventDocId);
      } else {
        deleteStudentOfEvent(
            studentDocId: students[i].docId, eventDocId: widget.eventDocId);
      }
    }
    addEventInSeason();
    updatePreviousScreenData();
    Navigator.pop(context);
  }

  deleteStudentOfEvent(
      {required String eventDocId, required String studentDocId}) {
    FirestoreEvents().deleteStudentOfEvent(
        eventDocId: eventDocId, studentDocId: studentDocId);
  }

  updatePreviousScreenData() {
    StudentsProvider provider = context.read<StudentsProvider>();
    provider.preparingStudentsInEvent(
        eventDocId: widget.eventDocId, seasonDocId: widget.seasonDocId);
    provider.stateOfSelectedFetching = StateOfSelectedStudents.initial;
  }

  addEventInSeason() {
    FirestoreSeasons().addEventInSeason(
        seasonDocId: widget.seasonDocId, eventDocId: widget.eventDocId);
  }
}
