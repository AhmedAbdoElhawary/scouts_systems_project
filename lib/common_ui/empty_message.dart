import 'package:flutter/material.dart';

Center emptyMessage(String text) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "There's no $text(s).",
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
        const Text(
          "Try to add one !",
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ],
    ),
  );
}
