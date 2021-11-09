import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container_events.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';

import 'add_event_item.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //fetching data
    EventsLogic provider = context.watch<EventsLogic>();
    if (provider.eventsList.isEmpty &&
        provider.stateOfFetching != StateOfEvents.loaded) {
      provider.preparingEvents();
      context.read<SeasonsLogic>().preparingSeasons();
      //---------->
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, EventsLogic provider) {
    return Scaffold(
      appBar: AppBar(),
      body: provider.eventsList.isEmpty
          ? emptyMessage("event")
          : listView(provider),
      floatingActionButton: floatingActionButton(context),
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressedFloating(context),
      child: const Icon(Icons.add),
    );
  }

  onPressedFloating(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => eventInfoPage(
                context: context,
                model: Events(leader: "leader 1"),
                seasonsFormat: [])));
  }

  ListView listView(EventsLogic provider) {
    return ListView.separated(
      itemCount: provider.eventsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return listTile(provider, index, context);
      },
    );
  }

  ListTile listTile(EventsLogic provider, int index, BuildContext context) {
    return ListTile(
        title: itemOfListTitle(provider.eventsList[index], index,
            provider.eventsList[index].eventDocId, context));
  }

  InkWell itemOfListTitle(
      Events model, int index, String eventDocId, BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(model, eventDocId, context),
      child: PrimaryContainerEvents(index: index, modelEvents: model),
    );
  }

  onTapItem(Events model, String eventDocId, BuildContext context) {
    context.read<StudentsLogic>().stateOfSelectedFetching =
        StateOfSelectedStudents.initial;
    moveToEventInfoPage(context, model, eventDocId);
  }

  moveToEventInfoPage(BuildContext context, Events model, String eventDocId) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => eventInfoPage(
                model: model,
                eventDocId: eventDocId,
                checkForUpdate: true,
                seasonsFormat: context.read<SeasonsLogic>().seasonsOfDropButton,
                context: context)));
  }
}

EventInfoPage eventInfoPage(
    {required Events model,
    String eventDocId = "",
    bool checkForUpdate = false,
    required List<SeasonsFormat> seasonsFormat,
    required BuildContext context}) {
  return EventInfoPage(
    controlEventID: TextEditingController(text: model.eventId),
    controlLocation: TextEditingController(text: model.location),
    controlEventDay: TextEditingController(text: model.eventDay),
    dropdownValueLeader: model.leader,
    checkForUpdate: checkForUpdate,
    eventDocId: eventDocId,
    seasonsFormat: seasonsFormat,
  );
}
