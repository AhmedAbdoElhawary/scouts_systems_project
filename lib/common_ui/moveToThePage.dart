import 'package:flutter/material.dart';
import 'package:scouts_system/view/events/add_event_item.dart';
import 'package:scouts_system/view/students/add_student_Item.dart';

class MoveToThePage {
  AddEventInfo moveToEventInfo(
      var model,
      String eventDocId,
      bool checkForUpdate,
      context,
      List<String> listOfYearsDropButton,
      Map<String, List<String>> listOfSeasonsData) {
    return AddEventInfo(
      controlEventID:
          TextEditingController(text: "${model == "" ? "" : model["id"]}"),
      controlLocation: TextEditingController(
          text: "${model == "" ? "" : model["location"]}"),
      dropdownValueLeader: "${model == "" ? "leader 1" : model["leader"]}",
      checkForUpdate: checkForUpdate,
      controlDate:
          TextEditingController(text: "${model == "" ? "" : model["date"]}"),
      listOfYearsDropButton: listOfYearsDropButton,
      EventDocId: eventDocId,
      listOfSeasonsData: listOfSeasonsData,
    );
  }

  addNewStudent moveToNewStudent(
      var model, String studentDocId, bool checkForUpdate) {
    return addNewStudent(
      controlName:
          TextEditingController(text: "${model == "" ? "" : model["name"]}"),
      studentDocId: studentDocId,
      controlDescription: TextEditingController(
          text: "${model == "" ? "" : model["description"]}"),
      checkForUpdate: checkForUpdate,
      controlDate:
          TextEditingController(text: "${model == "" ? "" : model["date"]}"),
      controlVolunteeringHours: TextEditingController(
          text: "${model == "" ? "" : model["volunteeringHours"]}"),
    );
  }
}
