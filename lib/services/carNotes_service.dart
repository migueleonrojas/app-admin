import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarNoteService{

  final StreamController <List<Map<String,dynamic>>> _suggestionStreamControlerCarNotes = StreamController.broadcast();
  Stream<List<Map<String,dynamic>>> get suggestionStreamCarNotes => _suggestionStreamControlerCarNotes.stream;
  List<Map<String,dynamic>> carNotes = [];
  QuerySnapshot? collectionState;
  bool dataFinish = false;


  Future <bool> getCarNotes({int limit = 5, bool nextDocument = false, String vehicleId = ""}) async {



    QuerySnapshot<Map<String, dynamic>>? querySnapshotCarNotes;
    QuerySnapshot<Map<String, dynamic>>? collectionCarNotes;
    if(!nextDocument){

      if(vehicleId.isEmpty){
        collectionCarNotes = await FirebaseFirestore.instance
        .collection("carNotesUserVehicles")
        .where('vehicleId',isEqualTo: vehicleId)
        .orderBy("date", descending: true)
        .get();
      }
      else{
        collectionCarNotes = await FirebaseFirestore.instance
        .collection("carNotesUserVehicles")
        .where('vehicleId',isEqualTo: vehicleId)
        .orderBy("date", descending: true)
        .get();
      }
      

      
      if(collectionCarNotes.size < limit) {
        limit = collectionCarNotes.size;
      }

      if(collectionCarNotes.size == 0){
        _suggestionStreamControlerCarNotes.add(carNotes);
        return true;
      }
      
      final collection = FirebaseFirestore.instance
      .collection("carNotesUserVehicles")
      .where('vehicleId',isEqualTo: vehicleId)
      .limit(limit)
      .orderBy("date", descending: true);

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotCarNotes = await collection.get();
    }

    else{
      final lastVisible = collectionState!.docs[collectionState!.docs.length-1];
      Query<Map<String, dynamic>> collection;
      if(vehicleId.isEmpty){
        collection = FirebaseFirestore.instance
        .collection("carNotesUserVehicles")
        .where('vehicleId',isEqualTo: vehicleId)
        .limit(limit)
        .orderBy("date", descending: true)
        .startAfterDocument(lastVisible);
      }
      else{
        collection = FirebaseFirestore.instance
        .collection("carNotesUserVehicles")
        .where('vehicleId',isEqualTo: vehicleId)
        .limit(limit)
        .orderBy("date", descending: true)
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

      querySnapshotCarNotes = await collection.get();  


    }

    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsCarNotes = querySnapshotCarNotes.docs;

    for(final documentsCarNote in documentsCarNotes) {
      carNotes.add(documentsCarNote.data());
    }
     
    _suggestionStreamControlerCarNotes.add(carNotes);
    return dataFinish;
  }

}