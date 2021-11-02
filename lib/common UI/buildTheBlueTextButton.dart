import 'package:flutter/material.dart';

class BuildTextButton {
  Container buildTheBlueTextButton(
      {required String text,
        required moveToPage,
        required bool pop,
        required BuildContext context,}) {
    return Container(
      color: Colors.blue,
      child: TextButton(
          onPressed:(){
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if(pop){
                Navigator.pop(context);
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => moveToPage),
                );
              }
            });
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
    );
  }
}
