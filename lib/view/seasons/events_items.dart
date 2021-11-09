import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    //fetching data
    EventsLogic provider = context.watch<EventsLogic>();
    if (eventsDocIds.isNotEmpty &&
        provider.specificEvents.isEmpty &&
        provider.stateOfSpecificEvents != StateOfSpecificEvents.loaded) {
      provider.preparingSpecificEvents(eventsDocIds);
      //------------>
      return const CircularProgress();
    } else {
      return buildScaffold(provider);
    }
  }

  Scaffold buildScaffold(EventsLogic provider) {
    return Scaffold(
        appBar: AppBar(),
        body: provider.specificEvents.isEmpty
            ? emptyMessage("event")
            : listView(provider));
  }

  ListView listView(EventsLogic provider) {
    return ListView.separated(
      itemCount: provider.specificEvents.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return listTile(provider, index);
      },
    );
  }

  ListTile listTile(EventsLogic provider, int index) {
    return ListTile(
      title: listTitleItem(provider.specificEvents[index], index),
    );
  }

  PrimaryContainer listTitleItem(Events model, int index) {
    return PrimaryContainer(
        index: index,
        rightTopText: model.eventId,
        rightBottomText: model.leader,
        leftTopText: model.location,
        leftBottomText: model.eventDay);
  }
}
