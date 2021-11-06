import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SeasonType { summer, winter }

enum StateOfMemberships { initial, loaded, loading }

class Season {
  final String year;
  final String seasonType;
  final String seasonDocId;
  final List<dynamic> studentsDocId;
  final List<dynamic> eventsDocId;
  Season(
      {required this.year,
      required this.seasonType,
      required this.seasonDocId,
      required this.eventsDocId,
      required this.studentsDocId});
}

class SeasonsFormat {
   String season;
   String seasonDocId;
  SeasonsFormat({required this.seasonDocId,required this.season});
}

class Memberships {
  final String year;
  final String seasonType;
  final String docId;
  Memberships(
      {required this.year, required this.seasonType, required this.docId});
}

class SeasonsLogic extends ChangeNotifier {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('seasons');

  List<Season> _seasonsList = [];

  List<SeasonsFormat> _seasonsOfDropButton = [];

  List<Memberships> _studentMemberships = [];

  List<Memberships> _remainingMemberships = [];

  StateOfMemberships stateOfFetching = StateOfMemberships.initial;

  preparingSeasons() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      QueryDocumentSnapshot data = querySnapshot.docs[i];
      addInSeasonsList(data);
      print(i);
      _seasonsOfDropButton.add(SeasonsFormat(
          seasonDocId: data["docId"],
          season: "${data["year"]} , ${data["season"]}"));
    }
    notifyListeners();
  }
  addInSeasonsList(QueryDocumentSnapshot data) {
    _seasonsList.add(Season(
        year: data["year"],
        seasonType: data["season"],
        seasonDocId: data["docId"],
        studentsDocId: data["students"],
        eventsDocId: data["events"]));
  }

  preparingMemberships(String studentDocId) async {
    stateOfFetching = StateOfMemberships.loading;
    _studentMemberships.clear();
    _remainingMemberships.clear();
    //get the list of ids of memberships
    List<dynamic> docIds = await membershipsDocIds(studentDocId);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    print("memberships cleared");
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      QueryDocumentSnapshot data = querySnapshot.docs[i];
      docIds.contains(data.id)
          ? addInStudentMembershipsList(data)
          : addInRemainingMembershipsList(data);
    }
    stateOfFetching = StateOfMemberships.loaded;
    notifyListeners();
  }

  addInStudentMembershipsList(QueryDocumentSnapshot data) {
    _studentMemberships.add(Memberships(
        year: data["year"], seasonType: data["season"], docId: data["docId"]));
  }

  addInRemainingMembershipsList(QueryDocumentSnapshot data) {
    _remainingMemberships.add(Memberships(
        year: data["year"], seasonType: data["season"], docId: data["docId"]));
  }

  Future<List<dynamic>> membershipsDocIds(String studentDocId) async {
    DocumentSnapshot<Map<String, dynamic>> listOfMemberships =
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentDocId)
            .get();
    return listOfMemberships["memberships"];
  }

  seasonsListCleared() {
    _seasonsList.clear();
  }

  membershipsListCleared() {
    _studentMemberships.clear();
  }

  remainingMembershipsCleared() {
    _remainingMemberships.clear();
  }

  List<SeasonsFormat> get seasonsOfDropButton => _seasonsOfDropButton;

  List<Memberships> get remainingMemberships => _remainingMemberships;

  List<Memberships> get studentMemberships => _studentMemberships;

  List<Season> get seasonsList => _seasonsList;
}
