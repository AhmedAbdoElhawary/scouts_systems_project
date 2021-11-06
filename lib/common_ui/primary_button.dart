import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PrimaryButton extends StatelessWidget {
  String text;
  Widget moveToPage;
  bool pop;
  PrimaryButton(
      {required this.text, required this.moveToPage, this.pop = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildElevatedButton(context),
    );
  }

  ElevatedButton buildElevatedButton(BuildContext context) {
    return ElevatedButton(
        onPressed:(){
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            buildPush(context);
          });
        },
        child: buildTextOfButton());
  }

  Text buildTextOfButton() {
    return Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      );
  }

  Future<dynamic> buildPush(BuildContext context) {
    return Navigator.push(
              context, MaterialPageRoute(builder: (context) => moveToPage));
  }
  }

