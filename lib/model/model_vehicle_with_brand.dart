import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';

      
class ModelVehicleWithBrand {
  String? brandName;
  Map<String, dynamic>? modelVehicle;

  
  
  ModelVehicleWithBrand({
    this.brandName,
    this.modelVehicle,
  });

  ModelVehicleWithBrand.fromJson(Map<String, dynamic> json) {
    brandName = json['brandName'];
    modelVehicle = json['modelVehicle'];
    
  }
  /* ModelVehicleWithBrand.fromSnaphot(DocumentSnapshot snapshot) {
    brandName = (snapshot.data() as dynamic)['id'];
    year = (snapshot.data() as dynamic)['year'];
  } */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandName'] = this.brandName;
    data['modelVehicle'] = this.modelVehicle;
    return data;
  }
}


