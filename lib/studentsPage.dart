import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/addStudent.dart';

List<Map<String, String>> list = [{}];

class studentPage extends StatefulWidget {
  @override
  State<studentPage> createState() => _studentPageState();
}

class _studentPageState extends State<studentPage> {
  @override
  Widget build(BuildContext context) {
    print(list.length);
    return Scaffold(
      body: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: buildTheItemOfTheList(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => addNewStudent()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea buildTheItemOfTheList(int index) {
    return SafeArea(
      child: InkWell(
        onTap: () {
          print(index);
        },
        child: buildContainer(index),
      ),
    );
  }

  Container buildContainer(int index) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(index),
          buildColumnOfNameDescription(index),
          buildColumnOfDateAndHours(index),
        ],
      ),
    );
  }

  Column buildColumnOfDateAndHours(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(index, "vol"),
        buildText(index, "date"),
      ],
    );
  }

  Text buildText(int index, String text) {
    return Text(
      "${list[index][text]}",
      style: text != "name"
          ? TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic)
          : TextStyle(fontSize: 20, color: Colors.black),
    );
  }

  Expanded buildColumnOfNameDescription(int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText(index, "name"),
            buildText(index, "description"),
          ],
        ),
      ),
    );
  }

  CircleAvatar buildCircleAvatarNumber(int index) {
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
