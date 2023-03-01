import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';

      
class ServiceOrderModel {
  String? addressID;
  String? beingPrePared;
  DateTime? beingPreParedTime;
  String? date;
  String? deliverd;
  DateTime? deliverdTime;
  bool? isSuccess;
  int? newPrice;
  String? onTheWay;
  DateTime? onTheWayTime;
  String? orderBy;
  String? orderCancelled;
  String? orderHistoyId;
  String? orderId;
  String? orderRecived;
  DateTime? orderRecivedTime;
  DateTime? orderTime;
  int? orginalPrice;
  String? paymentDetails;
  int? quantity;
  String? serviceId;
  String? serviceImage;
  String? serviceName;
  int? totalPrice;
  String? idOrderPaymentDetails;
  ServiceOrderModel({
    this.addressID,
    this.beingPrePared,
    this.beingPreParedTime,
    this.date,
    this.deliverd,
    this.deliverdTime,
    this.isSuccess,
    this.newPrice,
    this.onTheWay,
    this.onTheWayTime,
    this.orderBy,
    this.orderCancelled,
    this.orderHistoyId,
    this.orderId,
    this.orderRecived,
    this.orderRecivedTime,
    this.orderTime,
    this.orginalPrice,
    this.paymentDetails,
    this.quantity,
    this.serviceId,
    this.serviceImage,
    this.serviceName,
    this.totalPrice,
    this.idOrderPaymentDetails
  });

  ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    addressID = json['addressID'];
    beingPrePared = json['beingPrePared'];
    beingPreParedTime = json['beingPreParedTime'].toDate();
    date = json['date'];
    deliverd = json['deliverd'];
    deliverdTime = json['deliverdTime'].toDate();
    isSuccess = json['isSuccess'];
    newPrice = json['newPrice'];
    onTheWay =  json['onTheWay'];
    onTheWayTime = json['onTheWayTime'].toDate();
    orderBy =  json['orderBy'];
    orderCancelled = json['orderCancelled'];
    orderHistoyId = json['orderHistoyId'];
    orderId = json['orderId'];
    orderRecived = json['orderRecived'];
    orderRecivedTime = json['orderRecivedTime'].toDate();
    orderTime = json['orderTime'].toDate();
    orginalPrice = json['orginalPrice'];
    paymentDetails = json['paymentDetails'];
    quantity = json['quantity'];
    serviceId = json['serviceId'];
    serviceImage = json['serviceImage'];
    serviceName = json['serviceName'];
    totalPrice = json['totalPrice'];
    idOrderPaymentDetails = json['idOrderPaymentDetails'];
  }
  /* ModelVehicleWithBrand.fromSnaphot(DocumentSnapshot snapshot) {
    brandName = (snapshot.data() as dynamic)['id'];
    year = (snapshot.data() as dynamic)['year'];
  } */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressID'] = this.addressID;
    data['beingPrePared'] = this.beingPrePared;
    data['beingPreParedTime'] = this.beingPreParedTime;
    data['date'] = this.date;
    data['deliverd'] = this.deliverd;
    data['deliverdTime'] = this.deliverdTime;
    data['isSuccess'] = this.isSuccess;
    data['newPrice'] = this.newPrice;
    data['onTheWay'] = this.onTheWay;
    data['onTheWayTime'] = this.onTheWayTime;
    data['orderBy'] = this.orderBy;
    data['orderCancelled'] =  this.orderCancelled;
    data['orderHistoyId'] = this.orderHistoyId;
    data['orderId'] = this.orderId;
    data['orderRecived'] = this.orderRecived;
    data['orderRecivedTime'] = this.orderRecivedTime;
    data['orderTime'] = this.orderTime;
    data['orginalPrice'] = this.orginalPrice;
    data['paymentDetails'] = this.paymentDetails;
    data['quantity'] = this.quantity;
    data['serviceId'] = this.serviceId;
    data['serviceImage'] = this.serviceImage;
    data['serviceName'] = this.serviceName;
    data['totalPrice'] = this.totalPrice;
    data['idOrderPaymentDetails'] = this.idOrderPaymentDetails;
    return data;
  }
}


