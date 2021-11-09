import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/view/seasons/students_and_events_buttons.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';
import 'add_season_item.dart';

class SeasonsPage extends StatefulWidget {
  const SeasonsPage({Key? key}) : super(key: key);

  @override
  State<SeasonsPage> createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
  @override
  Widget build(BuildContext context) {
    //fetching data
    SeasonsLogic provider = context.watch<SeasonsLogic>();
    if (provider.seasonsList.isEmpty &&
        provider.stateOfFetchingSeasons != StateOfSeasons.loaded) {
      provider.preparingSeasons();
      //------------>
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, SeasonsLogic provider) {
    return Scaffold(
      appBar: AppBar(),
      body: provider.seasonsList.isEmpty
          ? emptyMessage("season")
          : listView(provider),
      floatingActionButton: floatingActionButton(context),
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async => onPressedFloating(),
      child: const Icon(Icons.add),
    );
  }

  onPressedFloating() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddSeasonItem()));
  }

  ListView listView(SeasonsLogic provider) {
    return ListView.separated(
      itemCount: provider.seasonsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return listTile(provider, index, context);
      },
    );
  }

  ListTile listTile(SeasonsLogic provider, int index, BuildContext context) {
    return ListTile(
        title: listTitleItem(provider.seasonsList[index], index,
            provider.seasonsList[index].seasonDocId, context));
  }

  InkWell listTitleItem(
      Season model, int index, String seasonDocId, BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(model, seasonDocId),
      child: PrimaryContainer(
          index: index,
          rightTopText: model.year,
          rightBottomText: model.seasonType),
    );
  }

  onTapItem(Season model, String seasonDocId) {
    //to clear the previous data in the next pages
    context.read<EventsLogic>()..specificEventsCleared();
    context.read<StudentsLogic>().specificStudentsCleared();
    context.read<StudentsLogic>().stateOfSpecificFetching =
        StateOfSpecificStudents.initial;
    context.read<EventsLogic>().stateOfSpecificEvents =
        StateOfSpecificEvents.initial;
    //------------------------------------------->

    moveToTwoButtonsPage(context, model, seasonDocId);
  }

  moveToTwoButtonsPage(BuildContext context, Season model, String seasonDocId) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TwoButtonsPage(
                eventsDocId: model.eventsDocIds,
                studentsDocId: model.studentsDocIds)));
  }
}
