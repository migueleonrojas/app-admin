import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oilappadmin/Helper/login_helper.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/widgets/customTextField.dart';
import 'package:oilappadmin/widgets/progressDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../config/config.dart';
import '../widgets/error_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _adminPasswordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldkey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset(
                "assets/authenticaiton/global-oil.png",
                width: 300,
              ),
              LoginHelper().welcomeText(),
              const SizedBox(height: 10),
              LoginHelper().subtitleText(),
              const SizedBox(height: 20),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextFormField(
                        controller: _emailTextEditingController,
                        decoration: InputDecoration(
                          hintText: "correo@dominio.com",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextFormField(
                        controller: _adminPasswordTextEditingController,
                        decoration: InputDecoration(
                          hintText: "contraseña",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    
                    backgroundColor: Color.fromARGB(255, 3, 3, 247),
                    shape: const StadiumBorder()
                  ),
                  child: const Text(
                    "Ingresar",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  /* color: Theme.of(context).primaryColor, */
                  onPressed: () async {
                    //-------------Internet Connectivity--------------------//

                    var connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi) {
                      showSnackBar("No internet connectivity");
                      return;
                    }
                    //----------------checking textfield--------------------//

                    loginAdmin();
                  },
                ),
              ),
              const SizedBox(height: 20),
              LoginHelper().donthaveaccount(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  loginAdmin() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const ProgressDialog(
        status: "Ingresando, Por favor espere....",
      ),
    );

    User? fUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _adminPasswordTextEditingController.text.trim(),
    )
        .then((authUser) {
      fUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (fUser != null) {
      readEmailSignInUserData(fUser!).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (_) => MainScreen());
        /* Navigator.pushReplacement(context, route); */
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
        /* Navigator.pushAndRemoveUntil(context, route, (route) => false); */
      });
    }

  }
  Future readEmailSignInUserData(User fUser) async {
    FirebaseFirestore.instance
        .collection("admins")
        .doc(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await AutoParts.sharedPreferences!
          .setString("uid", (dataSnapshot.data() as dynamic)[AutoParts.userUID]);
      await AutoParts.sharedPreferences!.setString(
          AutoParts.userEmail, (dataSnapshot.data() as dynamic)[AutoParts.userEmail]);
      await AutoParts.sharedPreferences!.setString(
          AutoParts.userName, (dataSnapshot.data() as dynamic)[AutoParts.userName]);
      await AutoParts.sharedPreferences!.setString(AutoParts.userAvatarUrl,
          (dataSnapshot.data() as dynamic)[AutoParts.userAvatarUrl]);
      
    });
  }
}
