import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';

import 'add_event_item.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fetchingEvents(context);
  }

  fetchingEvents(BuildContext context) {
    EventsProvider provider = context.watch<EventsProvider>();
    if (provider.eventsList.isEmpty &&
        provider.stateOfFetchingEvent != StateOfEvents.loaded) {
      provider.preparingEvents();
      context.read<SeasonsProvider>().preparingSeasons();
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, EventsProvider provider) {
    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      body: provider.eventsList.isEmpty
          ? emptyMessage("event")
          : listView(provider),
      floatingActionButton: floatingActionButton(context),
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => pushToEventInfoPage(context),
      child: const Icon(Icons.add),
    );
  }

  pushToEventInfoPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => eventInfoPage(
                context: context, model: Event(leader: "Leader 1"))));
  }

  ListView listView(EventsProvider provider) {
    return ListView.separated(
      itemCount: provider.eventsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return listTile(provider, index, context);
      },
    );
  }

  ListTile listTile(EventsProvider provider, int index, BuildContext context) {
    return ListTile(
        title: listTitleItem(provider.eventsList[index], index,
            provider.eventsList[index].eventDocId, context));
  }

  InkWell listTitleItem(
      Event model, int index, String eventDocId, BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(model, eventDocId, context),
      child: eventItemBody(index, model),
    );
  }

  PrimaryListItem eventItemBody(int index, Event model) {
    return PrimaryListItem(
        index: index,
        rightTopText: model.eventId,
        rightBottomText: model.leader,
        leftTopText: model.location,
        leftBottomText: model.eventDay);
  }

  onTapItem(Event model, String eventDocId, BuildContext context) {
    context.read<StudentsProvider>().stateOfSelectedFetching =
        StateOfSelectedStudents.initial;
    context.read<SeasonsProvider>().clearSelectedSeasonOfEvent();
    context.read<SeasonsProvider>().stateOfFetchingSelectedSeason=StateOfSeasons.initial;
    moveToEventInfoPage(context, model, eventDocId);
  }

  moveToEventInfoPage(BuildContext context, Event model, String eventDocId) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => eventInfoPage(
                model: model,
                eventDocId: eventDocId,
                checkForUpdate: true,
                context: context)));
  }
}

EventInfoPage eventInfoPage(
    {required Event model,
    String eventDocId = "",
    bool checkForUpdate = false,
    required BuildContext context}) {
  return EventInfoPage(
      controlEventID: TextEditingController(text: model.eventId),
      controlLocation: TextEditingController(text: model.location),
      eventDay: model.eventDay,
      dropdownValueLeader: model.leader,
      checkForUpdate: checkForUpdate,
      eventDocId: eventDocId,
      seasonsFormat: context.read<SeasonsProvider>().seasonsOfDropButton,
      seasonDocId: model.seasonDocId);
}
