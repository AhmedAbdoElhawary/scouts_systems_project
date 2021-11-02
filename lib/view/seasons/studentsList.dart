import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/view%20model/seasonsGetDataFirestore.dart';
import 'package:scouts_system/view%20model/studentsGetDataFirestore.dart';

class StudentListInSeasonsPage extends StatelessWidget {
  StudentListInSeasonsPage();

  Widget build(BuildContext context) {
    List<dynamic> listOfStudentsInSeason =
        context.watch<SeasonsGetDataFirestore>().seasonsListOfDataStudent;

    List<dynamic> listOfAllStudents =
        context.watch<StudentsGetDataFirestore>().StudentsListOfData;

    List<int> IndexesOfStudentsData = [];

    for (int i = 0; i < listOfAllStudents.length; i++) {
      if (listOfStudentsInSeason.contains(listOfAllStudents[i]["docId"]))
        IndexesOfStudentsData.add(i);
    }
    return Scaffold(
        appBar: AppBar(),
        body: ListView.separated(
          itemCount: IndexesOfStudentsData.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: buildTheItemOfTheList(
                  listOfAllStudents[IndexesOfStudentsData[index]],
                  index,
                  listOfAllStudents[IndexesOfStudentsData[index]]["docId"]),
            );
          },
        ));
  }

  SafeArea buildTheItemOfTheList(var model, int index, String id) {
    return SafeArea(
      child: InkWell(
        onTap: () async {},
        child: buildContainer(model, index),
      ),
    );
  }

  Container buildContainer(var model, int index) {
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

  Column buildColumnOfDateAndHours(var model) {
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

  Text buildText(var model, String text) {
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

  Expanded buildColumnOfNameDescription(var model) {
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

  CircleAvatar buildCircleAvatarNumber(var model, int index) {
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
