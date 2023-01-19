import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';

      
class ServiceOrderWithVehicle {
  Map<String, dynamic>? vehicleModel;
  Map<String, dynamic>? serviceOrderModel;

  
  
  ServiceOrderWithVehicle({
    this.vehicleModel,
    this.serviceOrderModel,
  });

  ServiceOrderWithVehicle.fromJson(Map<String, dynamic> json) {
    vehicleModel = json['vehicleModel'];
    serviceOrderModel = json['serviceOrderModel'];
    
  }
  /* ModelVehicleWithBrand.fromSnaphot(DocumentSnapshot snapshot) {
    brandName = (snapshot.data() as dynamic)['id'];
    year = (snapshot.data() as dynamic)['year'];
  } */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleModel'] = this.vehicleModel;
    data['serviceOrderModel'] = this.serviceOrderModel;
    return data;
  }
}


