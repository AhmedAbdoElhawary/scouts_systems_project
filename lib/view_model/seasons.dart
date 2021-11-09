import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SeasonType { summer, winter }

enum StateOfMemberships { initial, loaded, loading }

enum StateOfSeasons { initial, loaded, loading }

class Season {
  final String year;
  final String seasonType;
  final String seasonDocId;
  final List<dynamic> studentsDocIds;
  final List<dynamic> eventsDocIds;
  Season(
      {required this.year,
      required this.seasonType,
      required this.seasonDocId,
      required this.eventsDocIds,
      required this.studentsDocIds});
}

class SeasonsFormat {
  String season;
  String seasonDocId;
  SeasonsFormat({required this.seasonDocId, required this.season});
}

class Memberships {
  final String year;
  final String seasonType;
  final String docId;
  Memberships(
      {required this.year, required this.seasonType, required this.docId});
}

class SeasonsLogic extends ChangeNotifier {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('seasons');

  final List<Season> _seasonsList = [];

  final List<SeasonsFormat> _seasonsOfDropButton = [];

  final List<Memberships> _studentMemberships = [];

  final List<Memberships> _remainingMemberships = [];

  StateOfMemberships stateOfFetchingMemberships = StateOfMemberships.initial;

  StateOfSeasons stateOfFetchingSeasons = StateOfSeasons.initial;

  preparingSeasons() async {
    _seasonsList.clear();
    _seasonsOfDropButton.clear();
    stateOfFetchingSeasons = StateOfSeasons.loading;
    QuerySnapshot querySnapshot = await _collectionRef.get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      QueryDocumentSnapshot data = querySnapshot.docs[i];
      addInSeasonsList(data);
      addInSeasonFormat(data);
    }
    stateOfFetchingSeasons = StateOfSeasons.loaded;
    notifyListeners();
  }

  addInSeasonFormat(QueryDocumentSnapshot data) {
    _seasonsOfDropButton.add(SeasonsFormat(
        seasonDocId: data["docId"],
        season: "${data["year"]} , ${data["season"]}"));
  }

  addInSeasonsList(QueryDocumentSnapshot data) {
    _seasonsList.add(Season(
        year: data["year"],
        seasonType: data["season"],
        seasonDocId: data["docId"],
        studentsDocIds: data["students"],
        eventsDocIds: data["events"]));
  }

  preparingMemberships(String studentDocId) async {
    stateOfFetchingMemberships = StateOfMemberships.loading;
    _studentMemberships.clear();
    _remainingMemberships.clear();
    //get the list of ids of memberships
    List<dynamic> docIds = await membershipsDocIds(studentDocId);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    looping(docIds, querySnapshot);
    stateOfFetchingMemberships = StateOfMemberships.loaded;
    notifyListeners();
  }

  looping(List<dynamic> docIds, QuerySnapshot querySnapshot) {
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      QueryDocumentSnapshot data = querySnapshot.docs[i];
      docIds.contains(data.id)
          ? addInStudentMembershipsList(data)
          : addInRemainingMembershipsList(data);
    }
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

  studentMembershipsCleared() {
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
