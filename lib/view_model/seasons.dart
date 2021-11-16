import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/model/firestore/add_students.dart';

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

class SeasonFormat {
  String season;
  String seasonDocId;
  SeasonFormat({this.seasonDocId = "", this.season = ""});
}

class Membership {
  final String year;
  final String seasonType;
  final String docId;
  Membership(
      {required this.year, required this.seasonType, required this.docId});
}

class SeasonsProvider extends ChangeNotifier {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('seasons');

  final List<Season> _seasonsList = [];

  final List<SeasonFormat> _seasonsOfDropButton = [];

  final List<Membership> _selectedMemberships = [];

  final List<String> _selectedMembershipsIds = [];

  final List<Membership> _studentMemberships = [];

  String _selectedSeasonOfEvent = "";

  StateOfMemberships stateOfFetchingMemberships = StateOfMemberships.initial;

  StateOfSeasons stateOfFetchingSelectedSeason = StateOfSeasons.initial;

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
    _seasonsOfDropButton.add(SeasonFormat(
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

  neededSeasonOfEvent(
      {required String seasonDocId, required String eventDocId}) async {
    stateOfFetchingSelectedSeason = StateOfSeasons.loading;
    print(stateOfFetchingSelectedSeason);
    DocumentSnapshot snap = await _collectionRef
        .doc(seasonDocId.isEmpty ? "nothing" : seasonDocId)
        .get();
    if (snap.exists) {
      _selectedSeasonOfEvent = "${snap.get("year")} , ${snap.get("season")}";
      print("provider ${_selectedSeasonOfEvent}");
    } else {
      FirestoreEvents().deleteSeasonOfEvent(eventDocId: eventDocId);
      _selectedSeasonOfEvent = "nothing";
      print("provider ${_selectedSeasonOfEvent}");
    }
    stateOfFetchingSelectedSeason = StateOfSeasons.loaded;
    print(stateOfFetchingSelectedSeason);
    notifyListeners();
  }

  preparingMemberships(String studentDocId) async {
    stateOfFetchingMemberships = StateOfMemberships.loading;
    _selectedMembershipsIds.clear();
    _selectedMemberships.clear();
    _studentMemberships.clear();
    //get the list of ids of memberships
    List<dynamic> membershipsDocIdsList = await membershipsDocIds(studentDocId);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    addInMembershipsLists(membershipsDocIdsList, querySnapshot, studentDocId);
    stateOfFetchingMemberships = StateOfMemberships.loaded;
    notifyListeners();
  }

  addInMembershipsLists(List<dynamic> membershipDocIds,
      QuerySnapshot querySnapshot, String studentDocId) {
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      QueryDocumentSnapshot season = querySnapshot.docs[i];
      season.exists
          ? addMembership(season, membershipDocIds)
          : deleteMembership(season, studentDocId);
    }
  }

  addMembership(QueryDocumentSnapshot season, List<dynamic> membershipDocIds) {
    membershipsList(season);
    if (membershipDocIds.contains(season.id)) {
      addInSelectedMembershipsList(season);
      _selectedMembershipsIds.add("${season["docId"]}");
    }
  }

  deleteMembership(QueryDocumentSnapshot season, String studentDocId) {
    FirestoreStudents().deleteMembership(
        seasonDocId: season["docId"], studentDocId: studentDocId);
  }

  addInSelectedMembershipsList(QueryDocumentSnapshot data) {
    _selectedMemberships.add(Membership(
        year: data["year"], seasonType: data["season"], docId: data["docId"]));
  }

  membershipsList(QueryDocumentSnapshot data) {
    _studentMemberships.add(Membership(
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

  clearStudentMembershipsList() => _selectedMemberships.clear();

  clearMembershipsIds() => _selectedMembershipsIds.clear();

  clearMembershipsList() => _studentMemberships.clear();

  clearSeasonsList() => _seasonsList.clear();

  clearSelectedSeasonOfEvent() => _selectedSeasonOfEvent = "";

  List<SeasonFormat> get seasonsOfDropButton => _seasonsOfDropButton;

  List<Membership> get selectedMemberships => _selectedMemberships;

  List<Membership> get studentMemberships => _studentMemberships;

  String get selectedSeasonOfEvent => _selectedSeasonOfEvent;

  List<String> get selectedMembershipsIds => _selectedMembershipsIds;

  List<Season> get seasonsList => _seasonsList;
}
