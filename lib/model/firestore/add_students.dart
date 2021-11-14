import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:scouts_system/common_ui/toast_show.dart';

class FirestoreStudents {
  final _firestoreCollectionStudents =
      FirebaseFirestore.instance.collection('students');
  addStudent({
    required String name,
    required String description,
    required String date,
    required var volunteeringHours,
  }) {
    String studentRandomDocId = randomAlphaNumeric(20);

    _firestoreCollectionStudents
        .doc(studentRandomDocId)
        .set({
          'name': name,
          "description": description,
          "date": date,
          "docId": studentRandomDocId,
          'volunteeringHours': volunteeringHours,
          "memberships": [],
        })
        .then((value) => ToastShow().whiteToast("user added !"))
        .catchError(
            (error) => ToastShow().whiteToast("Failed to update user: $error"));
  }

  updateStudent(
      {required String name,
      required String description,
      required String date,
      required var volunteeringHours,
      required String studentDocId}) {
    _firestoreCollectionStudents
        .doc(studentDocId)
        .update({
          'name': name,
          "description": description,
          "date": date,
          'volunteeringHours': volunteeringHours,
        })
        .then((value) {})
        .catchError(
            (error) => ToastShow().whiteToast("Failed to update user: $error"));
  }

  addMembership({required String seasonDocId, required String studentDocId}) {
    _firestoreCollectionStudents
        .doc(studentDocId)
        .update({
          'memberships': FieldValue.arrayUnion([seasonDocId]),
        })
        .then((value) {})
        .catchError((error) =>
            ToastShow().redToast("Failed to add membership in user -> $error"));
  }

  deleteMembership(
      {required String seasonDocId, required String studentDocId}) {
    _firestoreCollectionStudents
        .doc(studentDocId)
        .update({
          'memberships': FieldValue.arrayRemove([seasonDocId]),
        })
        .then((value) {})
        .catchError((error) =>
            ToastShow().redToast("Failed to delete membership -> $error"));
  }
}
