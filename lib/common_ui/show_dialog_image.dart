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
                double width = MediaQuery.of(context).size.width;
                print({height, width});
                return Container(
                  //                    to the mobile : web
                  height: height / (height <= 800 ? 3 : 2),
                  width: width / 3,
                  color: Colors.black87,
                  child: Image.network(studentImageUrl, fit: BoxFit.fill),
                );
              },
            ),
          ));
}
