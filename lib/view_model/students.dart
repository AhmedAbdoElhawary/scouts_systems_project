import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scouts_system/model/firestore/add_events.dart';
import 'package:scouts_system/model/firestore/add_seasons.dart';

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

  final List<Student> _studentsOfEvent = [];

  final List<Student> _selectedStudents = [];

  final List<String> _selectedStudentsIds = [];

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

  preparingNeededStudents(
      {required List<dynamic> studentsDocIds,
      required String seasonDocId}) async {
    _neededStudents.clear();
    stateOfSpecificFetching = StateOfSpecificStudents.loading;
    for (int i = 0; i < studentsDocIds.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(studentsDocIds[i]).get();
      snap.exists
          ? _neededStudents.add(getTheStudent(snap))
          : FirestoreSeasons().deleteStudentInSeason(
              studentDocId: studentsDocIds[i], seasonDocId: seasonDocId);
    }
    stateOfSpecificFetching = StateOfSpecificStudents.loaded;
    notifyListeners();
  }

  preparingStudentsInEvent(
      {required String seasonDocId, required String eventDocId}) async {
    _studentsOfEvent.clear();
    _selectedStudents.clear();
    _selectedStudentsIds.clear();
    stateOfSelectedFetching = StateOfSelectedStudents.loading;
    List<dynamic> studentsIdsSeason = await studentsDocIdsInSeason(seasonDocId);
    List<dynamic> studentsDocIdsEvent = await studentsDocIdsInEvent(eventDocId);
    addStudentsInEventList(studentsIdsSeason, studentsDocIdsEvent, eventDocId);
    stateOfSelectedFetching = StateOfSelectedStudents.loaded;
    notifyListeners();
  }

  addStudentsInEventList(List<dynamic> studentsIdsSeason,
      List<dynamic> studentsDocIdsEvent, String eventDocId) async {
    for (int i = 0; i < studentsIdsSeason.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(studentsIdsSeason[i]).get();

      snap.exists
          ? addStudent(studentsIdsSeason, studentsDocIdsEvent, snap, i)
          : deleteStudentOfEvent(studentsIdsSeason[i], eventDocId);
    }
    notifyListeners();
  }

  addStudent(List<dynamic> studentsIdsSeason, List<dynamic> studentsDocIdsEvent,
      DocumentSnapshot<Object?> snap, int i) {
    Student student = getTheStudent(snap);
    _studentsOfEvent.add(student);
    if (studentsDocIdsEvent.contains(studentsIdsSeason[i])) {
      _selectedStudents.add(student);
      _selectedStudentsIds.add(student.docId);
    }
  }

  deleteStudentOfEvent(dynamic studentsIdSeason, String eventDocId) {
    FirestoreEvents().deleteStudentOfEvent(
        studentDocId: studentsIdSeason, eventDocId: eventDocId);
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

  clearStudentsOfEvent() {
    _studentsOfEvent.clear();
  }

  clearSelectedStudentsList() {
    _selectedStudents.clear();
  }

  clearSelectedStudentsIds() {
    _selectedStudentsIds.clear();
  }

  clearNeededStudentsList() {
    _neededStudents.clear();
  }

  List<Student> get neededStudents => _neededStudents;

  List<Student> get selectedStudents => _selectedStudents;

  List<Student> get studentsOfEvent => _studentsOfEvent;

  List<String> get selectedStudentsIds => _selectedStudentsIds;

  List<Student> get studentsList => _studentsList;
}
