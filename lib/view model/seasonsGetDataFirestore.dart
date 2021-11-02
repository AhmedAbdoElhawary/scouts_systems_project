import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeasonsGetDataFirestore extends ChangeNotifier {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('seasons');

  List<QueryDocumentSnapshot> _seasonsListOfAllData = [];
  Map<String, List<String>> _listOfSeasons = {};

  List<dynamic> _seasonsListOfDataStudent = [];
  List<dynamic> _seasonsListOfDataEvent = [];

  getAllSeasonsData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    _seasonsListOfAllData.clear();
    _listOfSeasons.clear();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      QueryDocumentSnapshot data = querySnapshot.docs[i];
      _seasonsListOfAllData.add(data);

      //get ready to seasons screen
      if (_listOfSeasons.containsKey(data["year"])) {
        List<String>? list = _listOfSeasons[data["year"]];
        list!.add(data["season"]);
        _listOfSeasons[data["year"]] = list;
      } else {
        _listOfSeasons[data["year"]] = [data["season"]];
      }
    }
    notifyListeners();
  }

  getListOfStudentsAndEvents(
      {required String year, required String season}) async {
    QuerySnapshot resultOfYear = await _collectionRef
        .where("year", isEqualTo: year)
        .where("season", isEqualTo: season)
        .get();

    final List<DocumentSnapshot> documentsYear = resultOfYear.docs;

    if (documentsYear.length > 0) {
      _seasonsListOfDataStudent = documentsYear[0]["students"];
      _seasonsListOfDataEvent = documentsYear[0]["events"];
    }

    notifyListeners();
  }

  Map<String, List<String>> get listOfSeasons => _listOfSeasons;

  List<dynamic> get seasonsListOfDataStudent => _seasonsListOfDataStudent;

  List<dynamic> get seasonsListOfDataEvent => _seasonsListOfDataEvent;

  List<QueryDocumentSnapshot> get seasonsListOfAllData => _seasonsListOfAllData;
}
