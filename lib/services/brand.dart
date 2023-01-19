import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  void createBrad(String name) {
    var id = Uuid();
    String brandId = id.v1();
    _firebaseFirestore
        .collection("brands")
        .doc(brandId)
        .set({'brandName': name});
  }

  Future <bool> validateNoDuplicateRows(String brandName) async {
    final QuerySnapshot<Map<String, dynamic>> result = await _firebaseFirestore
      .collection("brands")
      .where(
        'brandName', isEqualTo: brandName
      )
      .get();
    return result.docs.isNotEmpty;
  }
}
