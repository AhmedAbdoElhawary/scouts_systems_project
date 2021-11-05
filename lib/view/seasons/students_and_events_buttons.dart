import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scouts_system/common_ui/primary_color.dart';
import 'package:scouts_system/view/seasons/students_items.dart';

import 'events_items.dart';

class TwoButtonInSeason extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: customColor()),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              child: TextButton(
                child: Text(
                  "events",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>EventsSeasonList() ));
                },
              )),
          Container(
              width: double.infinity,
              child: TextButton(
                child: Text(
                  "students",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentListInSeasonsPage()));
                },
              )),
        ],
      ),
    );
  }
}
