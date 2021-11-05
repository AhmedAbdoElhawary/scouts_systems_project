import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scouts_system/common_ui/primary_color.dart';

class CustomContainerBody extends StatelessWidget {
  String text;
  var model;
  int index;

  CustomContainerBody(
      {required this.index,
      required this.text,
      this.model,});
  List<String> eventListOfText = ["id", "leader", "date", "location"];
  List<String> studentListOfText = [
    "name",
    "description",
    "date",
    "volunteeringHours"
  ];
  @override
  Widget build(BuildContext context) {
    List<String> listOfText =
        text == "event" ? eventListOfText : studentListOfText;
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(model, index, listOfText),
          buildColumnOfNameDescription(model, listOfText),
          buildColumnOfDateAndHours(model, listOfText),
        ],
      ),
    );
  }

  Column buildColumnOfDateAndHours(var model, List<String> listOfText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(model, listOfText[2], listOfText),
        buildText(model, listOfText[3], listOfText),
      ],
    );
  }

  Text buildText(var model, String text, List<String> listOfText) {
    return Text(
      "${model[text]}",
      style: text != listOfText[0]
          ? TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic)
          : TextStyle(fontSize: 20, color: Colors.black),
    );
  }

  Expanded buildColumnOfNameDescription(var model, List<String> listOfText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText(model, listOfText[0], listOfText),
            buildText(model, listOfText[1], listOfText),
          ],
        ),
      ),
    );
  }

  CircleAvatar buildCircleAvatarNumber(
      var model, int index, List<String> listOfText) {
    return CircleAvatar(
      radius: 25,
      backgroundColor:customColor(),
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
