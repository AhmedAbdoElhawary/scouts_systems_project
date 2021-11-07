import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view/seasons/students_and_events_buttons.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';

import 'add_season_item.dart';

class SeasonsPage extends StatefulWidget {
  @override
  State<SeasonsPage> createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {

  @override
  Widget build(BuildContext context) {

    SeasonsLogic provider = context.watch<SeasonsLogic>();
    if (provider.seasonsList.isEmpty &&
        provider.stateOfFetchingSeasons != StateOfSeasons.loaded) {
      provider.preparingSeasons();
      return CircularProgress();
    } else
    return buildScaffold(context,provider);
  }


  Scaffold buildScaffold(BuildContext context, SeasonsLogic provider) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: provider.seasonsList.isEmpty
            ? emptyMessage("season")
            : buildListView(provider),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddYear()));
      },
      child: Icon(Icons.add),
    );
  }

  ListView buildListView(SeasonsLogic provider) {
    return ListView.separated(
      itemCount: provider.seasonsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return buildListTile(provider, index, context);
      },
    );
  }

  ListTile buildListTile(
      SeasonsLogic provider, int index, BuildContext context) {
    return ListTile(
        title: buildTheItemOfTheList(provider.seasonsList[index], index,
            provider.seasonsList[index].seasonDocId, context));
  }

  SafeArea buildTheItemOfTheList(
      Season model, int index, String seasonDocId, BuildContext context) {
    return SafeArea(
      child: InkWell(
        onTap: () {
          //to clear the previous data
          context.read<EventsLogic>().preparingSpecificEvents(model.eventsDocIds);
          context.read<StudentsLogic>().preparingSpecificStudents(studentsDocIds:model.studentsDocIds);
          context.read<StudentsLogic>().stateOfSpecificFetching =
              StateOfSpecificStudents.initial;
          context.read<EventsLogic>().stateOfSpecificEvents =
              StateOfSpecificEvents.initial;
          //------------------------->

          buildPush(context, model, seasonDocId);
        },
        child: container(index, model),
      ),
    );
  }

  buildPush(BuildContext context, Season model, String seasonDocId) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TwoButtonInSeason(eventsDocId: model.eventsDocIds,studentsDocId: model.studentsDocIds)));
  }

  container(int index, Season model) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(index),
          buildNameAndDescription(model),
          buildDateAndHours(model),
        ],
      ),
    );
  }

  Column buildDateAndHours(Season model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(model.seasonType),
      ],
    );
  }

  Text buildText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic),
    );
  }

  Expanded buildNameAndDescription(Season model) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(model.year)
          ],
        ),
      ),
    );
  }

  CircleAvatar buildCircleAvatarNumber(int index) {
    return CircleAvatar(
      radius: 25,
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
