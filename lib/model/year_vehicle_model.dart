import 'package:cloud_firestore/cloud_firestore.dart';

      
class YearVehicleModel {
  String? id;
  int? year;

  
  
  YearVehicleModel({
    this.id,
    this.year,
  });

  YearVehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    year = json['year'];
    
  }
  YearVehicleModel.fromSnaphot(DocumentSnapshot snapshot) {
    id = (snapshot.data() as dynamic)['id'];
    year = (snapshot.data() as dynamic)['year'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['year'] = this.year;
    return data;
  }
}


