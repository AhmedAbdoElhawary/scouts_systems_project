import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';
import 'package:scouts_system/view_model/students.dart';

class SelectStudentsList extends StatefulWidget {
  String seasonDocId;
  String eventDocId;
  List<Students> remainingStudents;
  SelectStudentsList(
      {required this.remainingStudents,
      required this.eventDocId,
      required this.seasonDocId});

  @override
  _SelectStudentsListState createState() => _SelectStudentsListState();
}

class _SelectStudentsListState extends State<SelectStudentsList> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: widget.remainingStudents.isEmpty
          ? emptyMessage("student")
          : buildListView(),
      floatingActionButton: _buildSelectAllButton(),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemBuilder: (builder, index) {
        selectedFlag[index] = selectedFlag[index] ?? false;
        bool? isSelected = selectedFlag[index];
        return buildListTile(isSelected, index);
      },
      itemCount: widget.remainingStudents.length,
    );
  }

  ListTile buildListTile(bool? isSelected, int index) {
    return ListTile(
        onTap: () => onTap(isSelected!, index),
        leading: _buildSelectIcon(isSelected!, index),
        title: Text("${widget.remainingStudents[index].name}"),
        subtitle: Text("${widget.remainingStudents[index].description}"),
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

  Widget? _buildSelectAllButton() {
    if (isSelectionMode) {
      return FloatingActionButton(
        onPressed: addItems,
        child: Icon(
          Icons.add,
        ),
      );
    } else {
      return null;
    }
  }

  addItems() {
    for (int i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i]=true) {
        addStudentsInEvent(i);
        addEventInSeason();
      }
    }
    //to clear the previous data
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

  addStudentsInEvent(int i) {
    FirestoreEvents().addStudentsInEvent(
          studentDocId: widget.remainingStudents[i].docId,
          eventDocId: widget.eventDocId);
  }

  getReadyTheData(){

  }

}