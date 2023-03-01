import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';
import 'package:oilappadmin/services/brandVehicle.dart';
import 'package:oilappadmin/services/modelVehicle_service.dart';


import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:path_provider/path_provider.dart';
class EditModelVehicle extends StatefulWidget {

  final ModelVehicleModel modelVehicleModel;
  final String brandVehicle ;
  const EditModelVehicle({super.key, required this.modelVehicleModel, required this.brandVehicle});

  @override
  State<EditModelVehicle> createState() => _EditModelVehicleState();
}

class _EditModelVehicleState extends State<EditModelVehicle> {
  

  XFile? file;
  GlobalKey<FormState> _modelformkey = GlobalKey<FormState>();
  TextEditingController modelController = TextEditingController();
  BrandVehicleService _brandVehicle = BrandVehicleService();
  ModelVehicleService _modelVehicle = ModelVehicleService();
  

  @override
  void initState() {
    super.initState();
    modelController.text = widget.modelVehicleModel.name!;
    /* getImageFromUrl(); */
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(widget.brandVehicle)),
      content: Container(
        
        child: Form(
          key: _modelformkey,
          child: TextFormField(
            controller: modelController,
            decoration: const InputDecoration(
              hintText: "Editar Modelo de Vehiculo",
            ),
          ),
        )
      ),
      actions: [
        TextButton(
          child: const Text('Editar'),
          onPressed: () async {
            if (modelController.text.isNotEmpty) {
              String name = modelController.text.trim().toLowerCase();
              String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
                if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
                else { return '${m[0]}'.toUpperCase();}
              });
              bool confirm = await _confirm('De que quiere actualizar el modelo del vehiculo');

              if(!confirm) return;

              bool isDuplicate = await _modelVehicle.validateNoDuplicateRows(newname, newname.toLowerCase(), widget.modelVehicleModel.id_brand!);
              bool isUsedInVehicles = await _modelVehicle.modelNameVehicleIsAssigned(widget.modelVehicleModel.name!, widget.modelVehicleModel.id_brand!, widget.brandVehicle);
              

              if(isUsedInVehicles){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede editar el nombre del modelo que ya esta asignada"
                  );
                });
              }
              else if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "Esta modificando el nombre del modelo por una ya existente"
                  );
                });
              }
              else {
                
                updateModelVehicle();
                Fluttertoast.showToast(msg: 'Modelo de Vehiculo Editado');
                Navigator.of(context).pop(true);
              }
              
              
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor escribe un Modelo"
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Borrar'),
          onPressed: () async {
            bool confirm = await _confirm('De que quiere eliminar el modelo del vehiculo');

            if(!confirm) return;

            bool isUsedInVehicles = await _modelVehicle.modelNameVehicleIsAssigned(widget.modelVehicleModel.name!, widget.modelVehicleModel.id_brand!, widget.brandVehicle);

            if(isUsedInVehicles){
              showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede eliminar el nombre del modelo que ya esta asignada"
                  );
                });
            }
            else{
              
              deleteModelVehicle();
              Navigator.of(context).pop(true);
            }

            
          },
        ),

        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).pop(false);
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
                "Imagen del Modelo",
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
                    title: "Capturar con la camara",
                  ),
                ),
                SimpleDialogOption(
                  onPressed: pickPhotoFromGallery,
                  child: const CustomSimpleDialogOption(
                    icon: Icons.photo_outlined,
                    title: "Seleccionar desde la Galería",
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

    /* uploadImageAndSaveItemInfo() async {
      String imageDownloadUrl = await uploadItemImage(file);
      
      saveItemInfo(imageDownloadUrl);
    } */

    /* deleteImageAndDeleteItemInfo() async {
      await deleteItemImage();
      await deleteItemInfo();

    } */

    /* Future<String> uploadItemImage(mFileImage) async {
      final Reference reference = FirebaseStorage.instance.ref().child("brandsVehicle");
      UploadTask uploadTask = reference.child("brandsVehicle_${widget.brandVehicleModel.id}.jpg").putFile(File(mFileImage!.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } */

    /* Future deleteItemImage() async {
      
      FirebaseStorage.instance.refFromURL(widget.brandVehicleModel.logo!).delete();
      
      
    } */

  /* saveItemInfo(downloadUrl) async {
    final lastId = await _brandVehicle.getLastIdRow();
    String name = modelController.text.trim().toLowerCase();
    String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
      if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
      else { return '${m[0]}'.toUpperCase();}
    });
    _brandVehicle.updateBrandVehicle(widget.brandVehicleModel.id.toString(), newname, newname.toLowerCase(), downloadUrl);
  } */

  /* deleteItemInfo() async {
    _brandVehicle.deleteBrandVehicle(widget.brandVehicleModel.id.toString());
    _modelVehicle.deleteAllModelsForIdBrand(widget.brandVehicleModel.id!);
  } */

  updateModelVehicle() {
    String name = modelController.text.trim().toLowerCase();
    String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
      if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
      else { return '${m[0]}'.toUpperCase();}
    });

    _modelVehicle.updateModelVehicle(widget.modelVehicleModel.id!, newname, newname.toLowerCase());
  }

  deleteModelVehicle() {
    _modelVehicle.deleteModelVehicle(widget.modelVehicleModel.id!);
  }
  Future<bool> _confirm(String msg) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Estas seguro?'),
            content: Text(msg),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ) ??
        false;
    }
}