import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/services/brandVehicle.dart';
import 'package:oilappadmin/services/modelVehicle.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:path_provider/path_provider.dart';
class EditBrandVehicle extends StatefulWidget {

  final BrandVehicleModel brandVehicleModel;
  const EditBrandVehicle({super.key, required this.brandVehicleModel});

  @override
  State<EditBrandVehicle> createState() => _EditBrandVehicleState();
}

class _EditBrandVehicleState extends State<EditBrandVehicle> {
  getImageFromUrl() async{

    String url = widget.brandVehicleModel.logo!;
    String baseUrl = '';
    String endPoint = '';
    url.replaceAllMapped(RegExp(r'[\/]{2,2}[a-z]+.[a-z]+.[a-z]+'), (Match m) {
      baseUrl = '${m[0]}'.replaceAll('/', "");
      return '';
    });
    url.replaceAllMapped(RegExp(r'[\/]+[v0].+'), (Match m) {
      endPoint = '${m[0]}'.substring(1);
      return '';
    });

    final urlToUri = Uri.https(baseUrl, endPoint);

    final http.Response responseData = await http.get(urlToUri);
    Uint8List uint8list = responseData.bodyBytes;
    final buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File fileFromFirebase = await File('${tempDir.path}/img.jpg').writeAsBytes(
    buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    
    file = XFile(fileFromFirebase.path);
    final imagen = FileImage(File(file!.path));
    print(imagen);
  
    setState(() {
      
    });
    
  }

  XFile? file;
  GlobalKey<FormState> _brandformkey = GlobalKey<FormState>();
  TextEditingController brandController = TextEditingController();
  BrandVehicle _brandVehicle = BrandVehicle();
  ModelVehicle _modelVehicle = ModelVehicle();
  String? pathFile;

  @override
  void initState() {
    super.initState();
    brandController.text = widget.brandVehicleModel.name!;
    pathFile =  widget.brandVehicleModel.logo!;
    setState(() {
      
    });
  }

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
                      : NetworkImage(pathFile!) as ImageProvider,
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
                  hintText: "Editar Marca de Vehiculo",
                ),
              ),
            ),

          ],
        )
      ),
      actions: [
        TextButton(
          child: const Text('Editar'),
          onPressed: () async {

            if (brandController.text.isNotEmpty && pathFile != null) {

              bool confirm = await _confirm('De que quiere actualizar la marca del vehiculo');

              if(!confirm) return;


              String name = brandController.text.trim().toLowerCase();
              String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
                if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
                else { return '${m[0]}'.toUpperCase();}
              });

              

              bool isUsedInVehicles = await _brandVehicle.brandNameVehicleIsAssigned(widget.brandVehicleModel.name!);
              bool isDuplicate = await _brandVehicle.validateNoDuplicateRows(newname, newname.toLowerCase());
              if(isUsedInVehicles){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede editar el nombre de la marca que ya esta asignada"
                  );
                });
              }
              else if(brandController.text == widget.brandVehicleModel.name!){
                uploadOnlyLogoBrand();
                Fluttertoast.showToast(msg: 'Solo se edito el logo de la marca');
                Navigator.pop(context);
              }
              else if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "Esta modificando el nombre de la marca por una ya existente"
                  );
                });
              }
              
              else {
                uploadImageAndSaveItemInfo();
                Fluttertoast.showToast(msg: 'Marca Editada');
                Navigator.pop(context);
              }              
            } 
            else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor escriba una Marca o Logo para actualizar"
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Eliminar'),
          onPressed: () async {
            bool confirm = await _confirm('De que quiere eliminar la marca del vehiculo');

            if(!confirm) return;

            bool isUsedInVehicles = await _brandVehicle.brandNameVehicleIsAssigned(widget.brandVehicleModel.name!);

            if(isUsedInVehicles){
              showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede eliminar el nombre de la marca que ya esta asignada"
                  );
                });
            }
            else{
              deleteImageAndDeleteItemInfo();
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
                "Imagen del Logo",
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
                    title: "Capturar con una Camera",
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

    uploadOnlyLogoBrand() async {
      if(file != null) {
        String imageDownloadUrl = await uploadItemImage(file);
        _brandVehicle.updateBrandVehicle(widget.brandVehicleModel.id.toString(), widget.brandVehicleModel.name!, widget.brandVehicleModel.slug!, imageDownloadUrl);
      }
      else {
        String name = brandController.text.trim().toLowerCase();
        String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
          if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
          else { return '${m[0]}'.toUpperCase();}
        });

        _brandVehicle.updateBrandVehicle(widget.brandVehicleModel.id.toString(), newname, newname.toLowerCase(), pathFile!);
      }
    }

    uploadImageAndSaveItemInfo() async {
      if(file != null) {
        String imageDownloadUrl = await uploadItemImage(file);
      
        saveItemInfo(imageDownloadUrl);
      }

      else{

      String name = brandController.text.trim().toLowerCase();
      String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
        if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
        else { return '${m[0]}'.toUpperCase();}
      });

        _brandVehicle.updateBrandVehicle(widget.brandVehicleModel.id.toString(), newname, newname.toLowerCase(), pathFile!);
      }
    }

    deleteImageAndDeleteItemInfo() async {
      await deleteItemImage();
      await deleteItemInfo();

    }

    Future<String> uploadItemImage(mFileImage) async {
      final Reference reference = FirebaseStorage.instance.ref().child("brandsVehicle");
      deleteItemImage();
      UploadTask uploadTask = reference.child("brandsVehicle_${widget.brandVehicleModel.id}.jpg").putFile(File(mFileImage!.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }

    Future deleteItemImage() async {
      
      FirebaseStorage.instance.refFromURL(widget.brandVehicleModel.logo!).delete();
      
      
    }

  saveItemInfo(downloadUrl) async {
    final lastId = await _brandVehicle.getLastIdRow();
    String name = brandController.text.trim().toLowerCase();
    String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
      if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
      else { return '${m[0]}'.toUpperCase();}
    });
    _brandVehicle.updateBrandVehicle(widget.brandVehicleModel.id.toString(), newname, newname.toLowerCase(), downloadUrl);
  }

  deleteItemInfo() async {
    _brandVehicle.deleteBrandVehicle(widget.brandVehicleModel.id.toString());
    _modelVehicle.deleteAllModelsForIdBrand(widget.brandVehicleModel.id!);
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