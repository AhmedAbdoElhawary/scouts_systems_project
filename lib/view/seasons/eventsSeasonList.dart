import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/view%20model/eventsGetDataFirestore.dart';
import 'package:scouts_system/view%20model/seasonsGetDataFirestore.dart';

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
        appBar: AppBar(),
        body: ListView.separated(
          itemCount: IndexesOfEventsData.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: buildTheItemOfTheList(
                  listOfAllEvents[IndexesOfEventsData[index]],
                  index,
                  listOfAllEvents[IndexesOfEventsData[index]]["docId"]),
            );
          },
        ));
  }

  SafeArea buildTheItemOfTheList(var model, int index, String id) {
    return SafeArea(
      child: buildContainer(model, index),
    );
  }

  Container buildContainer(var model, int index) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(model, index),
          buildColumnOfNameDescription(model),
          buildColumnOfDateAndHours(model),
        ],
      ),
    );
  }

  Column buildColumnOfDateAndHours(var model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(model, "date"),
      ],
    );
  }

  Text buildText(var model, String text) {
    return Text(
      "${model[text]}",
      style: text != "id"
          ? TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic)
          : TextStyle(fontSize: 20, color: Colors.black),
    );
  }

  Expanded buildColumnOfNameDescription(var model) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText(model, "id"),
            buildText(model, "location"),
            buildText(model, "leader"),
          ],
        ),
      ),
    );
  }

  CircleAvatar buildCircleAvatarNumber(var model, int index) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
