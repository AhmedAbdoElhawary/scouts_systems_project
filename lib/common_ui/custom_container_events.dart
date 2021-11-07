import 'package:flutter/material.dart';
import 'package:scouts_system/view_model/events.dart';

// ignore: must_be_immutable
class CustomContainerEvents extends StatelessWidget {
  Events modelEvents;
  int index;

  CustomContainerEvents(
      {Key? key, required this.index, required this.modelEvents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(index),
          buildNameAndDescription(modelEvents),
          buildDateAndHours(modelEvents),
        ],
      ),
    );
  }

  Column buildDateAndHours(Events model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(model.leader),
        buildText(model.date),
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

  Expanded buildNameAndDescription(Events model) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(model.eventId),
            buildText(model.location),
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
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
