import 'package:flutter/material.dart';

class LeaderPage extends StatelessWidget {
  const LeaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "leader",
          style: TextStyle(fontSize: 30, color: Colors.black87),
        ),
      ),
    );
  }
}
