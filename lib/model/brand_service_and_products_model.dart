import 'package:cloud_firestore/cloud_firestore.dart';

      
class BrandServiceAndProductsModel {
  
  String? brandName;
  
  
  BrandServiceAndProductsModel({
    this.brandName,
    
  });

  BrandServiceAndProductsModel.fromJson(Map<String, dynamic> json) {
    brandName = json['brandName'];
  }
  BrandServiceAndProductsModel.fromSnaphot(DocumentSnapshot snapshot) {
    brandName = (snapshot.data() as dynamic)['brandName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandName'] = this.brandName;
    return data;
  }
}


