import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  String eventDay;
  String location;
  String eventId;
  String eventDocId;
  String leader;
  Event(
      {this.eventDocId = "",
      this.eventId = "",
      this.eventDay = "",
      this.leader = "",
      this.location = ""});
}

enum StateOfEvents { initial, loading, loaded }

enum StateOfNeededEvents { initial, loading, loaded }

class EventsProvider extends ChangeNotifier {

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('events');

  final List<Event> _eventsList = [];

  final List<Event> _neededEvents = [];

  StateOfEvents stateOfFetching = StateOfEvents.initial;

  StateOfNeededEvents stateOfNeededEvents = StateOfNeededEvents.initial;

  preparingEvents() async {
    _eventsList.clear();
    stateOfFetching = StateOfEvents.loading;
    QuerySnapshot snap = await _collectionRef.get();
    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot data = snap.docs[i];
      addInEventsList(data);
    }
    stateOfFetching = StateOfEvents.loaded;
    notifyListeners();
  }

  addInEventsList(QueryDocumentSnapshot data) {
    _eventsList.add(Event(
        eventDay: data["date"],
        location: data["location"],
        leader: data["leader"],
        eventDocId: data["docId"],
        eventId: data["id"]));
  }

  preparingNeededEvents(List<dynamic> eventsDocIds) async {
    _neededEvents.clear();
    stateOfNeededEvents = StateOfNeededEvents.loading;
    for (int i = 0; i < eventsDocIds.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(eventsDocIds[i]).get();
      _neededEvents.add(addInNeededEvents(snap));
    }
    stateOfNeededEvents = StateOfNeededEvents.loaded;
    notifyListeners();
  }

 Event addInNeededEvents(DocumentSnapshot<Object?> snap) {
    return Event(
        eventDay: snap.get("date"),
        leader: snap.get("leader"),
        eventDocId: snap.get("docId"),
        eventId: snap.get("id"),
        location: snap.get("location"));
  }
  clearNeededEventsList(){
    _neededEvents.clear();
  }
  List<Event> get neededEvents => _neededEvents;

  List<Event> get eventsList => _eventsList;
}
