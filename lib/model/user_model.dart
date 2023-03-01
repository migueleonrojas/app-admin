import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';

      
class UserModel {
  String? address;
  int? attempts;
  String? email;
  bool? logged;
  String? name;
  String? phone;
  DateTime? timeForTheNextOtp;
  String? tokenFirebaseToken;
  String? uid;
  String? url;
 
  
  UserModel({
    this.address,
    this.attempts,
    this.email,
    this.logged,
    this.name,
    this.phone,
    this.timeForTheNextOtp,
    this.tokenFirebaseToken,
    this.uid,
    this.url,
    
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    attempts = json['attempts'];
    email = json['email'];
    logged = json['logged'];
    name = json['name'];
    phone = json['phone'];
    timeForTheNextOtp = json['timeForTheNextOtp'].toDate();
    tokenFirebaseToken = json['tokenFirebaseToken'];
    uid = json['uid'];
    url = json['url'];
  }
  
  UserModel.fromSnaphot(DocumentSnapshot snapshot) {
    address = (snapshot.data() as dynamic)['address'];
    attempts = (snapshot.data() as dynamic)['attempts'];
    email = (snapshot.data() as dynamic)['email'];
    logged = (snapshot.data() as dynamic)['logged'];
    name = (snapshot.data() as dynamic)['name'];
    phone = (snapshot.data() as dynamic)['phone'];
    timeForTheNextOtp = (snapshot.data() as dynamic)['timeForTheNextOtp'].toDate();
    tokenFirebaseToken = (snapshot.data() as dynamic)['tokenFirebaseToken'];
    uid = (snapshot.data() as dynamic)['uid'];
    url = (snapshot.data() as dynamic)['url'];
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['attempts'] = this.attempts;
    data['email'] = this.email;
    data['logged'] = this.logged;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['timeForTheNextOtp'] = this.timeForTheNextOtp;
    data['tokenFirebaseToken'] = this.tokenFirebaseToken;
    data['uid'] = this.uid;
    data['url'] = this.url;
    
    return data;
  }
}


