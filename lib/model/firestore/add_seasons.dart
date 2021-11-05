import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:scouts_system/common_ui/toast_show.dart';

class addFirestoreSeasons {
  var _firestoreCollectionSeasons =
      FirebaseFirestore.instance.collection('seasons');
  addDataFirestoreSeasons({
    required String year,
    required String season,
  }) {
    String seasonRandomDocId = randomAlphaNumeric(20);

    _firestoreCollectionSeasons
        .doc(seasonRandomDocId)
        .set({
          'year': year,
          "season": season,
          "events": [],
          "docId": seasonRandomDocId,
          "students": [],
        })
        .then((value) => ToastShow().showWhiteToast("season added "))
        .catchError((error) =>
            ToastShow().showRedToast("Failed to update season: $error"));
  }

  addNewEventInSeason({required String year,
      required String season,
      required String eventDocId}) async {
    QuerySnapshot resultOfYear = await _firestoreCollectionSeasons
        .where("year", isEqualTo: year)
        .where("season", isEqualTo: season)
        .get();

    final List<DocumentSnapshot> documentsYear = resultOfYear.docs;
    String seasonDocId = "";
    if (documentsYear.length > 0) {
      seasonDocId = documentsYear[0].id;
      _firestoreCollectionSeasons.doc(seasonDocId).update({
        "events": FieldValue.arrayUnion([eventDocId])
      });
    } else {
      ToastShow().showRedToast("Failed to add the event in season !");
    }
  }

  addNewStudentInSeason(
      {required String studentDocId, required String seasonDocId}) async {
    _firestoreCollectionSeasons
        .doc(seasonDocId)
        .update({
          'students': FieldValue.arrayUnion([studentDocId]),
        })
        .then(
            (value) => ToastShow().showWhiteToast("student added in season !"))
        .catchError((error) => ToastShow()
            .showRedToast("fFailed to add student in season ->$error"));
  }
}
