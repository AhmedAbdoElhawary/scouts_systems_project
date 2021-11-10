import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/events.dart';

// ignore: must_be_immutable
class EventsSeasonList extends StatelessWidget {
  List<dynamic> eventsDocIds;
  EventsSeasonList({Key? key, required this.eventsDocIds}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return fetchingNeededEvents(context);
  }

  fetchingNeededEvents(BuildContext context) {
    EventsProvider provider = context.watch<EventsProvider>();
    if (eventsDocIds.isNotEmpty &&
        provider.neededEvents.isEmpty &&
        provider.stateOfNeededEvents != StateOfNeededEvents.loaded) {
      provider.preparingNeededEvents(eventsDocIds);
      return const CircularProgress();
    } else {
      return buildScaffold(provider);
    }
  }

  Scaffold buildScaffold(EventsProvider provider) {
    return Scaffold(
        appBar: AppBar(),
        body: provider.neededEvents.isEmpty
            ? emptyMessage("event")
            : listView(provider));
  }

  ListView listView(EventsProvider provider) {
    return ListView.separated(
      itemCount: provider.neededEvents.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return listTile(provider, index);
      },
    );
  }

  ListTile listTile(EventsProvider provider, int index) {
    return ListTile(
      title: listTitleItemBody(provider.neededEvents[index], index),
    );
  }

  PrimaryListItem listTitleItemBody(Event model, int index) {
    return PrimaryListItem(
        index: index,
        rightTopText: model.eventId,
        rightBottomText: model.leader,
        leftTopText: model.location,
        leftBottomText: model.eventDay);
  }
}
