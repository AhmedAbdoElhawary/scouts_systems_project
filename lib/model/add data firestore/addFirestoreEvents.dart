import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:scouts_system/common%20UI/showToast.dart';

class addFirestoreEvents{
  var _firestoreCollectionEvents = FirebaseFirestore.instance.collection('events');
  addDataFirestoreEvents({
    required String leader,
    required String location,
    required String date,
    required var eventId,
  }) {
    String eventRandomDocId = randomAlphaNumeric(20);

    _firestoreCollectionEvents.doc(eventRandomDocId)
        .set({
      'leader': leader,
      "location": location,
      "date": date,
      "docId":eventRandomDocId,
      'id': eventId,
      "students":[],
    })
        .then((value) => ToastShow().showWhiteToast("event added !"))
        .catchError(
            (error) => ToastShow().showRedToast("Failed to update event: $error"));
  }

  updateDataFirestoreEvents(
      {required String leader,
        required String location,
        required String date,
        required var eventId,
        required String eventDocId
      }) {
    _firestoreCollectionEvents
        .doc(eventDocId)
        .update({
      'leader': leader,
      "location": location,
      "date": date,
      'id': eventId,
    })
        .then((value) => ToastShow().showWhiteToast("update"))
        .catchError(
            (error) => ToastShow().showRedToast("Failed to update event: $error"));
  }
  addInFieldStudents({required String studentDocId, required String eventDocId}){
    _firestoreCollectionEvents
        .doc(eventDocId)
        .update({
      'students':FieldValue.arrayUnion([studentDocId]),
    })
        .then((value) => ToastShow().showWhiteToast("student added in event !"))
        .catchError(
            (error) => ToastShow().showRedToast("Failed to add student in event -> $error"));
  }
}