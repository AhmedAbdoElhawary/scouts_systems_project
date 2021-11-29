import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class PrimaryButton extends StatelessWidget {
  final String text;
  final Widget page;
  final bool pop;
  const PrimaryButton(
      {Key? key, required this.text, required this.page, this.pop = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: elevatedButton(context),
    );
  }

  ElevatedButton elevatedButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onPressedButton(context), child: textOfButton());
  }

  onPressedButton(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      prepareStudentsData(context);
      prepareEventsData(context);
      prepareSeasonsData(context);

      moveToPage(context);
    });
  }

  prepareStudentsData(BuildContext context) {
    StudentsProvider studentProvider = context.read<StudentsProvider>();
    studentProvider.clearStudentsList();
    studentProvider.stateOfFetching = StateOfStudents.initial;
  }

  prepareEventsData(BuildContext context) {
    SeasonsProvider seasonProvider = context.read<SeasonsProvider>();
    seasonProvider.clearSeasonsList();
    seasonProvider.stateOfFetchingSeasons = StateOfSeasons.initial;
  }

  prepareSeasonsData(BuildContext context) {
    EventsProvider eventProvider = context.read<EventsProvider>();
    eventProvider.clearEventList();
    eventProvider.stateOfFetching = StateOfEvents.initial;
  }

  Text textOfButton() {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  Future<dynamic> moveToPage(BuildContext context) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }
}
