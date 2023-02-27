import 'dart:io';

import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/services.dart';
import 'package:oilappadmin/screens/products.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditService extends StatefulWidget {
  final ServiceModel? serviceModel;

  const EditService({Key? key, this.serviceModel}) : super(key: key);

  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  XFile? file;
  var seletedCategory, seletedBrand, selectedStatusType;
  TextEditingController expectationController = TextEditingController();
  TextEditingController orginalPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController offerPercentController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController aboutInfoController = TextEditingController();
  List<String> status = <String>['Disponible', 'No Disponible'];
  String productId = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  void initState() {
    aboutInfoController.text = widget.serviceModel!.aboutInfo!;
    serviceNameController.text = widget.serviceModel!.serviceName!;
    expectationController.text = widget.serviceModel!.expectation!;
    orginalPriceController.text = widget.serviceModel!.orginalprice.toString();
    newPriceController.text = widget.serviceModel!.newprice.toString();
    offerPercentController.text = widget.serviceModel!.offervalue.toString();
    selectedStatusType = widget.serviceModel!.status;
    seletedBrand = widget.serviceModel!.brandName;
    seletedCategory = widget.serviceModel!.categoryName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Servicio"),
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
            GestureDetector(
              onTap: () {
                takeImage(context);
              },
              child: Container(
                height: 230.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (file != null)
                        ? FileImage(File(file!.path))
                        : NetworkImage(widget.serviceModel!.serviceImgUrl!) as ImageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: aboutInfoController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: "Escribir acerca del Servicio...",
                      labelText: "Acerca del Servicio",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: serviceNameController,
                    decoration: const InputDecoration(
                      hintText: "Indicar el Nombre del Servicio",
                      labelText: "Nombre del Servicio",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("categories")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            Text('Loading');
                          }
                          if (snapshot.data == null)
                            return CircularProgressIndicator();

                          List<DropdownMenuItem> categoriesItem = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            categoriesItem.add(
                              DropdownMenuItem(
                                child: Text(
                                  "${(snap.data() as dynamic)['categoryName']}",
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: "${(snap.data() as dynamic)['categoryName']}",
                              ),
                            );
                          }
                          return Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: DropdownButton(
                              items: categoriesItem,
                              onChanged: (categoryValue) {
                                setState(() {
                                  seletedCategory = categoryValue;
                                });
                              },
                              value: seletedCategory,
                              isExpanded: true,
                              hint: const Text(
                                'Seleccionar Categoría',
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("brands")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            const Text('Cargando');
                          }
                          if (snapshot.data == null)
                            return CircularProgressIndicator();

                          List<DropdownMenuItem> brandsItem = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            brandsItem.add(
                              DropdownMenuItem(
                                child: Text(
                                  "${(snap.data() as dynamic)['brandName']}",
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: "${(snap.data() as dynamic)['brandName']}",
                              ),
                            );
                          }
                          return Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: DropdownButton(
                              items: brandsItem,
                              onChanged: (brandValue) {
                                setState(() {
                                  seletedBrand = brandValue;
                                });
                              },
                              value: seletedBrand,
                              isExpanded: true,
                              hint: const Text(
                                'Seleccionar Marca',
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    maxLines: 3,
                    controller: expectationController,
                    decoration: const InputDecoration(
                      hintText: "Escribe lo que se espera del Servicio",
                      labelText: "Expectativa",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: TextFormField(
                          controller: orginalPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Ingrese Precio Original",
                            labelText: "Precio Original",
                            labelStyle:
                                TextStyle(color: Colors.deepOrangeAccent),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: TextFormField(
                          controller: offerPercentController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Ingrese % de descuento",
                            labelText: "% de descuento",
                            labelStyle:
                                TextStyle(color: Colors.deepOrangeAccent),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: ElevatedButton(
                          child: const Text('='),
                          onPressed: () {
                            offerpercentageCalculation();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: newPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Mostrar Nuevo Precio",
                      labelText: "Precio Nuevo",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton(
                      items: status
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (selectedStatus) {
                        setState(() {
                          selectedStatusType = selectedStatus;
                        });
                      },
                      value: selectedStatusType,
                      isExpanded: true,
                      hint: const Text(
                        'Seleccionar Estatus',
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Actualizar Servicio'),
                    onPressed: () async {
                      if (aboutInfoController.text.isNotEmpty &&
                          serviceNameController.text.isNotEmpty &&
                          expectationController.text.isNotEmpty &&
                          orginalPriceController.text.isNotEmpty &&
                          newPriceController.text.isNotEmpty &&
                          offerPercentController.text.isNotEmpty &&
                          seletedCategory != null &&
                          seletedBrand != null &&
                          selectedStatusType != null) {
                        bool confirm = await _confirm('De que quiere actualizar el servicio');
                        if(confirm) {
                          uploadImageAndSaveItemInfo();
                        Fluttertoast.showToast(
                            msg: 'Service Actualizado Exitosamente');
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => Services()));
                        }
                        
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const ErrorAlertDialog(
                                message: "Por favor ingrese toda la información solicitada.",
                              );
                            });
                      }
                    },
                  ),
                  ElevatedButton(
                    /* color: Colors.redAccent, */
                    child: const Text(
                      'Eliminar Servicio',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      bool confirm = await _confirm('De que quiere eliminar el servicio');
                      if(confirm) {
                        deleteItem();
                        Fluttertoast.showToast(
                          msg: 'Servicio Eliminado Exitosamente');
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => Services()));
                      }
                      
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  offerpercentageCalculation() {
    int orginalpricevalue = int.parse(orginalPriceController.text);
    int offervalue = int.parse(offerPercentController.text);
    double offerpercent = offervalue / 100;
    double mofferwithorginal = orginalpricevalue * offerpercent;
    double newpricevalue = orginalpricevalue - mofferwithorginal;
    setState(() {
      newPriceController.text = newpricevalue.toStringAsFixed(0);
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Product Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: CustomSimpleDialogOption(
                  icon: Icons.photo_camera_outlined,
                  title: "Captura desde la camara",
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: CustomSimpleDialogOption(
                  icon: Icons.photo_outlined,
                  title: "Seleccionar desde la galeria",
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
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

  void pickPhotoFromGallery() async {
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
    if (file != null) {
      String imageDownloadUrl = await uploadItemImage(file);
      updateItemInfo(imageDownloadUrl);
    } else {
      String imageDownloadUrl = widget.serviceModel!.serviceImgUrl!;
      updateItemInfo(imageDownloadUrl);
    }
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference reference =
        FirebaseStorage.instance.ref().child("Services");
    UploadTask uploadTask = reference
        .child("Service_${widget.serviceModel!.serviceId}.jpg")
        .putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  updateItemInfo(downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("service");
    itemsRef.doc(widget.serviceModel!.serviceId).update({
      "aboutInfo": aboutInfoController.text.trim(),
      "serviceName": serviceNameController.text.trim(),
      "expectation": expectationController.text.trim(),
      "orginalprice": int.parse(orginalPriceController.text),
      "newprice": int.parse(newPriceController.text),
      "offer": int.parse(offerPercentController.text),
      "publishedDate": DateTime.now(),
      "status": selectedStatusType,
      "categoryName": seletedCategory,
      "brandName": seletedBrand,
      "serviceImgUrl": downloadUrl,
    });
  }

  deleteItem() {
    final itemsRef = FirebaseFirestore.instance.collection("service");
    itemsRef.doc(widget.serviceModel!.serviceId).delete();
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
