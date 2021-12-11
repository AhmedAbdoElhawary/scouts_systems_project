import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:scouts_system/common_ui/toast_show.dart';

class FirestoreStudents {
  final _firestoreCollectionStudents =
      FirebaseFirestore.instance.collection('students');
  addStudent(
      {required String name,
      required String description,
      required String date,
      required String volunteeringHours,
      required String imageUrl}) {
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
          "imageUrl": imageUrl,
        })
        .then((value) => ToastShow().whiteToast("user added !"))
        .catchError(
            (error) => ToastShow().whiteToast("Failed to update user: $error"));
  }

  addStudentImage(String imageUrl) {}

  updateStudent(
      {required String name,
      required String description,
      required String date,
      required String volunteeringHours,
      required String studentDocId,
      required String studentImageUrl}) {
    _firestoreCollectionStudents
        .doc(studentDocId)
        .update({
          'name': name,
          "description": description,
          "date": date,
          'volunteeringHours': volunteeringHours,
          "imageUrl": studentImageUrl
        })
        .then((value) {})
        .catchError(
            (error) => ToastShow().whiteToast("Failed to update user: $error"));
  }

  updateImageUrl({required String studentDocId, required String imageUrl}) {
    _firestoreCollectionStudents
        .doc(studentDocId)
        .update({"imageUrl": imageUrl})
        .then((value) {})
        .catchError(
            (error) => ToastShow().whiteToast("Failed to update user image: $error"));
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

  deleteStudent(String studentDocId) =>
      _firestoreCollectionStudents.doc(studentDocId).delete();
}
