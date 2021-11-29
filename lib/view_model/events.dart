import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';

class Event {
  String eventDay;
  String location;
  String eventId;
  String eventDocId;
  String leader;
  String seasonDocId;
  Event(
      {this.eventDocId = "",
      this.eventId = "",
      this.eventDay = "",
      this.leader = "",
      this.location = "",
      this.seasonDocId = ""});
}

enum StateOfEvents { initial, loading, loaded }

enum StateOfNeededEvents { initial, loading, loaded }

class EventsProvider extends ChangeNotifier {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('events');

  final List<Event> _eventsList = [];

  final List<Event> _neededEvents = [];

  StateOfEvents stateOfFetchingEvent = StateOfEvents.initial;

  StateOfNeededEvents stateOfNeededEvents = StateOfNeededEvents.initial;

  preparingEvents() async {
    _eventsList.clear();
    stateOfFetchingEvent = StateOfEvents.loading;
    QuerySnapshot snap = await _collectionRef.get();
    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot data = snap.docs[i];
      addInEventsList(data);
    }
    stateOfFetchingEvent = StateOfEvents.loaded;
    notifyListeners();
  }

  addInEventsList(QueryDocumentSnapshot data) {
    _eventsList.add(Event(
        eventDay: data["date"],
        location: data["location"],
        leader: data["leader"],
        eventDocId: data["docId"],
        eventId: data["id"],
        seasonDocId: data["seasonDocId"]));
  }

  preparingNeededEvents(List<dynamic> eventsDocIds, String seasonDocId) async {
    _neededEvents.clear();
    stateOfNeededEvents = StateOfNeededEvents.loading;
    for (int i = 0; i < eventsDocIds.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(eventsDocIds[i]).get();
      snap.exists
          ? _neededEvents.add(addInNeededEvents(snap))
          : deleteTheEventInSeason(eventsDocIds[i], seasonDocId);
    }
    stateOfNeededEvents = StateOfNeededEvents.loaded;
    notifyListeners();
  }

  deleteTheEventInSeason(String eventDocId, String seasonDocId) {
    FirestoreSeasons()
        .deleteEventInSeason(seasonDocId: seasonDocId, eventDocId: eventDocId);
  }

  Event addInNeededEvents(DocumentSnapshot<Object?> snap) {
    return Event(
        eventDay: snap.get("date"),
        leader: snap.get("leader"),
        eventDocId: snap.get("docId"),
        eventId: snap.get("id"),
        location: snap.get("location"),
        seasonDocId: snap.get("seasonDocId"));
  }

  clearNeededEventsList() => _neededEvents.clear();

  clearEventList() => _eventsList.clear();

  List<Event> get neededEvents => _neededEvents;

  List<Event> get eventsList => _eventsList;
}
