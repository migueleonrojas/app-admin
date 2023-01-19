import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';

      
class UsersVehiclesModel {
  String? brand;
  int? color;
  String? logo;
  int? mileage;
  String? model;
  String? name;
  DateTime? registrationDate;
  DateTime? updateDate;
  String? tuition;
  String? userId;
  String? vehicleId;
  int? year;
  UsersVehiclesModel({
    this.brand,
    this.color,
    this.logo,
    this.mileage,
    this.model,
    this.name,
    this.registrationDate,
    this.updateDate,
    this.tuition,
    this.userId,
    this.vehicleId,
    this.year
  });

  UsersVehiclesModel.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    color = json['color'];
    logo = json['logo'];
    mileage = json['mileage'];
    model = json['model'];
    name = json['name'];
    registrationDate = json['registrationDate'].toDate();
    updateDate = json['updateDate'].toDate();
    tuition = json['tuition'];
    userId =  json['userId'];
    vehicleId = json['vehicleId'];
    year =  json['year'];
  }
  /* ModelVehicleWithBrand.fromSnaphot(DocumentSnapshot snapshot) {
    brandName = (snapshot.data() as dynamic)['id'];
    year = (snapshot.data() as dynamic)['year'];
  } */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.brand;
    data['modelVehicle'] = this.color;
    data['logo'] = this.logo;
    data['mileage'] = this.mileage;
    data['model'] = this.model;
    data['name'] = this.name;
    data['registrationDate'] = this.registrationDate;
    data['updateDate'] = this.updateDate;
    data['tuition'] = this.tuition;
    data['userId'] = this.userId;
    data['vehicleId'] = this.vehicleId;
    data['year'] = this.year;
    return data;
  }
}


