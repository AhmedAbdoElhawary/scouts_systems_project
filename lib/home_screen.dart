import 'package:flutter/material.dart';
import 'package:scouts_system/view/events/events_screen.dart';
import 'package:scouts_system/view/seasons/seasons_screen.dart';
import 'package:scouts_system/view/students/students_screen.dart';
import 'common_ui/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scouts App")),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PrimaryButton(page: const StudentsPage(), text: "Students"),
            PrimaryButton(page: const EventsPage(), text: "Events"),
            PrimaryButton(page: const SeasonsPage(), text: "Seasons"),
          ],
        ),
      ),
    );
  }
}
