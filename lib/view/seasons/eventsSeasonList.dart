import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common%20UI/CustomContainerBody.dart';
import 'package:scouts_system/common%20UI/CustomWidgetMethods.dart';
import 'package:scouts_system/common%20UI/empty_list_message.dart';
import 'package:scouts_system/view%20model/events.dart';
import 'package:scouts_system/view%20model/seasons.dart';

class EventsSeasonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<dynamic> listOfEventsInSeason =
        context.watch<DBSeasons>().seasonsListOfDataEvent;

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
            ? showEmptyMessage("event")
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
