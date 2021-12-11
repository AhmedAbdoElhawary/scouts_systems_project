import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class PrimaryListItem extends StatelessWidget {
  final String rightTopText, rightBottomText, leftTopText, leftBottomText;
  final int index;
  final bool isStudentSelected;
  final String studentImageUrl;
  const PrimaryListItem(
      {Key? key,
      required this.index,
      this.leftBottomText = "",
      this.leftTopText = "",
      this.studentImageUrl = "",
      this.isStudentSelected = false,
      required this.rightBottomText,
      required this.rightTopText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          if (isStudentSelected)
            circleAvatarOfStudent(studentImageUrl),
          columnOfRightTexts(
              topText: rightTopText, bottomText: rightBottomText),
          columnOfLeftTexts(topText: leftTopText, bottomText: leftBottomText),
        ],
      ),
    );
  }

  Column columnOfLeftTexts(
      {required String topText, required String bottomText}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(topText),
        buildText(bottomText),
      ],
    );
  }

  Text buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic),
    );
  }

  Expanded columnOfRightTexts(
      {required String topText, required String bottomText}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(topText),
            buildText(bottomText),
          ],
        ),
      ),
    );
  }
}

CircleAvatar circleAvatarOfStudent(String studentImageUrl) {
  return CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage(studentImageUrl),
      backgroundColor: Colors.white);
}
