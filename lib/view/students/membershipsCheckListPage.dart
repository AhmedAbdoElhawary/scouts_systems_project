import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/model/add%20data%20firestore/addFirestoreSeasons.dart';
import 'package:scouts_system/model/add%20data%20firestore/addFirestoreStudents.dart';
import 'package:scouts_system/view%20model/seasonsGetDataFirestore.dart';

class StudentCheckBoxMemberships extends StatefulWidget {
  String studentId;
  StudentCheckBoxMemberships(this.studentId);
  @override
  _StudentCheckBoxMembershipsState createState() =>
      _StudentCheckBoxMembershipsState();
}

class _StudentCheckBoxMembershipsState
    extends State<StudentCheckBoxMemberships> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<SeasonsGetDataFirestore>().getAllSeasonsData();

    List<QueryDocumentSnapshot<Object?>> listOfMemberships =
        context.watch<SeasonsGetDataFirestore>().seasonsListOfAllData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Item(s)'),
      ),
      body: ListView.builder(
        itemBuilder: (builder, index) {
          selectedFlag[index] = selectedFlag[index] ?? false;
          bool? isSelected = selectedFlag[index];

          return Column(
            children: [
              ListTile(
                onTap: () => onTap(isSelected!, index),
                leading: _buildSelectIcon(isSelected!),
                title: Text("${listOfMemberships[index]["year"]}"),
                subtitle: Text("${listOfMemberships[index]["season"]}"),
              ),
            ],
          );
        },
        itemCount: listOfMemberships.length,
      ),
      floatingActionButton: _buildSelectAllButton(),
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
      color: Theme.of(context).primaryColor,
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


  Future<void> addItems() async {
    List<QueryDocumentSnapshot<Object?>> listOfMemberships =
        Provider.of<SeasonsGetDataFirestore>(context, listen: false)
            .seasonsListOfAllData;
    for (int i = 0; i < selectedFlag.length; i++) {
      if (selectedFlag[i] == true) {
        addFirestoreStudents().addInFieldMemberships(
            seasonDocId: listOfMemberships[i]["docId"],
            studentDocId: widget.studentId);
        addFirestoreSeasons().addNewStudentInSeason(
             studentDocId: widget.studentId,seasonDocId:listOfMemberships[i]["docId"]);
      }
    }
    Navigator.pop(context);
  }
}
