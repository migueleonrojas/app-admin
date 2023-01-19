import 'package:cloud_firestore/cloud_firestore.dart';

      
class ModelVehicleModel {
  int? id;
  int? id_brand;
  String? logo;
  String? name;
  String? slug;
  
  ModelVehicleModel({
    this.id,
    this.id_brand,
    this.logo,
    this.name,
    this.slug,
  });

  ModelVehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_brand = json['id_brand'];
    logo = json['logo'];
    name = json['name'];
    slug = json['slug'];
  }
  ModelVehicleModel.fromSnaphot(DocumentSnapshot snapshot) {
    id = (snapshot.data() as dynamic)['id'];
    id_brand = (snapshot.data() as dynamic)['id_brand'];
    logo = (snapshot.data() as dynamic)['logo'];
    name = (snapshot.data() as dynamic)['name'];
    slug = (snapshot.data() as dynamic)['slug'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_brand'] = this.id_brand;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}


