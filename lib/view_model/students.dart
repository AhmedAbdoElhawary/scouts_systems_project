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

class StudentsLogic extends ChangeNotifier {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('students');

  List<Students> _studentsList = [];

  List<Students> _selectedStudents = [];

  List<Students> _remainingStudents = [];

  StateOfStudents stateOfFetching = StateOfStudents.initial;

  StateOfSelectedStudents stateOfSelectedFetching = StateOfSelectedStudents.initial;

  preparingStudents() async {
    stateOfFetching = StateOfStudents.loading;
    QuerySnapshot snap = await _collectionRef.get();
    for (int i = 0; i < snap.docs.length; i++) {
      QueryDocumentSnapshot data = snap.docs[i];
      print(i);
      _studentsList.add(Students(
          name: data["name"],
          description: data["description"],
          birthdate: data["date"],
          volunteeringHours: data["volunteeringHours"],
          docId: data["docId"]));
    }
    stateOfFetching = StateOfStudents.loaded;
    notifyListeners();
  }

  preparingStudentsInEvent(
      {required String seasonDocId, required String eventDocId}) async {
    stateOfSelectedFetching=StateOfSelectedStudents.loading;
    List<dynamic> studentsIdsSeason = await studentsDocIdsInSeason(seasonDocId);
    List<dynamic> studentsDocIdsEvent = await studentsDocIdsInEvent(eventDocId);
    for (int i = 0; i < studentsIdsSeason.length; i++) {
      DocumentSnapshot<Object?> snap =
          await _collectionRef.doc(studentsIdsSeason[i]).get();
      Students student = getTheStudent(snap);
      studentsDocIdsEvent.contains(studentsIdsSeason[i])
          ? _selectedStudents.add(student)
          : _remainingStudents.add(student);
    }
    stateOfSelectedFetching=StateOfSelectedStudents.loaded;
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
    DocumentSnapshot<Map<String, dynamic>> listOfMemberships =
        await FirebaseFirestore.instance
            .collection('seasons')
            .doc(seasonDocId)
            .get();
    return listOfMemberships["students"];
  }

  Future<List<dynamic>> studentsDocIdsInEvent(String eventDocId) async {
    DocumentSnapshot<Map<String, dynamic>> listOfMemberships =
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventDocId)
            .get();
    return listOfMemberships["students"];
  }

  studentsListCleared() {
    _studentsList.clear();
  }

  selectedStudentsCleared(){
    _selectedStudents.clear();
  }

  remainingStudentsCleared(){
    _remainingStudents.clear();
  }

  List<Students> get selectedStudents => _selectedStudents;

  List<Students> get studentsList => _studentsList;

  List<Students> get remainingStudents => _remainingStudents;
}
