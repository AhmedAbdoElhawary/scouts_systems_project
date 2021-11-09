import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: must_be_immutable
class PrimaryButton extends StatelessWidget {
  String text;
  Widget page;
  bool pop;
  PrimaryButton(
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
      moveToPage(context);
    });
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
