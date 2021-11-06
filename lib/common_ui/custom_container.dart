import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scouts_system/view_model/students.dart';

class CustomContainer extends StatelessWidget {
  Students model;
  int index;

  CustomContainer({Key? key, required this.index, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(index),
          buildNameAndDescription(model),
          buildDateAndHours(model),
        ],
      ),
    );
  }

  Column buildDateAndHours(Students model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(model.birthdate),
        buildText(model.volunteeringHours),
      ],
    );
  }

  Text buildText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic),
    );
  }

  Expanded buildNameAndDescription(Students model) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(model.name),
            buildText(model.description),
          ],
        ),
      ),
    );
  }

  CircleAvatar buildCircleAvatarNumber(int index) {
    return CircleAvatar(
      radius: 25,
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
