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
    return buildScaffold(context.watch<SeasonsProvider>());
  }

  Scaffold buildScaffold(SeasonsProvider seasonsProvider) {
    return Scaffold(
      appBar: AppBar(title: Text("Memberships")),
      body: seasonsProvider.studentMemberships.isEmpty
          ? emptyMessage("season")
          : listView(seasonsProvider),
      floatingActionButton:
          _floatingActionButton(seasonsProvider.studentMemberships),
    );
  }

  ListView listView(SeasonsProvider seasonsProvider) {
    return ListView.builder(
      itemBuilder: (builder, index) {
        bool checkSelection = seasonsProvider.selectedMembershipsIds
            .contains(seasonsProvider.studentMemberships[index].docId);
        selectedFlag[index] = selectedFlag[index] ?? checkSelection;
        bool? isSelected = selectedFlag[index];
        return Column(
          children: [
            listTile(isSelected, index, seasonsProvider.studentMemberships),
          ],
        );
      },
      itemCount: seasonsProvider.studentMemberships.length,
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
      color: Colors.blue,
    );
  }

  Widget? _floatingActionButton(List<Membership> seasonsList) {
    // if (isSelectionMode) {
    return FloatingActionButton(
      onPressed: () => addItems(seasonsList),
      child: const Icon(
        Icons.add,
      ),
    );
    // } else {
    //   return null;
    // }
  }

  Future<void> addItems(List<Membership> seasonsList) async {
    for (int i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i] == true) {
        addMembership(seasonsList[i].docId);
        addStudentInSeason(seasonsList[i].docId);
      } else {
        deleteMembership(seasonsList[i], i);
        deleteStudentInSeason(seasonsList[i], i);
      }
    }
    updatePreviousScreenData();
    Navigator.pop(context);
  }

  deleteStudentInSeason(Membership membership, int index) {
    FirestoreSeasons().deleteStudentInSeason(
        studentDocId: widget.studentDocId, seasonDocId: membership.docId);
  }

  deleteMembership(Membership membership, int index) {
    FirestoreStudents().deleteMembership(
        seasonDocId: membership.docId, studentDocId: widget.studentDocId);
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
