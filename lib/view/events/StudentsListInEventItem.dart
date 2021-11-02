import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common%20UI/CustomContainerBody.dart';
import 'package:scouts_system/common%20UI/showTheTextMessage.dart';
import 'package:scouts_system/view%20model/eventsGetDataFirestore.dart';
import 'package:scouts_system/view%20model/seasonsGetDataFirestore.dart';
import 'package:scouts_system/view%20model/studentsGetDataFirestore.dart';
import 'package:scouts_system/common%20UI/CustomWidgetMethods.dart';
import 'package:scouts_system/view/events/selectStudentList.dart';

class StudentEventPage extends StatelessWidget {
  String eventDocId;
  String year;
  String season;
  StudentEventPage(
      {required this.eventDocId, required this.year, required this.season});

  Widget build(BuildContext context) {
    context.read<EventsGetDataFirestore>().getEventStudentsData(eventDocId);
//to the next page
    context
        .read<SeasonsGetDataFirestore>()
        .getListOfStudentsAndEvents(year: year, season: season);

    List<dynamic> listOfStudentsSelectedThisDate =
        context.watch<EventsGetDataFirestore>().eventStudentsListOfData;

    List<dynamic> listOfAllStudents =
        context.watch<StudentsGetDataFirestore>().StudentsListOfData;

    List<int> SpecificIndexesOfStudents = [];

    for (int i = 0; i < listOfAllStudents.length; i++) {
      if (listOfStudentsSelectedThisDate.contains(
          listOfAllStudents[i]["docId"])) SpecificIndexesOfStudents.add(i);
    }
    return Scaffold(
      appBar: AppBar(backgroundColor:customColor() ,),
      body: listOfStudentsSelectedThisDate.length == 0
          ? buildShowMessage("student")
          :  ListView.separated(
        itemCount: SpecificIndexesOfStudents.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: buildTheItemOfTheList(
                listOfAllStudents[SpecificIndexesOfStudents[index]], index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customColor(),
        onPressed: () async {
          List<dynamic> listOfStudents =
              context.read<SeasonsGetDataFirestore>().seasonsListOfDataStudent;
          List<dynamic> listOfAllStudents =
              context.read<StudentsGetDataFirestore>().StudentsListOfData;

          List<int> IndexesOfStudents = [];

          for (int i = 0; i < listOfAllStudents.length; i++) {
            if (listOfStudents.contains(listOfAllStudents[i]["docId"]))
              IndexesOfStudents.add(i);
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectStudentsList(
                        season: season,
                        year: year,
                        listOfAllStudents: listOfAllStudents,
                        IndexesOfStudents: IndexesOfStudents,
                        eventDocId: eventDocId,
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea buildTheItemOfTheList(var model, int index) {
    return SafeArea(
      child: InkWell(
        onTap: () async {  },
        child:CustomContainerBody(model: model,index: index,text: "student")
      ),
    );
  }
}
