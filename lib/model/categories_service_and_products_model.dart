import 'package:cloud_firestore/cloud_firestore.dart';

      
class CategoryServiceAndProductsModel {
  
  String? categoryName;
  
  
  CategoryServiceAndProductsModel({
    this.categoryName,
    
  });

  CategoryServiceAndProductsModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
  }
  CategoryServiceAndProductsModel.fromSnaphot(DocumentSnapshot snapshot) {
    categoryName = (snapshot.data() as dynamic)['categoryName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    return data;
  }
}


