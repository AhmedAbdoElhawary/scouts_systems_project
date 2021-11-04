import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

enum SeasonType { summer, winter }

class Season {
  final String year;
  final String seasonType;
  final String id;
  Season(this.year, this.seasonType, this.id);
}

class DBSeasons extends ChangeNotifier {
  final CollectionReference _seasonsRef =
      FirebaseFirestore.instance.collection('seasons');

  final List<Season> _seasons = [];

  getAllSeasonsData() async {
    QuerySnapshot snap = await _seasonsRef.get();
    _seasons.clear();
    for (int i = 0; i < snap.docs.length; i++) {
      final seasonDoc = snap.docs[i];
      QueryDocumentSnapshot data = snap.docs[i];

      _seasons.add(Season(data['year'], data['season'], seasonDoc.id));

      notifyListeners();
    }
  }

  List<Season> get seasons => _seasons;
}
