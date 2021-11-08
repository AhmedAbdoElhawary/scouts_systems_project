import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/custom_container_events.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/events.dart';

// ignore: must_be_immutable
class EventsSeasonList extends StatelessWidget {
  List<dynamic> eventsDocIds;
  EventsSeasonList({Key? key, required this.eventsDocIds}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EventsLogic provider = context.watch<EventsLogic>();
    if (eventsDocIds.isNotEmpty&&provider.specificEvents.isEmpty &&
        provider.stateOfSpecificEvents != StateOfSpecificEvents.loaded) {
      provider.preparingSpecificEvents(eventsDocIds);
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
            : buildListView(provider));
  }

  ListView buildListView(EventsLogic provider) {
    return ListView.separated(
      itemCount: provider.specificEvents.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: buildTheItemOfTheList(provider.specificEvents[index], index),
        );
      },
    );
  }

  CustomContainerEvents buildTheItemOfTheList(Events model, int index) {
    return CustomContainerEvents(index: index, modelEvents: model);
  }
}
