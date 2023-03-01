import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ColorVehicle {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  void createColorVehicle(int color) {
    var id = Uuid();
    String colorId = id.v1();
    _firebaseFirestore
        .collection("colorsVehicle")
        .doc(colorId)
        .set({
          'codeColor': color,
        });
  }
}
