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
  _SeasonsPageState createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
  @override
  Widget build(BuildContext context) {
    return fetchingSeasons(context);
  }

  fetchingSeasons(BuildContext context) {
    SeasonsProvider provider = context.watch<SeasonsProvider>();
    if (provider.seasonsList.isEmpty &&
        provider.stateOfFetchingSeasons != StateOfSeasons.loaded) {
      provider.preparingSeasons();
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, SeasonsProvider provider) {
    return Scaffold(
      appBar: AppBar(title: Text("Seasons")),
      body: provider.seasonsList.isEmpty
          ? emptyMessage("season")
          : listView(provider),
      floatingActionButton: floatingActionButton(context),
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async => pushToAddSeasonPage(context),
      child: const Icon(Icons.add),
    );
  }

  pushToAddSeasonPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddSeasonScreen()));
  }

  ListView listView(SeasonsProvider provider) {
    return ListView.separated(
      itemCount: provider.seasonsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return listTile(provider, index, context);
      },
    );
  }

  ListTile listTile(SeasonsProvider provider, int index, BuildContext context) {
    return ListTile(
        title: listTitleItem(provider.seasonsList[index], index,
            provider.seasonsList[index].seasonDocId, context),
    );
  }
  InkWell listTitleItem(
      Season model, int index, String seasonDocId, BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(model, seasonDocId, context),
      child: seasonItemBody(index, model),
    );
  }

  PrimaryListItem seasonItemBody(int index, Season model) {
    return PrimaryListItem(
        index: index,
        rightTopText: model.year,
        rightBottomText: model.seasonType);
  }

  onTapItem(Season model, String seasonDocId, BuildContext context) {
    getReadyForNextPages(context);
    pushToTwoButtonsPage(context, model, seasonDocId);
  }

  getReadyForNextPages(BuildContext context) {
    EventsProvider eventsProvider = context.read<EventsProvider>();
    StudentsProvider studentsProvider = context.read<StudentsProvider>();

    eventsProvider.clearNeededEventsList();
    studentsProvider.clearNeededStudentsList();
    studentsProvider.stateOfSpecificFetching = StateOfSpecificStudents.initial;
    eventsProvider.stateOfNeededEvents = StateOfNeededEvents.initial;
  }

  pushToTwoButtonsPage(BuildContext context, Season model, String seasonDocId) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TwoButtonsPage(
                eventsDocId: model.eventsDocIds,
                title: "${model.year} , ${model.seasonType}",
                studentsDocId: model.studentsDocIds,
                seasonDocId: model.seasonDocId)));
  }
}
