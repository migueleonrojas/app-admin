import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ControlsOrdersService {

  final StreamController <List<Map<String,dynamic>>> _suggestionStreamControlerControlsOrders = StreamController.broadcast();
  Stream<List<Map<String,dynamic>>> get suggestionStreamControlOrders => _suggestionStreamControlerControlsOrders.stream;
  List<Map<String,dynamic>> controlsOrders = [];
  QuerySnapshot? collectionState;
  bool dataFinish = false;


  Future <bool> getControlsOrders({int limit = 5, bool nextDocument = false}) async {

    QuerySnapshot<Map<String, dynamic>>? querySnapshotControlsOrders;

    if(!nextDocument){

      final collectionControlsOrders = await FirebaseFirestore.instance
      .collection("orders")
      .orderBy("orderTime", descending: true)
      .get();

      
      if(collectionControlsOrders.size < limit) {
        limit = collectionControlsOrders.size;
      }
      
      final collection = FirebaseFirestore.instance
      .collection("orders")
      .limit(limit)
      .orderBy("orderTime", descending: true);

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotControlsOrders = await collection.get();
    }

    else{
      final lastVisible = collectionState!.docs[collectionState!.docs.length-1];

      final collection = FirebaseFirestore.instance
      .collection("orders")
      .limit(limit)
      .orderBy("orderTime", descending: true)
      .startAfterDocument(lastVisible);

      final collectionGet = await collection.get();

      if(collectionGet.size == 0) {
        dataFinish = true;
        return dataFinish;
      }

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotControlsOrders = await collection.get();  


    }

    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsControlsOrders = querySnapshotControlsOrders.docs;

    for(final documentsControlsOrder in documentsControlsOrders) {
      controlsOrders.add(documentsControlsOrder.data());
    }
     
    _suggestionStreamControlerControlsOrders.add(controlsOrders);
    return dataFinish;
  }

}