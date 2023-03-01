import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryServiceAndProduct {
  
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future <bool> validateNoDuplicateRows(String categoryName) async {

    final QuerySnapshot<Map<String, dynamic>> result = await _firebaseFirestore
      .collection("categories")
      .where(
        'categoryName', isEqualTo: categoryName
      )
      .get();
    return result.docs.isNotEmpty;
  }

  Future <bool> categoryIsAssignedOnProducts(String categoryName) async {

    final QuerySnapshot<Map<String, dynamic>> resultProducts = await _firebaseFirestore
      .collection("products")
      .where(
        'categoryName', isEqualTo: categoryName
      )
      .get();

    return resultProducts.docs.isNotEmpty;

  }

  Future <bool> categoryIsAssignedOnServices(String categoryName) async {

    final QuerySnapshot<Map<String, dynamic>> resultProducts = await _firebaseFirestore
      .collection("service")
      .where(
        'categoryName', isEqualTo: categoryName
      )
      .get();

    return resultProducts.docs.isNotEmpty;

  }

  void createCategory(String categoryName) {
    /* var id = Uuid();
    String brandId = id.v1(); */
    _firebaseFirestore
        .collection("categories")
        .doc()
        .set({
          'categoryName':  categoryName,
        });
  }

  void updateCategory(String categoryName, String newcategoryName) async {
    
    final QuerySnapshot<Map<String, dynamic>> categories = await _firebaseFirestore
      .collection('categories').where('categoryName', isEqualTo: categoryName).get();

    for(final category in categories.docs) {
      _firebaseFirestore.collection('categories').doc(category.id).update({
        "categoryName": newcategoryName
      });
    }
    
  }

  void deleteCategory(String categoryName) async {
    final QuerySnapshot<Map<String, dynamic>> categories = await _firebaseFirestore
      .collection('categories').where('categoryName', isEqualTo: categoryName).get();
    for(final category in categories.docs) {
      _firebaseFirestore.collection('categories').doc(category.id).delete();
    }
  }
 
}
