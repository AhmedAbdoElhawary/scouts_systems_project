import 'package:flutter/material.dart';

class LeaderPage extends StatelessWidget {
  const LeaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leader"),
      ),
      body: const Center(
        child: Text(
          "Leader",
          style: TextStyle(fontSize: 30, color: Colors.black87),
        ),
      ),
    );
  }
}
