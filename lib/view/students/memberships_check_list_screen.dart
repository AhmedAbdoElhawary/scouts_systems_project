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
    SeasonsLogic provider = context.watch<SeasonsLogic>();
    return buildScaffold(provider.remainingMemberships);
  }

  Scaffold buildScaffold(List<Memberships> seasonsList) {
    return Scaffold(
      appBar: AppBar(),
      body: seasonsList.isEmpty
          ? emptyMessage("season")
          : buildListView(seasonsList),
      floatingActionButton: _buildSelectAllButton(seasonsList),
    );
  }

  ListView buildListView(List<Memberships> seasonsList) {
    return ListView.builder(
      itemBuilder: (builder, index) {
        selectedFlag[index] = selectedFlag[index] ?? false;
        bool? isSelected = selectedFlag[index];
        return Column(
          children: [
            buildListTile(isSelected, index, seasonsList),
          ],
        );
      },
      itemCount: seasonsList.length,
    );
  }

  ListTile buildListTile(
      bool? isSelected, int index, List<Memberships> seasonsList) {
    return ListTile(
      onTap: () => onTap(isSelected!, index),
      leading: _buildSelectIcon(isSelected!),
      title: Text(seasonsList[index].year),
      subtitle: Text(seasonsList[index].seasonType),
    );
  }

  void onTap(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  Widget _buildSelectIcon(bool isSelected) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
    );
  }

  Widget? _buildSelectAllButton(List<Memberships> seasonsList) {
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

  Future<void> addItems(List<Memberships> seasonsList) async {
    for (int i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i] == true) {
        FirestoreStudents().addMembership(
            seasonDocId: seasonsList[i].docId,
            studentDocId: widget.studentDocId);
        FirestoreSeasons().addStudentInSeason(
            studentDocId: widget.studentDocId,
            seasonDocId: seasonsList[i].docId);
      }
    }
    context.read<SeasonsLogic>().preparingMemberships(widget.studentDocId);
    context.read<SeasonsLogic>().stateOfFetchingMemberships ==
        StateOfMemberships.initial;
    Navigator.pop(context);
  }
}
