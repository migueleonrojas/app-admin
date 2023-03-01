import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandVehicleService {
  
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool dataFinish = false;


  final StreamController <List<Map<String,dynamic>>> _suggestionStreamControlerBrandsVehicles = StreamController.broadcast();
  Stream<List<Map<String,dynamic>>> get suggestionStreamBrandsVehicles => _suggestionStreamControlerBrandsVehicles.stream;
  List<Map<String,dynamic>> brandsVehicles = [];
  QuerySnapshot? collectionState;

  Future <bool> getBrandsVehicleLimit({int limit = 5, bool nextDocument = false}) async {

    QuerySnapshot<Map<String, dynamic>>? querySnapshotBrandsVehicle;

    if(!nextDocument){
      final collectionBrands = await FirebaseFirestore.instance
      .collection('brandsVehicle')
      .orderBy("name", descending: false)
      .get();

      if(collectionBrands.size < limit) {
        limit = collectionBrands.size;
      }

      final collection = FirebaseFirestore.instance
      .collection('brandsVehicle')
      .limit(limit)
      .orderBy("name", descending: false);

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotBrandsVehicle = await collection.get();
    }

    else{
      final lastVisible = collectionState!.docs[collectionState!.docs.length-1];

      final collection = FirebaseFirestore.instance
      .collection('brandsVehicle')
      .limit(limit)
      .orderBy("name", descending: false)
      .startAfterDocument(lastVisible);

      final collectionGet = await collection.get();

      if(collectionGet.size == 0) {
        dataFinish = true;
        return dataFinish;
      }

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotBrandsVehicle = await collection.get();  
    }

    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsBrands = querySnapshotBrandsVehicle.docs;

    for(final documentsBrand in documentsBrands) {
      brandsVehicles.add(documentsBrand.data());
    }

    _suggestionStreamControlerBrandsVehicles.add(brandsVehicles);

    return dataFinish;
  }

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
