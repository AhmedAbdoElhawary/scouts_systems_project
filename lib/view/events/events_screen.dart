import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/custom_container_events.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/move_to_page.dart';
import 'package:scouts_system/view_model/events.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventsLogic provider = context.watch<EventsLogic>();

    if (provider.eventsList.isEmpty &&
        provider.stateOfFetching != StateOfEvents.loaded) {
      provider.preparingEvents();
      context.read<SeasonsLogic>().preparingSeasons();
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, EventsLogic provider) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: provider.eventsList.isEmpty
            ? emptyMessage("event")
            : buildListView(provider),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressedFloating(context),
      child: const Icon(Icons.add),
    );
  }

  onPressedFloating(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MoveToThePage().moveToEventInfo(
                context: context,
                model: Events(leader: "leader 1"),
                seasonsFormat: [])));
  }

  ListView buildListView(EventsLogic provider) {
    return ListView.separated(
      itemCount: provider.eventsList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return buildListTile(provider, index, context);
      },
    );
  }

  ListTile buildListTile(
      EventsLogic provider, int index, BuildContext context) {
    return ListTile(
        title: buildTheItemOfTheList(provider.eventsList[index], index,
            provider.eventsList[index].eventDocId, context));
  }

  SafeArea buildTheItemOfTheList(
      Events model, int index, String eventDocId, BuildContext context) {
    return SafeArea(
      child: InkWell(
        onTap: () {
          context.read<StudentsLogic>().stateOfSelectedFetching =
              StateOfSelectedStudents.initial;

          buildPush(context, model, eventDocId);
        },
        child: CustomContainerEvents(index: index, modelEvents: model),
      ),
    );
  }

  buildPush(BuildContext context, Events model, String eventDocId) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MoveToThePage().moveToEventInfo(
                model: model,
                eventDocId: eventDocId,
                checkForUpdate: true,
                seasonsFormat: context.read<SeasonsLogic>().seasonsOfDropButton,
                context: context)));
  }
}
