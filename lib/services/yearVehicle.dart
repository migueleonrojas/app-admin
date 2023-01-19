import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class YearVehicle {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future <bool> validateNoDuplicateRows(int year) async {

    final QuerySnapshot<Map<String, dynamic>> result = await _firebaseFirestore
      .collection("yearsVehicle")
      .where(
        'year', isEqualTo: year
      )
      .get();

    return result.docs.isNotEmpty;
    

  }

  Future <bool> yearVehicleIsAssigned(int year) async {

    final QuerySnapshot<Map<String, dynamic>> resultVehicles = await _firebaseFirestore
      .collection("vehicles")
      .where(
        'year', isEqualTo: year
      )
      .get();

    return resultVehicles.docs.isNotEmpty;

  }

  void createYearVehicle(int year) {
    var id = Uuid();
    String yearId = id.v1();
    _firebaseFirestore
        .collection("yearsVehicle")
        .doc(yearId)
        .set({
          'id': yearId,
          'year': year,
        });
  }

  void updateYearVehicle(String idYear, int year) {
    _firebaseFirestore.collection("yearsVehicle")
    .doc(idYear.toString()).update({
      "year":year,
    });
  }

  void deleteYearVehicle(String idYear){
    _firebaseFirestore.collection("yearsVehicle")
    .doc(idYear.toString()).delete();
  }
}
