import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/model_vehicle_with_brand.dart';
import 'package:uuid/uuid.dart';

class ModelVehicle {
  
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool dataFinish = false;
  final StreamController <List<ModelVehicleWithBrand>> _suggestionStreamControler = StreamController.broadcast();
  Stream<List<ModelVehicleWithBrand>> get suggestionStream => _suggestionStreamControler.stream;
  List<ModelVehicleWithBrand> modelsWithBrandName = [];
  QuerySnapshot? collectionState;

  Future <bool> getModelsVehicle({int limit = 5, bool nextDocument = false}) async {

    QuerySnapshot<Map<String, dynamic>>? querySnapshotModel;

    if(!nextDocument){
      final collectionModels = await FirebaseFirestore.instance
      .collection('modelsVehicle')
      .orderBy("name", descending: false)
      .get();

      if(collectionModels.size < limit) {
        limit = collectionModels.size;
      }

      final collection = FirebaseFirestore.instance
      .collection('modelsVehicle')
      .limit(limit)
      .orderBy("name", descending: false);

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotModel = await collection.get();
    }

    else{
      final lastVisible = collectionState!.docs[collectionState!.docs.length-1];

      final collection = FirebaseFirestore.instance
      .collection('modelsVehicle')
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

      querySnapshotModel = await collection.get();  
    }

    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsModels = querySnapshotModel.docs;

    QuerySnapshot<Map<String, dynamic>> querySnapshotBrands = await FirebaseFirestore.instance
        .collection('brandsVehicle')
        .get();
    List<Map<String, dynamic>> querySnapshotBrandsFiltered = [];
    List<Map<String,dynamic>> documentsBrands = querySnapshotBrandsFiltered;  

    

    for(final documentModel in documentsModels) {
      
      
      for(final querySnapshotBrand in querySnapshotBrands.docs) {
        if(documentModel.data()['id_brand'] == querySnapshotBrand.data()['id']){
        
          querySnapshotBrandsFiltered.add(querySnapshotBrand.data());
        }
      }
      
      
      for(final documentBrand in querySnapshotBrandsFiltered){

       
        modelsWithBrandName.add(ModelVehicleWithBrand.fromJson({
          "brandName": (documentBrand as dynamic)['name'],
          "modelVehicle": documentModel.data()
        }));
        
          
      }
    } 
    _suggestionStreamControler.add(modelsWithBrandName);
    
    return dataFinish;

    /* QuerySnapshot<Map<String, dynamic>> querySnapshotModel = await FirebaseFirestore.instance
      .collection('modelsVehicle').get();

    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsModels = querySnapshotModel.docs;

    for(final documentModel in documentsModels) {
      
      QuerySnapshot<Map<String, dynamic>> querySnapshotBrand = await FirebaseFirestore.instance.collection('brandsVehicle').where('id', isEqualTo: (documentModel.data() as dynamic)['id_brand']).get();
      List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsBrands = querySnapshotBrand.docs;
      for(final documentBrand in documentsBrands){
       
        modelsWithBrandName.add(ModelVehicleWithBrand.fromJson({
          "brandName": (documentBrand.data() as dynamic)['name'],
          "modelVehicle": documentModel.data()
        }));
        
          
      }
    } 
    _suggestionStreamControler.add(modelsWithBrandName);
    
    return dataFinish; */

  }


  Future <bool> validateNoDuplicateRows(String name, String slug, int idBrand) async {

    final QuerySnapshot<Map<String, dynamic>> result = await _firebaseFirestore
      .collection("modelsVehicle")
      .where(
        'name', isEqualTo: name
      )
      .where(
        'slug',isEqualTo: slug
      )
      .where(
        'id_brand', isEqualTo: idBrand
      )
      .get();

    return result.docs.isNotEmpty;
    

  }

  Future <bool> modelNameVehicleIsAssigned(String model, int idBrand, String brandName) async {

    final QuerySnapshot<Map<String, dynamic>> resultBrandId = await _firebaseFirestore
      .collection('brandsVehicle')
      .where('id', isEqualTo: idBrand)
      .get();
    
    final QuerySnapshot<Map<String, dynamic>> resultVehicles = await _firebaseFirestore
      .collection("vehicles")
      .where(
        'model', isEqualTo: model
      )
      .where(
        'brand', isEqualTo: brandName
      )
      .get();

    return resultBrandId.docs.isNotEmpty && resultVehicles.docs.isNotEmpty ;

  }

  void createModelVehicle(int brandIdSelected, int idModel, String name, String slug) {
    /* var id = Uuid();
    String modelId = id.v1(); */
    _firebaseFirestore
        .collection("modelsVehicle")
        .doc(idModel.toString())
        .set({
          'id_brand': brandIdSelected,
          'id': idModel,
          'name': name,
          'slug': slug
        });
  }

  void updateModelVehicle(int idModel, String name, String slug) {
    _firebaseFirestore.collection("modelsVehicle")
    .doc(idModel.toString()).update({
      "name": name,
      "slug": slug,
    });
  
  }

  void deleteModelVehicle(int idBrand){
    _firebaseFirestore.collection("modelsVehicle")
    .doc(idBrand.toString()).delete();
  }

  deleteAllModelsForIdBrand(int idBrand) async {
    final query = _firebaseFirestore
      .collection("modelsVehicle")
      .where("id_brand", isEqualTo: idBrand);

    query.get().then((querySnapshot) =>  querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
     }));

  }

  Future <int> getLastIdRow() async {

    final QuerySnapshot<Map<String, dynamic>> brandsVehicle = await _firebaseFirestore
      .collection('modelsVehicle')
      .orderBy('id',descending: false)
      .get();

    

    if(brandsVehicle.docs.isEmpty){
      
      return 1;
    }
    else{
      
      final lastId = brandsVehicle.docs.last.data()['id'] + 1;
      return lastId;
    }

  }



  
}
