import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';
import 'package:scouts_system/model/firestore/add_students.dart';
import 'package:scouts_system/view_model/seasons.dart';

// ignore: must_be_immutable
class StudentCheckBoxMemberships extends StatefulWidget {
  String studentDocId;
  StudentCheckBoxMemberships(this.studentDocId, {Key? key}) : super(key: key);
  @override
  _StudentCheckBoxMembershipsState createState() =>
      _StudentCheckBoxMembershipsState();
}

class _StudentCheckBoxMembershipsState
    extends State<StudentCheckBoxMemberships> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  @override
  Widget build(BuildContext context) {
    SeasonsProvider provider = context.watch<SeasonsProvider>();
    return buildScaffold(provider.remainingMemberships);
  }

  Scaffold buildScaffold(List<Membership> seasonsList) {
    return Scaffold(
      appBar: AppBar(),
      body:
          seasonsList.isEmpty ? emptyMessage("season") : listView(seasonsList),
      floatingActionButton: _floatingActionButton(seasonsList),
    );
  }

  ListView listView(List<Membership> seasonsList) {
    return ListView.builder(
      itemBuilder: (builder, index) {
        selectedFlag[index] = selectedFlag[index] ?? false;
        bool? isSelected = selectedFlag[index];
        return Column(
          children: [
            listTile(isSelected, index, seasonsList),
          ],
        );
      },
      itemCount: seasonsList.length,
    );
  }

  ListTile listTile(bool? isSelected, int index, List<Membership> seasonsList) {
    return ListTile(
      onTap: () => onTapTitle(isSelected!, index),
      leading: _selectIcon(isSelected!),
      title: Text(seasonsList[index].year),
      subtitle: Text(seasonsList[index].seasonType),
    );
  }

  void onTapTitle(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  Widget _selectIcon(bool isSelected) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
    );
  }

  Widget? _floatingActionButton(List<Membership> seasonsList) {
    if (isSelectionMode) {
      return FloatingActionButton(
        onPressed: () => addItems(seasonsList),
        child: const Icon(
          Icons.add,
        ),
      );
    } else {
      return null;
    }
  }

  Future<void> addItems(List<Membership> seasonsList) async {
    for (int i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i] == true) {
        addMembership(seasonsList[i].docId);
        addStudentInSeason(seasonsList[i].docId);
      }
    }
    updatePreviousScreenData();
    Navigator.pop(context);
  }

  addMembership(String seasonDocId) {
    FirestoreStudents().addMembership(
        seasonDocId: seasonDocId, studentDocId: widget.studentDocId);
  }

  addStudentInSeason(String seasonDocId) {
    FirestoreSeasons().addStudentInSeason(
        studentDocId: widget.studentDocId, seasonDocId: seasonDocId);
  }

  updatePreviousScreenData() {
    SeasonsProvider seasonsProvider = context.read<SeasonsProvider>();
    seasonsProvider.preparingMemberships(widget.studentDocId);
    seasonsProvider.stateOfFetchingMemberships == StateOfMemberships.initial;
  }
}
