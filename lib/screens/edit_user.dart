import 'dart:io';

import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/user_model.dart';
import 'package:oilappadmin/screens/allvehicles_by_user.dart';
import 'package:oilappadmin/screens/control_orders_by_user.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/service_order_by_user.dart';
import 'package:oilappadmin/screens/services.dart';
import 'package:oilappadmin/screens/products.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditUser extends StatefulWidget {
  final UserModel? userModel;

  const EditUser({Key? key, this.userModel}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  XFile? file;
  var seletedCategory, seletedBrand, selectedStatusType;
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  @override
  void initState() {
    super.initState();
    nameController.text = widget.userModel!.name!;
    emailController.text = widget.userModel!.email!;
    phoneController.text = widget.userModel!.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Datos del usuario"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: ()  {
              Route route = MaterialPageRoute(builder: (_) => MainScreen());
              Navigator.pushAndRemoveUntil(context, route, (route) => false);
            }, 
            child: const Icon(
              Icons.home,
              size: 30,
              color: Colors.black,
            ), 
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Foto de perfil del usuario',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 230.0,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (file != null)
                      ? FileImage(File(file!.path))
                      : NetworkImage(widget.userModel!.url!) as ImageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    enabled: false,
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Nombre del usuario",
                      labelText: "Nombre del usuario",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    enabled: false,
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Correo del usuario",
                      labelText: "Correo del usuario",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    enabled: false,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: "Teléfono del usuario",
                      labelText: "Teléfono del usuario",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(            
                    onPressed: () {
                     Route route = MaterialPageRoute(builder: (c) => ControlOrdersByUser(userModel: widget.userModel!));
                      if(!mounted)return;
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      "Ordenes de Compra",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(            
                    onPressed: () {
                     Route route = MaterialPageRoute(builder: (c) => ServiceOrdersByUser(userModel: widget.userModel!));
                      if(!mounted)return;
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      "Ordenes de Servicio",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(            
                    onPressed: () {
                     Route route = MaterialPageRoute(builder: (c) => AllVehiclesByUser(userModel: widget.userModel!));
                      if(!mounted)return;
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      "Vehiculos",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  











 

}
