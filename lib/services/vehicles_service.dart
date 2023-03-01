import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehiclesService{

  final StreamController <List<Map<String,dynamic>>> _suggestionStreamControlerVehicles = StreamController.broadcast();
  Stream<List<Map<String,dynamic>>> get suggestionStreamVehicles => _suggestionStreamControlerVehicles.stream;
  List<Map<String,dynamic>> vehicles = [];
  QuerySnapshot? collectionState;
  bool dataFinish = false;


  Future <bool> getVehicles({int limit = 5, bool nextDocument = false, String userId = "", String typeOfVehicle = ''}) async {



    QuerySnapshot<Map<String, dynamic>>? querySnapshotVehicles;
    QuerySnapshot<Map<String, dynamic>>? collectionVehicles;
    if(!nextDocument){
      print(userId);
      if(userId.isEmpty){
        
        collectionVehicles = await FirebaseFirestore.instance
        .collection("usersVehicles")
        .where('typeOfVehicle',isEqualTo: typeOfVehicle)
        .orderBy("updateDate", descending: true)
        .get();
      }
      else{
        collectionVehicles = await FirebaseFirestore.instance
        .collection("usersVehicles")
        .where('userId',isEqualTo: userId)
        .where('typeOfVehicle',isEqualTo: typeOfVehicle)
        .orderBy("updateDate", descending: true)
        .get();
      }
      

      
      if(collectionVehicles.size < limit) {
        limit = collectionVehicles.size;
      }

      if(collectionVehicles.size == 0){
        _suggestionStreamControlerVehicles.add(vehicles);
        return true;
      }

      Query<Map<String, dynamic>>? collection;
      if(userId.isEmpty){
        collection = FirebaseFirestore.instance
        .collection("usersVehicles")
        .where('typeOfVehicle',isEqualTo: typeOfVehicle)
        .limit(limit)
        .orderBy("updateDate", descending: true);
      }
      else{
        collection = FirebaseFirestore.instance
        .collection("usersVehicles")
        .where('userId',isEqualTo: userId)
        .where('typeOfVehicle',isEqualTo: typeOfVehicle)
        .limit(limit)
        .orderBy("updateDate", descending: true);
      }
       

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotVehicles = await collection.get();
    }

    else{
      final lastVisible = collectionState!.docs[collectionState!.docs.length-1];
      Query<Map<String, dynamic>> collection;
      if(userId.isEmpty){
        collection = FirebaseFirestore.instance
        .collection("usersVehicles")
        .where('typeOfVehicle',isEqualTo: typeOfVehicle)
        .limit(limit)
        .orderBy("updateDate", descending: true)
        .startAfterDocument(lastVisible);
      }
      else{
        collection = FirebaseFirestore.instance
        .collection("usersVehicles")
        .where('userId',isEqualTo: userId)
        .where('typeOfVehicle',isEqualTo: typeOfVehicle)
        .limit(limit)
        .orderBy("updateDate", descending: true)
        .startAfterDocument(lastVisible);
      }
      

      final collectionGet = await collection.get();

      if(collectionGet.size == 0) {
        dataFinish = true;
        return dataFinish;
      }

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotVehicles = await collection.get();  


    }

    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsVehicles = querySnapshotVehicles.docs;

    for(final documentsVehicle in documentsVehicles) {
      vehicles.add(documentsVehicle.data());
    }
     
    _suggestionStreamControlerVehicles.add(vehicles);
    return dataFinish;
  }

}