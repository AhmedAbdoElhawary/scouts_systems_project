import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Widget destination;
  final bool pop;

  const PrimaryButton(
      {Key? key,
      required this.text,
      required this.destination,
      this.pop = false})
      : super(key: key);

  onPressed(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (pop) {
        Navigator.pop(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: primaryButtonDecoration(),
      child: TextButton(
          onPressed: () => onPressed(context),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          )),
    );
  }

  BoxDecoration primaryButtonDecoration() {
    return BoxDecoration(
      color: const Color.fromRGBO(62, 103, 135, 1.0),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 6,
          offset: const Offset(0, 5), // changes position of shadow
        ),
      ],
    );
  }
}
