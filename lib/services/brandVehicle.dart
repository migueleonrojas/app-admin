import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandVehicle {
  
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future <bool> validateNoDuplicateRows(String name, String slug) async {

    final QuerySnapshot<Map<String, dynamic>> result = await _firebaseFirestore
      .collection("brandsVehicle")
      .where(
        'name', isEqualTo: name
      )
      .where(
        'slug',isEqualTo: slug
      )
      .get();
    return result.docs.isNotEmpty;
  }

  Future <bool> brandNameVehicleIsAssigned(String brand) async {

    final QuerySnapshot<Map<String, dynamic>> resultVehicles = await _firebaseFirestore
      .collection("vehicles")
      .where(
        'brand', isEqualTo: brand
      )
      .get();

    return resultVehicles.docs.isNotEmpty;

  }

  


  void createBrandVehicle(int idBrand, String name, String slug, dynamic url) {
    /* var id = Uuid();
    String brandId = id.v1(); */
    _firebaseFirestore
        .collection("brandsVehicle")
        .doc(idBrand.toString())
        .set({
          'id':  idBrand,
          'name': name,
          'slug': slug,
          'logo': url,
        });
  }

  void updateBrandVehicle(String idBrand, String name, String slug, String newLogo) {
    _firebaseFirestore.collection("brandsVehicle")
    .doc(idBrand).update({
      "name": name,
      "slug": slug,
      "logo": newLogo
    });
  
  }

  void deleteBrandVehicle(String idBrand){
    _firebaseFirestore.collection("brandsVehicle")
    .doc(idBrand).delete();
  }

  Future <int> getLastIdRow() async {

    final QuerySnapshot<Map<String, dynamic>> brandsVehicle = await _firebaseFirestore
      .collection('brandsVehicle')
      .orderBy('id', descending:  false)
      .get();

    if(brandsVehicle.docs.isEmpty){
      
      return 1;
    }
    else{
      final lastId = brandsVehicle.docs.last.data()['id'] + 1;
      return lastId;
    }
    

  }

  

  Future <List> getBrandsVehicle() async {
    
    List _allBrands = <Map<String, dynamic>>[];
    
    final QuerySnapshot<Map<String, dynamic>> brandsVehicle = await _firebaseFirestore.collection('brandsVehicle').get();  
    
    for(final brand in brandsVehicle.docs) {
      
      _allBrands.add(brand.data());
      
    }

    return _allBrands;
     
  }
}
