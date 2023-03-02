import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';

      
class ServiceOrderWithVehicleModel {
  Map<String, dynamic>? vehicleModel;
  Map<String, dynamic>? serviceOrderModel;

  
  
  ServiceOrderWithVehicleModel({
    this.vehicleModel,
    this.serviceOrderModel,
  });

  ServiceOrderWithVehicleModel.fromJson(Map<String, dynamic> json) {
    vehicleModel = json['vehicleModel'];
    serviceOrderModel = json['serviceOrderModel'];
    
  }

  ServiceOrderWithVehicleModel.fromSnaphot(DocumentSnapshot snapshot) {
    vehicleModel = (snapshot.data() as dynamic)['vehicleModel'];
    serviceOrderModel = (snapshot.data() as dynamic)['serviceOrderModel'];
  }

  /* serviceOrderWithVehicle.add(ServiceOrderWithVehicle.fromJson({
        "vehicleModel": vehicleModel.first.data(),
        "serviceOrderModel":documentsServiceOrder.data()
      })); */

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleModel'] = this.vehicleModel;
    data['serviceOrderModel'] = this.serviceOrderModel;
    return data;
  }
}


