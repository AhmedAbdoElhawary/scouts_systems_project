import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/primary_color.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';
import 'package:scouts_system/model/firestore/add_students.dart';
import 'package:scouts_system/view_model/seasons.dart';

class StudentCheckBoxMemberships extends StatefulWidget {
  String studentId;
  List<QueryDocumentSnapshot<Object?>> listOfMemberships;
  StudentCheckBoxMemberships(this.studentId,this.listOfMemberships);
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

    return Scaffold(
      appBar: AppBar(backgroundColor: customColor()),
      body:widget.listOfMemberships.length==0?
      buildShowMessage("season"):
      ListView.builder(
        itemBuilder: (builder, index) {
          selectedFlag[index] = selectedFlag[index] ?? false;
          bool? isSelected = selectedFlag[index];

          return Column(
            children: [
              ListTile(
                onTap: () => onTap(isSelected!, index),
                leading: _buildSelectIcon(isSelected!),
                title: Text("${widget.listOfMemberships[index]["year"]}"),
                subtitle: Text("${widget.listOfMemberships[index]["season"]}"),
              ),
            ],
          );
        },
        itemCount: widget.listOfMemberships.length,
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
      color: customColor(),
    );
  }

  Widget? _buildSelectAllButton() {
    if (isSelectionMode) {
      return FloatingActionButton(
        backgroundColor: customColor(),
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
