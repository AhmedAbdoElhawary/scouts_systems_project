import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scouts_system/common%20UI/showToast.dart';

class StudentsGetDataFirestore extends ChangeNotifier {
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('students');

  List<QueryDocumentSnapshot> _StudentsListOfData = [];

  List<dynamic> _StudentMembershipsListOfData = [];

  getAllStudentsData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    _StudentsListOfData.clear();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      _StudentsListOfData.add(querySnapshot.docs[i]);
    }
    notifyListeners();

  }
  getStudentMembershipsData(String studentDocId) async {
    _collectionRef
        .doc(studentDocId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _StudentMembershipsListOfData=documentSnapshot["memberships"];
      }
    }).catchError((e){
      ToastShow().showWhiteToast("there's no memberships: $e");
    });
  }

  List<dynamic> get StudentMembershipsListOfData =>
      _StudentMembershipsListOfData;

  List<QueryDocumentSnapshot> get StudentsListOfData => _StudentsListOfData;
}
