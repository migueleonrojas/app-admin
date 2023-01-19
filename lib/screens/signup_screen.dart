import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/screens/login_screen.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import '../config/config.dart';
import '../widgets/customTextField.dart';
import '../widgets/error_dialog.dart';
import '../widgets/progressDialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  final _nameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _cpasswordTextEditingController = TextEditingController();
  String userImage = "";
  XFile? avatarImageFile;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future getImage() async {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      
      setState(() {
        avatarImageFile = image;
      });
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Image.asset(
                "assets/authenticaiton/global-oil.png",
                width: 300,
              ),
              SizedBox(height: 5),
              const Text(
                "¡Empecemos!",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Brand-Bold',
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.0),
                child:  Text(
                  "Cree una cuenta en GlobalOil para obtener todas las funciones",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Brand-Regular',
                    letterSpacing: 1,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 130,
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: CircleAvatar(
                    radius: size.width * 0.15,
                    backgroundColor: Colors.deepOrange,
                    backgroundImage: (avatarImageFile != null)
                        ? FileImage(File(avatarImageFile!.path)) 
                        : AssetImage("assets/authenticaiton/user_icon.png") as ImageProvider,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextFormField(
                        controller: _nameTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Nombre Completo",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextFormField(
                        controller: _emailTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Correo",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextFormField(
                        controller: _passwordTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextFormField(
                        controller: _cpasswordTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Confirmar Contraseña",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              SizedBox(height: 15),
              //--------------------Create Button-----------------------//
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    
                    backgroundColor: Color.fromARGB(255, 3, 3, 247),
                    shape: const StadiumBorder()
                  ),

                  child: Text(
                    "crear".toUpperCase(),
                    style: const TextStyle(
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
                    if (_nameTextEditingController.text.length < 4) {
                      showSnackBar("El nombre debe tener al menos 4 caracteres");
                      return;
                    }
                    if (!_emailTextEditingController.text.contains("@")) {
                      showSnackBar("Por favor ingrese su dirección de correo electrónico válida");
                      return;
                    }

                    if (_passwordTextEditingController.text.length < 8) {
                      showSnackBar("La contraseña debe tener al menos 8 caracteres");
                      return;
                    }
                    if (_passwordTextEditingController.text !=
                        _cpasswordTextEditingController.text) {
                      showSnackBar("La Confirmación de la contraseña no coincide");
                      return;
                    }
                    uploadAndSaveImage();
                  },
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  height: 2.0,
                  width: size.width / 2 - 30,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Ya tienes una cuenta?',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (c) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      ' Entre aquí',
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

//--------------custom snackbar----------------------//
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

  Future<void> uploadAndSaveImage() async {
    if (avatarImageFile == null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
          status: "Registrandose, Por favor espere....",
        ),
      );
      createUser();
    } else {
      uploadToStorage();
    }
    
  }

  uploadToStorage() async {
    //------show please wait dialog----------//
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const ProgressDialog(
        status: "Registrandose, Por favor espere....",
      ),
    );
    
    String imgeFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(imgeFileName);
    UploadTask uploadTask = reference.putFile(File(avatarImageFile!.path));
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((urlImage) => userImage = urlImage);
      createUser();
    });
  }

//----------------------create user-----------------------//
  Future createUser() async {
    User? firebaseUser;
    await _auth.createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),      
    )
    .then((auth) => firebaseUser = auth.user)
    .catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: error.message.toString(),
          );
        });
    });

    if (firebaseUser != null) {

      saveUserInfoToFireStore(firebaseUser!).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (_) => MainScreen());
        /* Navigator.pushReplacement(context, route); */
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      });
    }
  }

//--------------------save user information to firestore-----------------//
  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("admins").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "phone": '584125853626',
      "address": "Venezuela",
      "url": (userImage.isNotEmpty)? userImage : "https://firebasestorage.googleapis.com/v0/b/oildatabase-781a4.appspot.com/o/no-image-user.png?alt=media&token=012134ea-3488-4061-ab18-a9f4196b202c",
    });
    await AutoParts.sharedPreferences!.setString("uid", fUser.uid);
    await AutoParts.sharedPreferences!.setString(AutoParts.userEmail, fUser.email!);
    await AutoParts.sharedPreferences!.setString(AutoParts.userName, _nameTextEditingController.text);
    await AutoParts.sharedPreferences!.setString(AutoParts.userPhone, '584125853626');
    await AutoParts.sharedPreferences!.setString(AutoParts.userAddress, 'migueleonrojas@gmail.com');
    await AutoParts.sharedPreferences!.setString(AutoParts.userAvatarUrl, userImage);
    
  }
}
