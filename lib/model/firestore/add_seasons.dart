import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:scouts_system/common_ui/toast_show.dart';

class FirestoreSeasons {
  final _firestoreCollectionSeasons =
      FirebaseFirestore.instance.collection('seasons');
  addSeason({
    required String year,
    required String season,
  }) {
    String seasonRandomDocId = randomAlphaNumeric(20);

    _firestoreCollectionSeasons
        .doc(seasonRandomDocId)
        .set({
          'year': year,
          "season": season,
          "events": [],
          "docId": seasonRandomDocId,
          "students": [],
        })
        .then((value) {})
        .catchError(
            (error) => ToastShow().redToast("Failed to update season: $error"));
  }

  addEventInSeason(
      {required String seasonDocId, required String eventDocId}) async {
    _firestoreCollectionSeasons
        .doc(seasonDocId)
        .update({
          'events': FieldValue.arrayUnion([eventDocId]),
        })
        .then((value) {})
        .catchError((error) =>
            ToastShow().redToast("Failed to add event in season ->$error"));
  }

  addStudentInSeason(
      {required String studentDocId, required String seasonDocId}) async {
    _firestoreCollectionSeasons
        .doc(seasonDocId)
        .update({
          'students': FieldValue.arrayUnion([studentDocId]),
        })
        .then((value) {})
        .catchError((error) =>
            ToastShow().redToast("Failed to add student in season ->$error"));
  }

  deleteEventInSeason(
      {required String seasonDocId, required String eventDocId}) {
    _firestoreCollectionSeasons
        .doc(seasonDocId)
        .update({
          'events': FieldValue.arrayRemove([eventDocId])
        })
        .then((value) {})
        .catchError((error) =>
            ToastShow().redToast("Failed to remove event in season ->$error"));
  }

  deleteStudentInSeason(
      {required String studentDocId, required String seasonDocId}) {
    _firestoreCollectionSeasons
        .doc(seasonDocId)
        .update({
          'students': FieldValue.arrayRemove([studentDocId]),
        })
        .then((value) {})
        .catchError((error) =>
            ToastShow().redToast("Failed to delete student in season->$error"));
  }

  deleteSeason(String seasonDocId) =>
      _firestoreCollectionSeasons.doc(seasonDocId).delete();
}
