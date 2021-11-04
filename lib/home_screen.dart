import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/common%20UI/primary_button.dart';
import 'package:scouts_system/view/events/eventsList.dart';
import 'package:scouts_system/view/seasons/seasons_page.dart';
import 'package:scouts_system/view/students/studentsList.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryButton(text: "Students", destination: StudentPage()),
                PrimaryButton(text: "Events", destination: EventsPage()),
                PrimaryButton(text: "Seasons", destination: SeasonsPage())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
