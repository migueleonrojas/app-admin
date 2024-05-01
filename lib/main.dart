import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/firebase_options.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      name: 'globaloiladmin',
      options: DefaultFirebaseOptions.web
    );
  }
  else if(!kIsWeb && io.Platform.isAndroid){
    await Firebase.initializeApp(
      name: 'globaloiladmin',
      options: DefaultFirebaseOptions.android
    );
  }
  
  AutoParts.auth = FirebaseAuth.instance;
  AutoParts.sharedPreferences = await SharedPreferences.getInstance();
  AutoParts.firebaseAppCheck = FirebaseAppCheck.instance;
  /* await AutoParts.firebaseAppCheck!.activate(
     webRecaptchaSiteKey: '92933631-F622-40CC-9DC6-DA96A6491FC2',
     androidProvider: AndroidProvider.playIntegrity
  ); */
  
  AutoParts.firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlobalOil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        primaryColor: Colors.deepOrange,
        /* accentColor: Colors.deepOrangeAccent, */
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black)
        )
      ),
      routes: {
        "/mainscreen": (_) => MainScreen(),
      },
      home: SplashScreen(),
    );
  }
}
