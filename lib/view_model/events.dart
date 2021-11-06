import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Events {
  String date;
  String location;
  String eventId;
  String eventDocId;
  String leader;
  Events(
      { this.eventDocId="",
       this.eventId="",
       this.date="",
       this.leader="",
       this.location=""});
}

enum StateOfEvents { initial, loading, loaded }

class EventsLogic extends ChangeNotifier {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('events');

  List<Events> _eventsList = [];

  StateOfEvents stateOfFetching=StateOfEvents.initial;

  preparingEvents() async {
    stateOfFetching=StateOfEvents.loading;
    QuerySnapshot snap = await _collectionRef.get();
    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot data = snap.docs[i];
      _eventsList.add(Events(
          date: data["date"],
          location: data["location"],
          leader: data["leader"],
          eventDocId: data["docId"],
          eventId: data["id"]));
    }
    stateOfFetching=StateOfEvents.loaded;
    notifyListeners();
  }

  List<Events> get eventsList => _eventsList;

}
