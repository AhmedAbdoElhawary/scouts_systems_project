import 'package:flutter/material.dart';

showDialogImage(BuildContext context, String studentImageUrl) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
        elevation: 0,
        content: Builder(
          builder: (context) {
            double height = MediaQuery.of(context).size.height;

            return Container(
              height: height / 2.5,
              color: Colors.black87,
              child: Image.network(studentImageUrl, fit: BoxFit.cover),
            );
          },
        ),
      ));
}