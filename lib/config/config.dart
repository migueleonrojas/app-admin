import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoParts
{
   static const String appName = 'AutoParts';

   static SharedPreferences? sharedPreferences;
   static User? user;
   static FirebaseAuth? auth;
   static FirebaseFirestore? firestore ;
   static FirebaseAppCheck? firebaseAppCheck;

   static String collectionAdmin = "admins";
   static String collectionUser = "users";
   static String vehicles = 'vehicles';
   static String brandsVehicle = "brandsVehicle";
   static String modelsVehicle = "modelsVehicle";
   static String yearsVehicle = "yearsVehicle";
   static String collectionOrders = "orders";
   static String serviceOrder = "serviceOrder";
   static String userCartList = 'userCart';
   static String subCollectionAddress = 'userAddress';


   static final String userName = 'name';
   static final String userEmail = 'email';
   static final String userPhone = 'phone';
   static final String userAddress = 'address';
   static final String userPhotoUrl = 'photoUrl';
   static final String userUID = 'uid';
   static final String userAvatarUrl = 'url';
   static final String tokenFirebaseMsg = 'firebasemsg';

   static final String addressID = 'addressID';
   static final String totalAmount = 'totalAmount';
   static final String productID = 'productIDs';
   static final String paymentDetails ='paymentDetails';
   static final String orderTime ='orderTime';
   static final String isSuccess ='isSuccess';

}