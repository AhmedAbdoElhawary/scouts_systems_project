import 'package:flutter/material.dart';
  Center buildShowMessage(String text) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "There's no $text(s).",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            Container(
              child: Text(
                "Try to add one !",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      );
  }

