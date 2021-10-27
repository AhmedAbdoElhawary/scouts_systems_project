import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/view/students/addStudentItem.dart';

class studentPage extends StatefulWidget {
  @override
  State<studentPage> createState() => _studentPageState();
}

class _studentPageState extends State<studentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("students").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) return new Text("There is no students");
            final docs = snapshot.data!.docs;
            return ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: buildTheItemOfTheList(docs[index], index,docs[index].id),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => addNewStudent(
                        controlName: TextEditingController(text: ""),
                        index: 1,
                        controlDescription: TextEditingController(text: ""),
                        checkForUpdate: false,
                        id:"",
                        controlDate: TextEditingController(text: ""),
                        controlVolunteeringHours: TextEditingController(text: ""),
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea buildTheItemOfTheList(var model, int index,String id) {
    return SafeArea(
      child: InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => addNewStudent(
                        controlName: TextEditingController(text: model["name"]),
                        index: index,
                        id:id,
                        controlDescription:
                            TextEditingController(text: model["description"]),
                        checkForUpdate: true,
                        controlDate: TextEditingController(text: model["date"]),
                        controlVolunteeringHours:
                            TextEditingController(text: model["volunteeringHours"]),

                      )));
        },
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
