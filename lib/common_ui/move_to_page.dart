import 'package:flutter/material.dart';
import 'package:scouts_system/view/events/add_event_item.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';

class MoveToThePage {
  AddEventInfo moveToEventInfo(
      {required Events model,
      String eventDocId = "",
      bool checkForUpdate = false,
        required List<SeasonsFormat> seasonsFormat,
        required BuildContext context}) {
    return AddEventInfo(
      controlEventID: TextEditingController(text: "${model.eventId}"),
      controlLocation: TextEditingController(text: "${model.location}"),
      controlDate: TextEditingController(text: "${model.date}"),
      dropdownValueLeader: "${model.leader}",
      checkForUpdate: checkForUpdate,
      eventDocId: eventDocId,
      seasonsFormat:seasonsFormat,
    );
  }
}
