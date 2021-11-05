import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/common_ui/custom_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/moveToThePage.dart';
import 'package:scouts_system/common_ui/primary_color.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<EventsGetDataFirestore>().getAllEventsData();

    List<QueryDocumentSnapshot> listOfEventsData =
        context.watch<EventsGetDataFirestore>().eventsListOfData;

    Map<String, List<String>> listOfSeasonsData =
        context.watch<SeasonsGetDataFirestore>().listOfSeasons;

    Iterable<String> a = listOfSeasonsData.keys;

    List<String> listOfYearsDropButton = List<String>.generate(
        listOfSeasonsData.length, (i) => "${a.elementAt(i)}");
    return Scaffold(
      body: SafeArea(
        child: listOfEventsData.length == 0
            ? buildShowMessage("event")
            : ListView.separated(
                itemCount: listOfEventsData.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: buildTheItemOfTheList(
                        listOfEventsData[index],
                        index,
                        listOfEventsData[index]["docId"],
                        context,
                        listOfYearsDropButton,
                        listOfSeasonsData),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customColor(),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MoveToThePage().moveToEventInfo(
                      "",
                      "",
                      false,
                      context,
                      listOfYearsDropButton,
                      listOfSeasonsData)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea buildTheItemOfTheList(
      var model,
      int index,
      String eventDocId,
      context,
      List<String> listOfYearsDropButton,
      Map<String, List<String>> listOfSeasonsData) {
    return SafeArea(
      child: InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MoveToThePage().moveToEventInfo(
                      model,
                      eventDocId,
                      true,
                      context,
                      listOfYearsDropButton,
                      listOfSeasonsData)));
        },
        child: CustomContainerBody(model: model, text: "event", index: index),
      ),
    );
  }
}
