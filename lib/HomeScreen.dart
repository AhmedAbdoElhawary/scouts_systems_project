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
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BuildBlueTextButton(
                   text: "students",pop: false, moveToPage: StudentPage()),
              SizedBox(width: 10),
              BuildBlueTextButton(
                  text: "events",pop: false, moveToPage: EventsPage()),
              SizedBox(width: 10),
              BuildBlueTextButton(
                  text: "Seasons",pop: false,moveToPage: SeasonsPage()),
            ],
          ),
        ),
      ),
    );
  }
}
