import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:scouts_system/common_ui/toast_show.dart';

class FirestoreEvents {
  final _firestoreCollectionEvents =
      FirebaseFirestore.instance.collection('events');
  addEvent({
    required String leader,
    required String location,
    required String date,
    required var eventId,
  }) {
    String eventRandomDocId = randomAlphaNumeric(20);

    _firestoreCollectionEvents
        .doc(eventRandomDocId)
        .set({
          'leader': leader,
          "location": location,
          "date": date,
          "docId": eventRandomDocId,
          'id': eventId,
          "students": [],
        })
        .then((value) {})
        .catchError(
            (error) => ToastShow().redToast("Failed to update event: $error"));
  }

  updateEvent(
      {required String leader,
      required String location,
      required String date,
      required var eventId,
      required String eventDocId}) {
    _firestoreCollectionEvents
        .doc(eventDocId)
        .update({
          'leader': leader,
          "location": location,
          "date": date,
          'id': eventId,
        })
        .then((value) {})
        .catchError(
            (error) => ToastShow().redToast("Failed to update event: $error"));
  }

  addStudentsInEvent(
      {required String studentDocId, required String eventDocId}) {
    _firestoreCollectionEvents
        .doc(eventDocId)
        .update({
          'students': FieldValue.arrayUnion([studentDocId]),
        })
        .then((value) {})
        .catchError((error) =>
            ToastShow().redToast("Failed to add student in event -> $error"));
  }

  deleteStudentOfEvent(
      {required String eventDocId, required String studentDocId}) {
    _firestoreCollectionEvents
        .doc(eventDocId)
        .update({
          'students': FieldValue.arrayRemove([studentDocId]),
        })
        .then((value) {})
        .catchError((error) =>
            ToastShow().redToast("Failed to delete student -> $error"));
  }

  deleteEvent(String eventDocId) =>
      _firestoreCollectionEvents.doc(eventDocId).delete();
}
