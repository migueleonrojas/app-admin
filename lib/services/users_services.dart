import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersService{


  final StreamController <List<Map<String,dynamic>>> _suggestionStreamControlerUsers = StreamController.broadcast();
  Stream<List<Map<String,dynamic>>> get suggestionStreamUsers => _suggestionStreamControlerUsers.stream;
  List<Map<String,dynamic>> users = [];
  QuerySnapshot? collectionState;
  bool dataFinish = false;


  Future <bool> getUsers({int limit = 5, bool nextDocument = false}) async {



    QuerySnapshot<Map<String, dynamic>>? querySnapshotUsers;
    QuerySnapshot<Map<String, dynamic>>? collectionUsers;
    if(!nextDocument){

      collectionUsers = await FirebaseFirestore.instance
        .collection("users")
        .orderBy("name", descending: true)
        .get();
      
      if(collectionUsers.size < limit) {
        limit = collectionUsers.size;
      }

      if(collectionUsers.size == 0){
        _suggestionStreamControlerUsers.add(users);
        return true;
      }
      
      final collection = FirebaseFirestore.instance
      .collection("users")
      .limit(limit)
      .orderBy("name", descending: true);

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotUsers = await collection.get();
    }

    else{
      final lastVisible = collectionState!.docs[collectionState!.docs.length-1];
      Query<Map<String, dynamic>> collection;
      
      collection = FirebaseFirestore.instance
        .collection("users")
        .limit(limit)
        .orderBy("name", descending: true)
        .startAfterDocument(lastVisible);

      final collectionGet = await collection.get();

      if(collectionGet.size == 0) {
        dataFinish = true;
        return dataFinish;
      }

      collection.get().then((values)  {
        collectionState = values; 
      });

      querySnapshotUsers = await collection.get();  


    }

    List<QueryDocumentSnapshot<Map<String,dynamic>>> documentsUsers = querySnapshotUsers.docs;

    for(final documentsUser in documentsUsers) {
      users.add(documentsUser.data());
    }
     
    _suggestionStreamControlerUsers.add(users);
    return dataFinish;
  }



}