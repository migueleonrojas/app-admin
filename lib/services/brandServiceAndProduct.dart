import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandServiceAndProduct {
  
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future <bool> validateNoDuplicateRows(String brandName) async {

    final QuerySnapshot<Map<String, dynamic>> result = await _firebaseFirestore
      .collection("brands")
      .where(
        'brandName', isEqualTo: brandName
      )
      .get();
    return result.docs.isNotEmpty;
  }

  Future <bool> brandNameIsAssignedOnProducts(String brandName) async {

    final QuerySnapshot<Map<String, dynamic>> resultProducts = await _firebaseFirestore
      .collection("products")
      .where(
        'brandName', isEqualTo: brandName
      )
      .get();

    return resultProducts.docs.isNotEmpty;

  }

  Future <bool> brandNameIsAssignedOnServices(String brandName) async {

    final QuerySnapshot<Map<String, dynamic>> resultProducts = await _firebaseFirestore
      .collection("service")
      .where(
        'brandName', isEqualTo: brandName
      )
      .get();

    return resultProducts.docs.isNotEmpty;

  }


  void createBrand(String brandName) {
    /* var id = Uuid();
    String brandId = id.v1(); */
    _firebaseFirestore
        .collection("brands")
        .doc()
        .set({
          'brandName':  brandName,
        });
  }

  void updateBrand(String brandName, String newBranName) async {
    
    final QuerySnapshot<Map<String, dynamic>> brands = await _firebaseFirestore
      .collection('brands').where('brandName', isEqualTo: brandName).get();

    for(final brand in brands.docs) {
      _firebaseFirestore.collection('brands').doc(brand.id).update({
        "brandName": newBranName
      });
    }
    
  }

  void deleteBrand(String brandName) async {
    final QuerySnapshot<Map<String, dynamic>> brands = await _firebaseFirestore
      .collection('brands').where('brandName', isEqualTo: brandName).get();
    for(final brand in brands.docs) {
      _firebaseFirestore.collection('brands').doc(brand.id).delete();
    }
  }

 

  

  
}
