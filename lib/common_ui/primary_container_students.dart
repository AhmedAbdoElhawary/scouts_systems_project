import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class PrimaryContainerStudents extends StatelessWidget {
  Students modelStudents;
  int index;

  PrimaryContainerStudents(
      {Key? key, required this.index, required this.modelStudents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          circleAvatarNumber(index),
          nameAndDescription(modelStudents),
          dateAndHours(modelStudents),
        ],
      ),
    );
  }

  Column dateAndHours(Students model) {
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
      style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic),
    );
  }

  Expanded nameAndDescription(Students model) {
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

  CircleAvatar circleAvatarNumber(int index) {
    return CircleAvatar(
      radius: 25,
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
