import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/view%20model/eventsGetDataFirestore.dart';
import 'package:scouts_system/view%20model/seasonsGetDataFirestore.dart';
import 'package:scouts_system/view/events/addEventItem.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<EventsGetDataFirestore>().getAllEventsData();

    List<QueryDocumentSnapshot> listOfEventsData =
        context.watch<EventsGetDataFirestore>().eventsListOfData;

    return Scaffold(
      appBar: AppBar(),
      body: listOfEventsData.length == 0
          ? buildShowMessage()
          : ListView.separated(
              itemCount: listOfEventsData.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: buildTheItemOfTheList(listOfEventsData[index], index,
                      listOfEventsData[index]["docId"], context),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          moveToNewStudent("", "", true, context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Center buildShowMessage() {
    return Center(
      child: Text(
        "there's no event(s) !",
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
    );
  }

  SafeArea buildTheItemOfTheList(
      var model, int index, String eventDocId, context) {
    return SafeArea(
      child: InkWell(
        onTap: () async {
          moveToNewStudent(model, eventDocId, true, context);
        },
        child: buildContainer(model, index),
      ),
    );
  }

  AddEventInfo moveToNewStudent(
      var model, String eventDocId, bool checkForUpdate, context) {
    List<QueryDocumentSnapshot> listOfSeasonsData =
        context.read<SeasonsGetDataFirestore>().seasonsListOfAllData;
    List<String> listOfYearsDropButton = List<String>.generate(
        listOfSeasonsData.length - 1, (i) => "${listOfSeasonsData[0]["year"]}");

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
