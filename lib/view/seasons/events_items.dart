import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/custom_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/primary_color.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';

class EventsSeasonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<dynamic> listOfEventsInSeason =
        context.watch<SeasonsGetDataFirestore>().seasonsListOfDataEvent;

    List<dynamic> listOfAllEvents =
        context.watch<EventsGetDataFirestore>().eventsListOfData;

    List<int> IndexesOfEventsData = [];

    for (int i = 0; i < listOfAllEvents.length; i++) {
      if (listOfEventsInSeason.contains(listOfAllEvents[i]["docId"]))
        IndexesOfEventsData.add(i);
    }
    return Scaffold(
        appBar: AppBar(backgroundColor: customColor()),
        body: listOfEventsInSeason.length == 0
            ? buildShowMessage("event")
            : ListView.separated(
                itemCount: IndexesOfEventsData.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: buildTheItemOfTheList(
                        listOfAllEvents[IndexesOfEventsData[index]], index),
                  );
                },
              ));
  }

  SafeArea buildTheItemOfTheList(var model, int index) {
    return SafeArea(
      child: CustomContainerBody(model: model, index: index, text: "event"),
    );
  }
}
