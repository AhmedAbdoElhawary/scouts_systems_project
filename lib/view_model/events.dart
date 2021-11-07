import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Events {
  String date;
  String location;
  String eventId;
  String eventDocId;
  String leader;
  Events(
      {this.eventDocId = "",
      this.eventId = "",
      this.date = "",
      this.leader = "",
      this.location = ""});
}

enum StateOfEvents { initial, loading, loaded }

enum StateOfSpecificEvents { initial, loading, loaded }

class EventsLogic extends ChangeNotifier {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('events');

  List<Events> _eventsList = [];

  List<Events> _specificEvents = [];

  StateOfEvents stateOfFetching = StateOfEvents.initial;

  StateOfSpecificEvents stateOfSpecificEvents = StateOfSpecificEvents.initial;

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

  addInEventsList(QueryDocumentSnapshot data){
    _eventsList.add(Events(
        date: data["date"],
        location: data["location"],
        leader: data["leader"],
        eventDocId: data["docId"],
        eventId: data["id"]));
  }
  preparingSpecificEvents(List<dynamic> eventsDocIds) async {
    _specificEvents.clear();
    stateOfSpecificEvents = StateOfSpecificEvents.loading;
    for (int i = 0; i < eventsDocIds.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(eventsDocIds[i]).get();
      addInSpecificEvents(snap);
    }
    stateOfSpecificEvents = StateOfSpecificEvents.loaded;
    notifyListeners();

  }

  addInSpecificEvents(DocumentSnapshot<Object?> snap) {
    _specificEvents.add(Events(
        date: snap.get("date"),
        leader: snap.get("leader"),
        eventDocId: snap.get("docId"),
        eventId: snap.get("id"),
        location: snap.get("location")));
  }

  List<Events> get specificEvents => _specificEvents;

  List<Events> get eventsList => _eventsList;