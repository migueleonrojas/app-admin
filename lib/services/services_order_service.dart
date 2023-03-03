import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/Helper/debouncer.dart';
import 'package:oilappadmin/model/service_order_with_vehicles_model.dart';

class ServiceOrdersService {

  final StreamController <List<ServiceOrderWithVehicleModel>> _suggestionStreamControlerServiceOrder = StreamController.broadcast();
  Stream<List<ServiceOrderWithVehicleModel>> get suggestionStreamServiceOrder => _suggestionStreamControlerServiceOrder.stream;
  List<ServiceOrderWithVehicleModel> serviceOrderWithVehicle = [];
  QuerySnapshot? collectionState;
  bool dataFinish = false;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500 ),
  );

  setEmptyServiceOrderWithVehicleList(){
    serviceOrderWithVehicle = [];
  }
  
  Future <dynamic> getServiceOrderWithVehicle({int limit = 5, bool nextDocument = false, String userId = "", bool useLimit = true, String orderId = ''}) async {

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

      if(collectionOrders.size == 0 && useLimit){
        _suggestionStreamControlerServiceOrder.add(serviceOrderWithVehicle);
        return true;
      }
      
      Query<Map<String, dynamic>> collection;
      if(userId.isEmpty){
        if(useLimit){
          collection = FirebaseFirestore.instance
          .collection('serviceOrder')
          .limit(limit)
          .orderBy("orderTime", descending: true);
        }
        else{/* buscando sin usar un limite de resultados */
          
          collection = FirebaseFirestore.instance
          .collection('serviceOrder')
          /* .where(
            'orderId',
            isGreaterThanOrEqualTo: orderId,
            isLessThan: orderId.substring(0, orderId.length - 1) +
            String.fromCharCode(orderId.codeUnitAt(orderId.length - 1) + 1)
          ) */
          .where('orderId',isEqualTo: orderId)
          
          .orderBy("orderTime", descending: true);
          /* .where('orderId',isEqualTo: orderId); */
          /* 1677 5396 0279 8633 */
          
        }
        

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
    QuerySnapshot<Map<String, dynamic>> querySnapshotUsersVehicles = await FirebaseFirestore.instance.collection('usersVehicles').get();
    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsUsersVehicles = querySnapshotUsersVehicles.docs;
    
    for(final documentsServiceOrder in documentsServiceOrders) {
      
      
      List vehicleModel = documentsUsersVehicles.where((usersVehicle) => (documentsServiceOrder.data() as dynamic)['vehicleId'] == usersVehicle["vehicleId"] ).toList();

      if(vehicleModel.isEmpty){
        _suggestionStreamControlerServiceOrder.add(serviceOrderWithVehicle);
        return true;
      }
      
      serviceOrderWithVehicle.add(ServiceOrderWithVehicleModel.fromJson({
        "vehicleModel": vehicleModel.first.data(),
        "serviceOrderModel":documentsServiceOrder.data()
      }));
    }
    
    
   

    if(!useLimit) return serviceOrderWithVehicle;

    _suggestionStreamControlerServiceOrder.add(serviceOrderWithVehicle);
      
    
    return dataFinish;   
  }

  getSuggestionsByQuery(Map<String, dynamic> searchTerm) async {

    debouncer.value = '';

    //metodo que se manda a llamar cuando se pase las 500 milesimas de segundo
    debouncer.onValue = (value) async {

      //print('Tenemos valor a buscar: $value');
      /* final results = await searchMovies(value); */
      
      final  results = await getServiceOrderWithVehicle(useLimit: searchTerm['useLimit'], orderId: searchTerm['orderId']);

      _suggestionStreamControlerServiceOrder.add(results);//indicarle a Stream que hay nuevo valor

      

    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());

  }


}