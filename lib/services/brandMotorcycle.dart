import 'package:cloud_firestore/cloud_firestore.dart';

class BrandMotorcycle {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future <bool> validateNoDuplicateRows(String name, String slug) async {

    final QuerySnapshot<Map<String, dynamic>> result = await _firebaseFirestore
      .collection("brandsMotorcycle")
      .where(
        'name', isEqualTo: name
      )
      .where(
        'slug',isEqualTo: slug
      )
      .get();
    return result.docs.isNotEmpty;
  }

  Future <bool> brandNameMotorcycleIsAssigned(String brand) async {

    final QuerySnapshot<Map<String, dynamic>> resultMotorcycles = await _firebaseFirestore
      .collection("vehicles")
      .where(
        'brand', isEqualTo: brand
      )
      .get();

    return resultMotorcycles.docs.isNotEmpty;

  }

  void createBrandMotorcycle(int idBrand, String name, String slug, dynamic url) {
    /* var id = Uuid();
    String brandId = id.v1(); */
    _firebaseFirestore
        .collection("brandsMotorcycle")
        .doc(idBrand.toString())
        .set({
          'id':  idBrand,
          'name': name,
          'slug': slug,
          'logo': url,
        });
  }

  void updateBrandMotorcycle(String idBrand, String name, String slug, String newLogo) {
    _firebaseFirestore.collection("brandsMotorcycle")
    .doc(idBrand).update({
      "name": name,
      "slug": slug,
      "logo": newLogo
    });
  
  }

  void deleteBrandMotorcycle(String idBrand){
    _firebaseFirestore.collection("brandsMotorcycle")
    .doc(idBrand).delete();
  }

  Future <int> getLastIdRow() async {

    final QuerySnapshot<Map<String, dynamic>> brandsMotorcycle = await _firebaseFirestore
      .collection('brandsMotorcycle')
      .orderBy('id', descending:  false)
      .get();

    if(brandsMotorcycle.docs.isEmpty){
      
      return 1;
    }
    else{
      final lastId = brandsMotorcycle.docs.last.data()['id'] + 1;
      return lastId;
    }

  }

  Future <List> getBrandsMotorcycle() async {
    
    List _allBrands = <Map<String, dynamic>>[];
    
    final QuerySnapshot<Map<String, dynamic>> brandsMotorcycle = await _firebaseFirestore.collection('brandsMotorcycle').get();  
    
    for(final brand in brandsMotorcycle.docs) {
      
      _allBrands.add(brand.data());
      
    }

    return _allBrands;
     
  }

}