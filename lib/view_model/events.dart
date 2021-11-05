import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scouts_system/common_ui/toast_show.dart';

class EventsGetDataFirestore extends ChangeNotifier {

  CollectionReference _collectionRef =
FirebaseFirestore.instance.collection('events');

  List<QueryDocumentSnapshot> _eventsListOfData = [];

  List<dynamic> _eventStudentsListOfData = [];

  getAllEventsData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    _eventsListOfData.clear();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      _eventsListOfData.add(querySnapshot.docs[i]);
    }
    notifyListeners();
  }

  getEventStudentsData(String studentDocId) async {
    _collectionRef
        .doc(studentDocId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _eventStudentsListOfData=documentSnapshot["students"];
      }
    }).catchError((e){
      ToastShow().showWhiteToast("there's no memberships: $e");
    });
  }

  List<QueryDocumentSnapshot> get eventsListOfData => _eventsListOfData;

  List<dynamic> get eventStudentsListOfData =>
      _eventStudentsListOfData;

}
