import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/view%20model/studentsGetDataFirestore.dart';
import 'package:scouts_system/view/students/addStudentItem.dart';

class StudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<StudentsGetDataFirestore>().getAllStudentsData();

    List<QueryDocumentSnapshot> listOfStudentsData =
        context.watch<StudentsGetDataFirestore>().StudentsListOfData;

    return Scaffold(
      appBar: AppBar(),
      body: listOfStudentsData.length == 0
          ? buildShowMessage()
          : ListView.separated(
              itemCount: listOfStudentsData.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: buildTheItemOfTheList(listOfStudentsData[index], index,
                      listOfStudentsData[index]["docId"], context),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => moveToNewStudent("", "", false)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Center buildShowMessage() {
    return Center(
      child: Text(
        "there's no event(s) !",
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
    );
  }

  SafeArea buildTheItemOfTheList(
      QueryDocumentSnapshot model, int index, String studentDocId, context) {
    return SafeArea(
      child: InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      moveToNewStudent(model, studentDocId, true)));
        },
        child: buildContainer(model, index),
      ),
    );
  }

  addNewStudent moveToNewStudent(
      var model, String studentDocId, bool checkForUpdate) {
    return addNewStudent(
      controlName:
          TextEditingController(text: "${model == "" ? "" : model["name"]}"),
      studentDocId: studentDocId,
      controlDescription: TextEditingController(
          text: "${model == "" ? "" : model["description"]}"),
      checkForUpdate: checkForUpdate,
      controlDate:
          TextEditingController(text: "${model == "" ? "" : model["date"]}"),
      controlVolunteeringHours: TextEditingController(
          text: "${model == "" ? "" : model["volunteeringHours"]}"),
    );
  }

  Container buildContainer(QueryDocumentSnapshot model, int index) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(model, index),
          buildColumnOfNameDescription(model),
          buildColumnOfDateAndHours(model),
        ],
      ),
    );
  }

  Column buildColumnOfDateAndHours(QueryDocumentSnapshot model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(model, "volunteeringHours"),
        buildText(model, "date"),
      ],
    );
  }

  Text buildText(QueryDocumentSnapshot model, String text) {
    return Text(
      "${model[text]}",
      style: text != "name"
          ? TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic)
          : TextStyle(fontSize: 20, color: Colors.black),
    );
  }

  Expanded buildColumnOfNameDescription(QueryDocumentSnapshot model) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText(model, "name"),
            buildText(model, "description"),
          ],
        ),
      ),
    );
  }

  CircleAvatar buildCircleAvatarNumber(QueryDocumentSnapshot model, int index) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
