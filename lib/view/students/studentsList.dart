import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/common%20UI/CustomContainerBody.dart';
import 'package:scouts_system/common%20UI/moveToThePage.dart';
import 'package:scouts_system/common%20UI/empty_list_message.dart';
import 'package:scouts_system/view%20model/studentsGetDataFirestore.dart';
import 'package:scouts_system/common%20UI/CustomWidgetMethods.dart';

class StudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<StudentsGetDataFirestore>().getAllStudentsData();

    List<QueryDocumentSnapshot> listOfStudentsData =
        context.watch<StudentsGetDataFirestore>().StudentsListOfData;

    return Scaffold(
      body: SafeArea(
        child: listOfStudentsData.length == 0
            ? showEmptyMessage("student")
            : ListView.separated(
                itemCount: listOfStudentsData.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: buildTheItemOfTheList(listOfStudentsData[index],
                        index, listOfStudentsData[index]["docId"], context),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customColor(),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MoveToThePage().moveToNewStudent("", "", false)));
        },
        child: Icon(Icons.add),
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
                  builder: (context) => MoveToThePage()
                      .moveToNewStudent(model, studentDocId, true)));
        },
        child: CustomContainerBody(text: "student", index: index, model: model),
      ),
    );
  }
}
