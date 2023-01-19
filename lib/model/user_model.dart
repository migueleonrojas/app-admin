import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';

      
class UserModel {
  String? uid;
  String? modelVehicle;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? url;
  
  UserModel({
    this.uid,
    this.modelVehicle,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.url
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    modelVehicle = json['modelVehicle'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    url = json['url'];
  }
  /* ModelVehicleWithBrand.fromSnaphot(DocumentSnapshot snapshot) {
    brandName = (snapshot.data() as dynamic)['id'];
    year = (snapshot.data() as dynamic)['year'];
  } */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['modelVehicle'] = this.modelVehicle;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['url'] = this.url;
    return data;
  }
}


