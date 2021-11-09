import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Students {
  final String name;
  final String description;
  final String birthdate;
  final String volunteeringHours;
  final String docId;
  Students(
      {this.name = "",
      this.docId = "",
      this.description = "",
      this.birthdate = "",
      this.volunteeringHours = ""});
}

enum StateOfStudents { initial, loaded, loading }
enum StateOfSelectedStudents { initial, loaded, loading }
enum StateOfSpecificStudents { initial, loaded, loading }

class StudentsLogic extends ChangeNotifier {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('students');

  final List<Students> _studentsList = [];

  final List<Students> _selectedStudents = [];

  final List<Students> _remainingStudents = [];

  final List<Students> _specificStudents = [];

  StateOfStudents stateOfFetching = StateOfStudents.initial;

  StateOfSelectedStudents stateOfSelectedFetching =
      StateOfSelectedStudents.initial;

  StateOfSpecificStudents stateOfSpecificFetching =
      StateOfSpecificStudents.initial;

  preparingStudents() async {
    _studentsList.clear();
    stateOfFetching = StateOfStudents.loading;
    QuerySnapshot snap = await _collectionRef.get();
    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot data = snap.docs[i];
      _studentsList.add(mainStudent(data));
    }
    stateOfFetching = StateOfStudents.loaded;
    notifyListeners();
  }

  Students mainStudent(QueryDocumentSnapshot<Object?> data) {
    return Students(
        name: data["name"],
        description: data["description"],
        birthdate: data["date"],
        volunteeringHours: data["volunteeringHours"],
        docId: data["docId"]);
  }

  preparingSpecificStudents({required List<dynamic> studentsDocIds}) async {
    _specificStudents.clear();
    stateOfSpecificFetching = StateOfSpecificStudents.loading;
    for (int i = 0; i < studentsDocIds.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(studentsDocIds[i]).get();
      getTheStudent(snap);
    }
    stateOfSpecificFetching = StateOfSpecificStudents.loaded;
    notifyListeners();
  }

  preparingStudentsInEvent(
      {required String seasonDocId, required String eventDocId}) async {
    _selectedStudents.clear();
    _remainingStudents.clear();
    stateOfSelectedFetching = StateOfSelectedStudents.loading;
    List<dynamic> studentsIdsSeason = await studentsDocIdsInSeason(seasonDocId);
    List<dynamic> studentsDocIdsEvent = await studentsDocIdsInEvent(eventDocId);
    addStudentsInEventList(studentsIdsSeason, studentsDocIdsEvent);
    stateOfSelectedFetching = StateOfSelectedStudents.loaded;
    notifyListeners();
  }

  addStudentsInEventList(List<dynamic> studentsIdsSeason,
      List<dynamic> studentsDocIdsEvent) async {
    for (int i = 0; i < studentsIdsSeason.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(studentsIdsSeason[i]).get();
      Students student = getTheStudent(snap);
      studentsDocIdsEvent.contains(studentsIdsSeason[i])
          ? _selectedStudents.add(student)
          : _remainingStudents.add(student);
    }
    notifyListeners();
  }

  Students getTheStudent(DocumentSnapshot<Object?> snap) {
    return Students(
        name: snap.get("name"),
        birthdate: snap.get("date"),
        description: snap.get("description"),
        docId: snap.get("docId"),
        volunteeringHours: snap.get("volunteeringHours"));
  }

  Future<List<dynamic>> studentsDocIdsInSeason(String seasonDocId) async {
    DocumentSnapshot<Map<String, dynamic>> remainingMemberships =
        await FirebaseFirestore.instance
            .collection('seasons')
            .doc(seasonDocId)
            .get();
    return remainingMemberships["students"];
  }

  Future<List<dynamic>> studentsDocIdsInEvent(String eventDocId) async {
    DocumentSnapshot<Map<String, dynamic>> selectedMemberships =
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventDocId)
            .get();
    return selectedMemberships["students"];
  }

  studentsListCleared() {
    _studentsList.clear();
  }

  selectedStudentsCleared() {
    _selectedStudents.clear();
  }

  List<Students> get specificStudents => _specificStudents;

  List<Students> get selectedStudents => _selectedStudents;

  List<Students> get studentsList => _studentsList;

  List<Students> get remainingStudents => _remainingStudents;
}
