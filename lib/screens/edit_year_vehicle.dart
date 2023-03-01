import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';
import 'package:oilappadmin/model/year_vehicle_model.dart';
import 'package:oilappadmin/services/brandVehicle.dart';
import 'package:oilappadmin/services/modelVehicle_service.dart';
import 'package:oilappadmin/services/yearVehicle.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:path_provider/path_provider.dart';
class EditYearVehicle extends StatefulWidget {

  final YearVehicleModel yearVehicleModel;
  const EditYearVehicle({super.key, required this.yearVehicleModel});

  @override
  State<EditYearVehicle> createState() => _EditYearVehicleState();
}

class _EditYearVehicleState extends State<EditYearVehicle> {
  

  XFile? file;
  GlobalKey<FormState> _yearformkey = GlobalKey<FormState>();
  TextEditingController yearController = TextEditingController();
  YearVehicle _yearVehicle = YearVehicle();
  

  @override
  void initState() {
    super.initState();
    yearController.text = widget.yearVehicleModel.year.toString();
    /* getImageFromUrl(); */
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        
        child: Form(
          key: _yearformkey,
          child: TextFormField(
            controller: yearController,
            decoration: const InputDecoration(
              hintText: "Editar Año",
            ),
          ),
        )
      ),
      actions: [
        TextButton(
          child: const Text('Editar'),
          onPressed: () async {
            if (yearController.text.isNotEmpty) {
              bool confirm = await _confirm("De que quiere actualizar el año del vehiculo");
            if(!confirm) return;

              bool isDuplicate = await _yearVehicle.validateNoDuplicateRows(int.parse(yearController.text));
              bool isUsedInVehicles = await _yearVehicle.yearVehicleIsAssigned(widget.yearVehicleModel.year!);

              if(isUsedInVehicles){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede editar el año si ya esta asignada"
                  );
                });
              }
              else if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "Esta modificando el año del vehiculo por uno ya existente"
                  );
                });
              }
              else{
                updateYearVehicle();
                Fluttertoast.showToast(msg: 'Año Editado');
                Navigator.pop(context);
              }

              
              
              
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor indica un año"
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Eliminar'),
          onPressed: () async {
            bool confirm = await _confirm("De que quiere eliminar el año del vehiculo");
            if(!confirm) return;
            bool isUsedInVehicles = await _yearVehicle.yearVehicleIsAssigned(widget.yearVehicleModel.year!);
            if(isUsedInVehicles){
              showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede eliminar el año si ya esta asignada"
                  );
                });
            }
            else{
              deleteYearVehicle();
              Navigator.pop(context);
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
                "Imagen del xxxxxx",
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

  updateYearVehicle() {
    _yearVehicle.updateYearVehicle(widget.yearVehicleModel.id!, int.parse(yearController.text));
  }


  deleteYearVehicle() {
    _yearVehicle.deleteYearVehicle(widget.yearVehicleModel.id!);
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