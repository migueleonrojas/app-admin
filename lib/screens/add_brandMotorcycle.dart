import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/services/brandMotorcycle.dart';

import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';

class AddBrandMotorcycle extends StatefulWidget {
  const AddBrandMotorcycle({super.key});

  @override
  State<AddBrandMotorcycle> createState() => _AddBrandMotorcycleState();
}

class _AddBrandMotorcycleState extends State<AddBrandMotorcycle> {

  XFile? file;
  GlobalKey<FormState> _brandformkey = GlobalKey<FormState>();
  TextEditingController brandController = TextEditingController();
  BrandMotorcycle _brandMotorcycle = BrandMotorcycle();
  String brandsVehicleId = DateTime.now().microsecondsSinceEpoch.toString();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 150,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                takeImage(context);
              },
              child: Container(
                height: 100.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (file != null)
                        ? FileImage(File(file!.path))
                        : const AssetImage(
                            "assets/authenticaiton/take_image.png",
                          ) as ImageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Form(
              key: _brandformkey,
              child: TextFormField(
                controller: brandController,
                decoration: const InputDecoration(
                  hintText: "Agregar Marca de la Moto",
                ),
              ),
            ),

          ],
        )
      ),
      actions: [
        TextButton(
          child: const Text('Agregar'),
          onPressed: () async {
            if (brandController.text.isNotEmpty && file != null) {
              String name = brandController.text.trim().toLowerCase();
              String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
                if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
                else { return '${m[0]}'.toUpperCase();}
              });

              bool isDuplicate = await _brandMotorcycle.validateNoDuplicateRows(newname, newname.toLowerCase());
              if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "La marca que quiere agregar ya existe"
                  );
                });
              }
              else {
                uploadImageAndSaveItemInfo();
                Fluttertoast.showToast(msg: 'Marca del Vehiculo Creada');
                Navigator.pop(context);
              }
              
            } else {
              showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "Por favor indique una Marca o suba una imagen para el logo"
                  );
              });
            }
          },
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  takeImage(mContext) {
      return showDialog(
          context: mContext,
          builder: (con) {
            return SimpleDialog(
              title: const Text(
                "Imagen del logo de la Marca del Vehiculo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                 SimpleDialogOption(
                  onPressed: capturePhotoWithCamera,
                  child: const CustomSimpleDialogOption(
                    icon:  Icons.photo_camera_outlined,
                    title: "Captura con la camara",
                  ),
                ),
                SimpleDialogOption(
                  onPressed: pickPhotoFromGallery,
                  child: const CustomSimpleDialogOption(
                    icon: Icons.photo_outlined,
                    title: "Selecciona desde la Galería",
                  ),
                ),
                SimpleDialogOption(
                  child: const Text(
                    "Cancelar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }

    capturePhotoWithCamera() async {
      Navigator.pop(context);
      final imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 680,
        maxWidth: 970,
      );
      setState(() {
        file = imageFile;
      });
    }

    pickPhotoFromGallery() async {
      Navigator.pop(context);
      final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 680,
        maxWidth: 970,
      );
      setState(() {
        file = imageFile;
      });
    }

    uploadImageAndSaveItemInfo() async {
      String imageDownloadUrl = await uploadItemImage(file);
      
      saveItemInfo(imageDownloadUrl);
    }

    Future<String> uploadItemImage(mFileImage) async {
      final Reference reference = FirebaseStorage.instance.ref().child("brandsVehicle");
      UploadTask uploadTask = reference.child("brandsVehicle_$brandsVehicleId.jpg").putFile(File(mFileImage!.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
  }

  saveItemInfo(downloadUrl) async {
    final lastId = await _brandMotorcycle.getLastIdRow();
    String name = brandController.text.trim().toLowerCase();
    String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
      if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
      else { return '${m[0]}'.toUpperCase();}
    });
    
    _brandMotorcycle.createBrandMotorcycle(lastId, newname, newname.toLowerCase(), downloadUrl);
   
  }
}