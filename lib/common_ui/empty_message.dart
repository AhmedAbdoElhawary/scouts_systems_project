import 'package:flutter/material.dart';
Center emptyMessage(String text) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "There's no $text(s).",
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        Text(
          "Try to add one !",
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ],
    ),
  );
}
