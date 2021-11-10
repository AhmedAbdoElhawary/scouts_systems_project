import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Student {
  final String name;
  final String description;
  final String birthdate;
  final String volunteeringHours;
  final String docId;
  Student(
      {this.name = "",
      this.docId = "",
      this.description = "",
      this.birthdate = "",
      this.volunteeringHours = ""});
}

enum StateOfStudents { initial, loaded, loading }
enum StateOfSelectedStudents { initial, loaded, loading }
enum StateOfSpecificStudents { initial, loaded, loading }

class StudentsProvider extends ChangeNotifier {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('students');

  final List<Student> _studentsList = [];

  final List<Student> _selectedStudents = [];

  final List<Student> _remainingStudents = [];

  final List<Student> _neededStudents = [];

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

  Student mainStudent(QueryDocumentSnapshot<Object?> data) {
    return Student(
        name: data["name"],
        description: data["description"],
        birthdate: data["date"],
        volunteeringHours: data["volunteeringHours"],
        docId: data["docId"]);
  }

  preparingNeededStudents({required List<dynamic> studentsDocIds}) async {
    _neededStudents.clear();
    stateOfSpecificFetching = StateOfSpecificStudents.loading;
    for (int i = 0; i < studentsDocIds.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(studentsDocIds[i]).get();
      _neededStudents.add(getTheStudent(snap));
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
      Student student = getTheStudent(snap);
      studentsDocIdsEvent.contains(studentsIdsSeason[i])
          ? _selectedStudents.add(student)
          : _remainingStudents.add(student);
    }
    notifyListeners();
  }

  Student getTheStudent(DocumentSnapshot<Object?> snap) {
    return Student(
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

  clearStudentsList() {
    _studentsList.clear();
  }

  clearSelectedStudentsList() {
    _selectedStudents.clear();
  }

  clearNeededStudentsList(){
    _neededStudents.clear();
  }

  List<Student> get neededStudents => _neededStudents;

  List<Student> get selectedStudents => _selectedStudents;

  List<Student> get studentsList => _studentsList;

  List<Student> get remainingStudents => _remainingStudents;
}
