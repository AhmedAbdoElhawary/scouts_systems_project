import 'package:flutter/material.dart';
class DropDownButton extends StatefulWidget{
  List<String> listOfDropDown;
  String dropDownValue;
  DropDownButton({required this.dropDownValue,required this.listOfDropDown});
  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  @override
  Widget build(BuildContext context) {
    return  DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.dropDownValue,
          isExpanded: false,
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          iconSize: 20,
          elevation: 16,
          style: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w300),
          onChanged: (n) {
            setState(() {
              widget.dropDownValue = n!;
            });
          },
          items: buildListMap(widget.listOfDropDown).toList(),
        ),
      );
  }
}


Iterable<DropdownMenuItem<String>> buildListMap(List<String> list) {
  return list.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  });
}