import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/service_order_with_vehicles_model.dart';

class ServiceOrdersService {

  final StreamController <List<ServiceOrderWithVehicle>> _suggestionStreamControlerServiceOrder = StreamController.broadcast();
  Stream<List<ServiceOrderWithVehicle>> get suggestionStreamServiceOrder => _suggestionStreamControlerServiceOrder.stream;
  List<ServiceOrderWithVehicle> serviceOrderWithVehicle = [];
  QuerySnapshot? collectionState;
  bool dataFinish = false;

  
  Future <bool>  getServiceOrderWithVehicle({int limit = 5, bool nextDocument = false, String userId = ""}) async {

    QuerySnapshot<Map<String, dynamic>>? querySnapshotServiceOrder;
    QuerySnapshot<Map<String, dynamic>>? collectionOrders;
    if(!nextDocument){
      if(userId.isEmpty){
        collectionOrders = await FirebaseFirestore.instance
        .collection('serviceOrder')
        .get();
      }
      else{
        collectionOrders = await FirebaseFirestore.instance
        .collection('serviceOrder')
        .where('orderBy', isEqualTo: userId)
        .get();
      }

      

      
      if(collectionOrders.size < limit) {
        limit = collectionOrders.size;
      }

      if(collectionOrders.size == 0){
        _suggestionStreamControlerServiceOrder.add(serviceOrderWithVehicle);
        return true;
      }
      
      Query<Map<String, dynamic>> collection;
      if(userId.isEmpty){
        collection = FirebaseFirestore.instance
        .collection('serviceOrder')
        
        .limit(limit)
        .orderBy("orderTime", descending: true);
      }
      else{
        collection = FirebaseFirestore.instance
        .collection('serviceOrder')
        .where('orderBy', isEqualTo: userId)
        .limit(limit)
        .orderBy("orderTime", descending: true);
      }

      

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotServiceOrder = await collection.get();
    }

    else{
      final lastVisible = collectionState!.docs[collectionState!.docs.length-1];
      Query<Map<String, dynamic>> collection;
      if(userId.isEmpty){
        collection = FirebaseFirestore.instance
        .collection('serviceOrder')
        .limit(limit)
        .orderBy("orderTime", descending: true)
        .startAfterDocument(lastVisible);
      }
      else{
        collection = FirebaseFirestore.instance
        .collection('serviceOrder')
        .where('orderBy', isEqualTo: userId)
        .limit(limit)
        .orderBy("orderTime", descending: true)
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

      querySnapshotServiceOrder = await collection.get();  


    }

    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsServiceOrders = querySnapshotServiceOrder.docs;

    for(final documentsServiceOrder in documentsServiceOrders) {
     
      QuerySnapshot<Map<String, dynamic>> querySnapshotVehicle = await FirebaseFirestore.instance.collection('usersVehicles').where('vehicleId', isEqualTo: (documentsServiceOrder.data() as dynamic)['vehicleId']).get();
      List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsVehicles = querySnapshotVehicle.docs;
      for(final documentsVehicle in  documentsVehicles) {

        
        serviceOrderWithVehicle.add(ServiceOrderWithVehicle.fromJson({
          "vehicleModel": documentsVehicle.data(),
          "serviceOrderModel":documentsServiceOrder.data()
        }));

      }
    }
    _suggestionStreamControlerServiceOrder.add(serviceOrderWithVehicle);
    return dataFinish;
  }

}