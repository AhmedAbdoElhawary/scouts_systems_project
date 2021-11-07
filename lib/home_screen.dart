import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/view/events/events_screen.dart';
import 'package:scouts_system/view/seasons/seasons_screen.dart';
import 'package:scouts_system/view/students/students_screen.dart';
import 'common_ui/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PrimaryButton(moveToPage: const StudentsPage(), text: "Students"),
              PrimaryButton(moveToPage: const EventsPage(), text: "Events"),
              PrimaryButton(moveToPage: const SeasonsPage(), text: "Seasons"),
            ],
          ),
        ),
      ),
    );
  }
}
