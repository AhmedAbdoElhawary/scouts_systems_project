import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class SelectStudentsScreen extends StatefulWidget {
 final String seasonDocId,eventDocId;
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
    StudentsProvider provider = context.watch<StudentsProvider>();
    return buildScaffold(provider.remainingStudents);
  }

  Scaffold buildScaffold(List<Student> remainingStudents) {
    return Scaffold(
      appBar: AppBar(),
      body: remainingStudents.isEmpty
          ? emptyMessage("student")
          : listView(remainingStudents),
      floatingActionButton: _floatingActionButton(remainingStudents),
    );
  }

  ListView listView(List<Student> remainingStudents) {
    return ListView.builder(
      itemBuilder: (builder, index) {
        selectedFlag[index] = selectedFlag[index] ?? false;
        bool? isSelected = selectedFlag[index];
        return listTile(remainingStudents, isSelected, index);
      },
      itemCount: remainingStudents.length,
    );
  }

  ListTile listTile(
      List<Student> remainingStudents, bool? isSelected, int index) {
    return ListTile(
      onTap: () => onTapTitle(isSelected!, index),
      leading: _selectIcon(isSelected!, index),
      title: Text(remainingStudents[index].name),
      subtitle: Text(remainingStudents[index].description),
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
    );
  }

  Widget? _floatingActionButton(List<Student> remainingStudents) {
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

  addItems(List<Student> remainingStudents) {
    for (int i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i] == true) {
        FirestoreEvents().addStudentsInEvent(
            studentDocId: remainingStudents[i].docId,
            eventDocId: widget.eventDocId);
      }
    }
    addEventInSeason();
    updatePreviousScreenData();
    Navigator.pop(context);
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
