import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class SelectStudentsList extends StatefulWidget {
  String seasonDocId;
  String eventDocId;
  SelectStudentsList(
      {Key? key, required this.eventDocId, required this.seasonDocId})
      : super(key: key);

  @override
  _SelectStudentsListState createState() => _SelectStudentsListState();
}

class _SelectStudentsListState extends State<SelectStudentsList> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  @override
  Widget build(BuildContext context) {
    StudentsLogic provider = context.watch<StudentsLogic>();
    return buildScaffold(provider.remainingStudents);
  }

  Scaffold buildScaffold(List<Students> remainingStudents) {
    return Scaffold(
      appBar: AppBar(),
      body: remainingStudents.isEmpty
          ? emptyMessage("student")
          : buildListView(remainingStudents),
      floatingActionButton: _buildSelectAllButton(remainingStudents),
    );
  }

  ListView buildListView(List<Students> remainingStudents) {
    return ListView.builder(
      itemBuilder: (builder, index) {
        selectedFlag[index] = selectedFlag[index] ?? false;
        bool? isSelected = selectedFlag[index];
        return buildListTile(remainingStudents, isSelected, index);
      },
      itemCount: remainingStudents.length,
    );
  }

  ListTile buildListTile(
      List<Students> remainingStudents, bool? isSelected, int index) {
    return ListTile(
      onTap: () => onTap(isSelected!, index),
      leading: _buildSelectIcon(isSelected!, index),
      title: Text(remainingStudents[index].name),
      subtitle: Text(remainingStudents[index].description),
    );
  }

  void onTap(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  Widget _buildSelectIcon(bool isSelected, int index) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
    );
  }

  Widget? _buildSelectAllButton(List<Students> remainingStudents) {
    if (isSelectionMode) {
      return FloatingActionButton(
        onPressed: () => addItems(remainingStudents),
        child: const Icon(
          Icons.add,
        ),
      );
    } else {
      return null;
    }
  }

  addItems(List<Students> remainingStudents) {
    for (int i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i] == true) {
        FirestoreEvents().addStudentsInEvent(
            studentDocId: remainingStudents[i].docId,
            eventDocId: widget.eventDocId);
      }
    }
    addEventInSeason();
    //to update the previous data
    StudentsLogic provider = context.read<StudentsLogic>();
    provider.preparingStudentsInEvent(
        eventDocId: widget.eventDocId, seasonDocId: widget.seasonDocId);
    provider.stateOfSelectedFetching = StateOfSelectedStudents.initial;
    //------------------------->
    Navigator.pop(context);
  }

  addEventInSeason() {
    FirestoreSeasons().addEventInSeason(
        seasonDocId: widget.seasonDocId, eventDocId: widget.eventDocId);
  }
}
