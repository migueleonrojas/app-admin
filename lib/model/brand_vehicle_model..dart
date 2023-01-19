import 'package:cloud_firestore/cloud_firestore.dart';

      
class BrandVehicleModel {
  int? id;
  String? logo;
  String? name;
  String? slug;
  
  BrandVehicleModel({
    this.id,
    this.logo,
    this.name,
    this.slug,
  });

  BrandVehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    name = json['name'];
    slug = json['slug'];
  }
  BrandVehicleModel.fromSnaphot(DocumentSnapshot snapshot) {
    id = (snapshot.data() as dynamic)['id'];
    logo = (snapshot.data() as dynamic)['logo'];
    name = (snapshot.data() as dynamic)['name'];
    slug = (snapshot.data() as dynamic)['slug'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}


