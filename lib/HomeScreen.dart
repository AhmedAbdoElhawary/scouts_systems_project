import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/common%20UI/buildTheBlueTextButton.dart';
import 'package:scouts_system/view/events/eventsList.dart';
import 'package:scouts_system/view/seasons/SeasonsPage.dart';
import 'package:scouts_system/view/students/studentsList.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BuildTextButton().buildTheBlueTextButton(
                context: context, text: "students",pop: false, moveToPage: StudentPage()),
            SizedBox(width: 10),
            BuildTextButton().buildTheBlueTextButton(
                context: context, text: "events",pop: false, moveToPage: EventsPage()),
            SizedBox(width: 10),
            BuildTextButton().buildTheBlueTextButton(
                context: context, text: "Seasons",pop: false,moveToPage: SeasonsPage()),
          ],
        ),
      ),
    );
  }
}
