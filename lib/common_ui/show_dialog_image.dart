import 'package:flutter/material.dart';

showDialogImage(BuildContext context, String studentImageUrl) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.0),
            elevation: 0,
            content: Builder(
              builder: (context) {
                double height = MediaQuery.of(context).size.height;
                double width = MediaQuery.of(context).size.width;
                double size = (height >= width ? width : height) / 2;
                return Container(
                  height: size,
                  width: size,
                  color: Colors.black87,
                  child: Image.network(studentImageUrl, fit: BoxFit.fill),
                );
              },
            ),
          ));
}
