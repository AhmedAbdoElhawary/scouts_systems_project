import 'package:flutter/material.dart';

class BuildBlueTextButton extends StatelessWidget {
  String text;
  var moveToPage;
  bool pop;
  BuildBlueTextButton(
      {required this.text, required this.moveToPage, required this.pop});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(62, 103, 135, 1.0),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
          onPressed: () {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (pop) {
                Navigator.pop(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => moveToPage),
                );
              }
            });
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
    );
  }
}
