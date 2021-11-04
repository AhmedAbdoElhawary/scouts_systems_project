import 'package:flutter/material.dart';

Widget showEmListptyMessage(String itemName) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "There's no $itemName(s).",
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
