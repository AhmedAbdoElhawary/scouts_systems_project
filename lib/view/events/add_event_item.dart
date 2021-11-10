import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/view/events/students_items.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';

// ignore: must_be_immutable
class EventInfoPage extends StatefulWidget {
  TextEditingController controlEventID, controlLocation, controlEventDay;
  String dropdownValueLeader, eventDocId;
  bool checkForUpdate;
  List<SeasonFormat> seasonsFormat;
  EventInfoPage(
      {Key? key,
      required this.controlEventID,
      required this.seasonsFormat,
      required this.controlLocation,
      required this.dropdownValueLeader,
      required this.controlEventDay,
      required this.checkForUpdate,
      required this.eventDocId})
      : super(key: key);
  @override
  State<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  String seasonDocId = "";
  String? dropDownSeason;
  var listOfLeader = List<String>.generate(10, (i) => "leader ${i + 1}");
  bool eventIdValidate = false;
  bool locationValidate = false;
  bool userDateValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            containerOfFields(),
            containerOfButtons(context),
          ],
        ),
      ),
    );
  }

  SizedBox containerOfButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buttonOfCancel(context),
          buttonOfSave(context),
        ],
      ),
    );
  }

  Expanded buttonOfCancel(BuildContext context) {
    return Expanded(
      child: TextButton(
          child: textOfCancel(), onPressed: () => Navigator.pop(context)),
    );
  }

  Text textOfCancel() {
    return const Text("Cancel",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  Expanded buttonOfSave(BuildContext context) {
    return Expanded(
      child: TextButton(
          child: textOfSave(), onPressed: () => checkValidationFieldsAndPop()),
    );
  }

  Text textOfSave() {
    return const Text("Save",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  checkValidationFieldsAndPop() async {
    if (validateTextField(widget.controlEventID.text) &&
        validateTextField(widget.controlLocation.text) &&
        validateTextField(widget.controlEventDay.text)) {
      widget.checkForUpdate ? updateEvent() : addEvent();
      updatePreviousScreenData();
      Navigator.pop(context);
    }
  }

  updatePreviousScreenData() {
    EventsProvider provider = context.read<EventsProvider>();
    provider.stateOfFetching = StateOfEvents.initial;
    provider.preparingEvents();
    context.read<SeasonsProvider>().preparingSeasons();
  }

  addEvent() {
    FirestoreEvents().addEvent(
      eventId: widget.controlEventID.text,
      location: widget.controlLocation.text,
      date: widget.controlEventDay.text,
      leader: widget.dropdownValueLeader,
    );
  }

  updateEvent() {
    FirestoreEvents().updateEvent(
      eventId: widget.controlEventID.text,
      location: widget.controlLocation.text,
      date: widget.controlEventDay.text,
      leader: widget.dropdownValueLeader,
      eventDocId: widget.eventDocId,
    );
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        eventIdValidate = true;
        locationValidate = true;
        userDateValidate = true;
      });
      return false;
    }
    setState(() {
      eventIdValidate = false;
      locationValidate = false;
      userDateValidate = false;
    });
    return true;
  }

  Expanded containerOfFields() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: childrenOfColumn(),
          ),
        ),
      ),
    );
  }

  List<Widget> childrenOfColumn() {
    return [
      textFormField(eventIdValidate, widget.controlEventID, "ID"),
      const Divider(),
      textFormField(locationValidate, widget.controlLocation, "Location"),
      const Divider(),
      textFormField(userDateValidate, widget.controlEventDay, "Event Day"),
      const Divider(),
      dropdownButton(widget.dropdownValueLeader),
      widget.checkForUpdate ? dropdownButton(dropDownSeason) : const Divider(),
      widget.checkForUpdate && seasonDocId != ""
          ? studentsButton()
          : emptyMessage(),
    ];
  }

  ElevatedButton studentsButton() {
    return ElevatedButton(
        onPressed: () => onPressedButton(), child: textOfStudents("Students"));
  }

  onPressedButton() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      getReadySelectedStudents();
      pushToStudentsEventPage();
    });
  }

  getReadySelectedStudents() {
    StudentsProvider provider = context.read<StudentsProvider>();
    provider.clearSelectedStudentsList();
    provider.stateOfSelectedFetching = StateOfSelectedStudents.initial;
  }

  Text textOfStudents(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  Future<dynamic> pushToStudentsEventPage() {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentsEventPage(
                eventDocId: widget.eventDocId, seasonDocId: seasonDocId)));
  }

  Column emptyMessage() {
    return Column(
      children: const [
        Text("Save the event first"),
        Text("And then you can select students !")
      ],
    );
  }

//I can't make it smaller
  DropdownButtonHideUnderline dropdownButton(String? dropDownValue) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropDownValue,
        isExpanded: false,
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        iconSize: 20,
        hint: const Text("select item"),
        elevation: 16,
        style: const TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w300),
        onChanged: (n) {
          setState(() {
            if (widget.checkForUpdate && dropDownValue == dropDownSeason) {
              dropDownSeason = n!;
              seasonDocId = dropDownSeason!;
            } else {
              widget.dropdownValueLeader = n!;
            }
          });
        },
        items: widget.checkForUpdate && dropDownValue == dropDownSeason
            ? listMapOfSeasons(widget.seasonsFormat)?.toList()
            : listMapOfLeaders(listOfLeader)?.toList(),
      ),
    );
  }
}

Iterable<DropdownMenuItem<String>>? listMapOfLeaders(List<String>? list) {
  return list?.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  });
}

Iterable<DropdownMenuItem<String>>? listMapOfSeasons(List<SeasonFormat>? list) {
  return list?.map<DropdownMenuItem<String>>((SeasonFormat value) {
    return DropdownMenuItem<String>(
        value: value.seasonDocId, child: Text(value.season));
  });
}

TextFormField textFormField(
    bool validate, TextEditingController controller, String text) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
        errorText: validate ? "invalid $text" : null),
  );
}
