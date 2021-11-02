import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:scouts_system/common%20UI/showToast.dart';

class addFirestoreStudents{
  var _firestoreCollectionStudents = FirebaseFirestore.instance.collection('students');
  addDataFirestoreStudents({
    required String name,
    required String description,
    required String date,
    required var volunteeringHours,
  }) {
    String studentRandomDocId=randomAlphaNumeric(20);

    _firestoreCollectionStudents.doc(studentRandomDocId)
        .set({
      'name': name,
      "description": description,
      "date": date,
      "docId":studentRandomDocId,
      'volunteeringHours': volunteeringHours,
      "memberships":[],
    })
        .then((value) => ToastShow().showWhiteToast("user added !"))
        .catchError(
            (error) => ToastShow().showWhiteToast("Failed to update user: $error"));
  }

  updateDataFirestoreStudents(
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
        .then((value) => ToastShow().showWhiteToast("user updates"))
        .catchError(
            (error) => ToastShow().showWhiteToast("Failed to update user: $error"));
  }

  addInFieldMemberships({required String seasonDocId, required String studentDocId}){
    _firestoreCollectionStudents
        .doc(studentDocId)
        .update({
      'memberships':FieldValue.arrayUnion([seasonDocId]),
    })
        .then((value) => ToastShow().showWhiteToast("membership added in user !"))
        .catchError(
            (error) => ToastShow().showWhiteToast("Failed to add membership in user -> $error"));
  }

  // deleteDataFirestore(
  //     {required String id,
  //       required var model,
  //       required bool fromUpdate}) async {
  //   String filePath = model["image"].replaceAll(RegExp(r'(\?alt).*'), '');
  //
  //   List split = filePath.split("data%2F");
  //
  //   FirebaseStorage.instance
  //       .ref("data")
  //       .child(split[1])
  //       .delete()
  //       .then((_) => ToastShow()
  //       .showToast('Successfully deleted $filePath storage item'))
  //       .catchError((_) {
  //     ToastShow().showToast("image not exist in the firebase storage");
  //   });
  //
  //   if (!fromUpdate) {
  //     _firestoreCollectionStudents
  //         .doc(id)
  //         .delete()
  //         .then((value) => ToastShow().showToast("deleting successfully"))
  //         .catchError((e) =>
  //         ToastShow().showToast("$e \nerror while deleting the element"));
  //     ToastShow().showToast(id);
  //   }
  // }


}