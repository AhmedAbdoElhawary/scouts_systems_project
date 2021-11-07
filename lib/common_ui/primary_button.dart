import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: must_be_immutable
class PrimaryButton extends StatelessWidget {
  String text;
  Widget moveToPage;
  bool pop;
  PrimaryButton(
      {Key? key,
      required this.text,
      required this.moveToPage,
      this.pop = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildElevatedButton(context),
    );
  }

  ElevatedButton buildElevatedButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            buildPush(context);
          });
        },
        child: buildTextOfButton());
  }

  Text buildTextOfButton() {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  Future<dynamic> buildPush(BuildContext context) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => moveToPage));
  }
}
