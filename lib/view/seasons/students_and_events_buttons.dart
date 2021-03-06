import 'package:flutter/material.dart';
import 'package:scouts_system/view/seasons/students_items.dart';
import 'events_items.dart';

class TwoButtonsPage extends StatelessWidget {
  final List<dynamic> studentsDocId, eventsDocId;
  final String title,seasonDocId;
  const TwoButtonsPage(
      {Key? key, required this.eventsDocId, required this.studentsDocId,required this.title,required this.seasonDocId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: columnOfButtons(context),
    );
  }

  Column columnOfButtons(BuildContext context) {
    return Column(
      children: [
        containerOfItem(
            context, "Events", EventsSeasonList(eventsDocIds: eventsDocId,seasonDocId:seasonDocId)),
        containerOfItem(context, "Students",
            StudentSeasonsPage(studentsDocIds: studentsDocId,seasonDocId:seasonDocId))
      ],
    );
  }

  SizedBox containerOfItem(BuildContext context, String text, Widget page) {
    return SizedBox(
        width: double.infinity,
        child: TextButton(
          child: buildText(text),
          onPressed: () => pushToThePage(context, page),
        ));
  }

  pushToThePage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Text buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, color: Colors.black),
    );
  }
}
