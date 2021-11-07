import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/view/seasons/students_items.dart';
import 'events_items.dart';

class TwoButtonInSeason extends StatelessWidget {
  final List<dynamic> studentsDocId;
  final List<dynamic> eventsDocId;
  const TwoButtonInSeason(
      {Key? key, required this.eventsDocId, required this.studentsDocId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildColumn(context),
    );
  }

  Column buildColumn(BuildContext context) {
    return Column(
      children: [
        buildContainer(
            context, "events", EventsSeasonList(eventsDocIds: eventsDocId)),
        buildContainer(context, "students",
            StudentSeasonsPage(studentsDocIds: studentsDocId))
      ],
    );
  }

  SizedBox buildContainer(BuildContext context, String text, Widget page) {
    return SizedBox(
        width: double.infinity,
        child: TextButton(
          child: buildText(text),
          onPressed: () => onPressed(context, page),
        ));
  }

  onPressed(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Text buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, color: Colors.black),
    );
  }
}
