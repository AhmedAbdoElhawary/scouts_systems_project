import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common%20UI/showTheTextMessage.dart';
import 'package:scouts_system/view%20model/seasonsGetDataFirestore.dart';
import 'package:scouts_system/view%20model/studentsGetDataFirestore.dart';
import 'package:scouts_system/common%20UI/CustomWidgetMethods.dart';
import 'package:scouts_system/view/students/membershipsCheckListPage.dart';

class ListOfMembershipsStudent extends StatelessWidget {
  String studentId;
  ListOfMembershipsStudent(this.studentId);

  Widget build(BuildContext context) {
    context
        .read<StudentsGetDataFirestore>()
        .getStudentMembershipsData(studentId);

    List<dynamic> listOfMemberships =
        context
            .watch<StudentsGetDataFirestore>()
            .StudentMembershipsListOfData;

    List<dynamic> listOfAllSeasons =
        context
            .watch<SeasonsGetDataFirestore>()
            .seasonsListOfAllData;

    List<int> SpecificIndexesOfSeasonsData = [];

    for (int i = 0; i < listOfAllSeasons.length; i++) {
      if (listOfMemberships.contains(listOfAllSeasons[i]["docId"]))
        SpecificIndexesOfSeasonsData.add(i);
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: customColor()),
      body: SpecificIndexesOfSeasonsData.length == 0
          ? buildShowMessage("memberships")
          : ListView.separated(
        itemCount: SpecificIndexesOfSeasonsData.length,
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: buildTheItemOfTheList(
                listOfAllSeasons[SpecificIndexesOfSeasonsData[index]],
                index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customColor(),
        onPressed: () {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            List<QueryDocumentSnapshot<Object?>> listOfMemberships =
                context.watch<SeasonsGetDataFirestore>().seasonsListOfAllData;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StudentCheckBoxMemberships(studentId,listOfMemberships)));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea buildTheItemOfTheList(data, int index) {
    return SafeArea(
      child: InkWell(
        onTap: () async {},
        child: buildContainer(data, index),
      ),
    );
  }

  Container buildContainer(data, int index) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(index),
          buildColumnOfNameDescription(data),
        ],
      ),
    );
  }

  Expanded buildColumnOfNameDescription(data) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText(data, "year"),
            buildText(data, "season"),
          ],
        ),
      ),
    );
  }

  Text buildText(data, String text) {
    return Text(
      "${data[text]}",
      style: text != "year"
          ? TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic)
          : TextStyle(fontSize: 20, color: Colors.black),
    );
  }

  CircleAvatar buildCircleAvatarNumber(int index) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: customColor(),
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
