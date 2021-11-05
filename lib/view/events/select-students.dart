import 'package:flutter/material.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/primary_color.dart';
import 'package:scouts_system/common_ui/toast_show.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';

class SelectStudentsList extends StatefulWidget {
  List<int> IndexesOfStudents;
  List<dynamic> listOfAllStudents;
  String year;
  String season;
  String eventDocId;
  SelectStudentsList(
      {required this.eventDocId,
      required this.year,
      required this.season,
      required this.IndexesOfStudents,
      required this.listOfAllStudents});

  @override
  _SelectStudentsListState createState() => _SelectStudentsListState();
}

class _SelectStudentsListState extends State<SelectStudentsList> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: customColor()),
      body: widget.IndexesOfStudents.length == 0
          ? buildShowMessage("student")
          : ListView.builder(
              itemBuilder: (builder, index) {
                selectedFlag[index] = selectedFlag[index] ?? false;
                bool? isSelected = selectedFlag[index];
                return ListTile(
                  onTap: () => onTap(isSelected!, index),
                  leading: _buildSelectIcon(
                      isSelected!,
                      widget.listOfAllStudents[widget.IndexesOfStudents[index]],
                      index),
                  title: Text(
                      "${widget.listOfAllStudents[widget.IndexesOfStudents[index]]['name']}"),
                  subtitle: Text(
                      "${widget.listOfAllStudents[widget.IndexesOfStudents[index]]['description']}"),
                );
              },
              itemCount: widget.IndexesOfStudents.length,
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

  Widget _buildSelectIcon(bool isSelected, var data, int index) {
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
    for (int i = 0; i < selectedFlag.length; i++) {
      if (widget.listOfAllStudents[widget.IndexesOfStudents[i]].exists) {
        if (selectedFlag[i] == true) {
          addFirestoreEvents().addInFieldStudents(
              studentDocId: widget
                  .listOfAllStudents[widget.IndexesOfStudents[i]]["docId"],
              eventDocId: widget.eventDocId);
        }
      } else {
        ToastShow().showWhiteToast("user not exist !");
      }
    }
    addFirestoreSeasons().addNewEventInSeason(
        year: widget.year,
        season: widget.season,
        eventDocId: widget.eventDocId);

    Navigator.pop(context);
  }
}
