import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:oilappadmin/model/product_model.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final ProductModel? productModel;

  const AddProduct({Key? key, this.productModel}) : super(key: key);
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  XFile? file;
  var seletedCategory, seletedBrand, selectedStatusType;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController orginalPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController offerPercentController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController shortInfoController = TextEditingController();
  List<String> status = <String>['Disponible', 'No Disponible'];
  String productId = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
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

    takeImage(mContext) {
      return showDialog(
          context: mContext,
          builder: (con) {
            return SimpleDialog(
              title: const Text(
                "Imagen del Producto",
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
                    title: "Seleccionar desde la galería",
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Producto"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            /* padding: EdgeInsets.zero, */
            child: Icon(
              Icons.add_circle_outline,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () async {
              var connectivityResult = await Connectivity().checkConnectivity();
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi) {
                Fluttertoast.showToast(msg: 'No internet connectivity');
                return;
              }
              if (shortInfoController.text.isNotEmpty &&
                  productNameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  orginalPriceController.text.isNotEmpty &&
                  newPriceController.text.isNotEmpty &&
                  offerPercentController.text.isNotEmpty &&
                  file != null &&
                  seletedCategory != null &&
                  seletedBrand != null &&
                  selectedStatusType != null) {
                uploadImageAndSaveItemInfo();
                Fluttertoast.showToast(msg: 'Producto Agregado Exitosamente');
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor indicar toda la información solicitada",
                    );
                  },
                );
              }
            },
          ),
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
                        : AssetImage(
                            "assets/authenticaiton/take_image.png",
                          ) as ImageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: shortInfoController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: "Ingrese Información Corta del Producto",
                      labelText: "Información Corta",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      hintText: "Ingrese el Nombre del Producto",
                      labelText: "Nombre del Producto",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("categories")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            Text('Cargando');
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
                            width: MediaQuery.of(context).size.width / 2.4,
                            child: DropdownButton(
                              items: categoriesItem,
                              onChanged: (categoryValue) {
                                setState(() {
                                  seletedCategory = categoryValue;
                                });
                              },
                              value: seletedCategory,
                              isExpanded: true,
                              hint: Text(
                                'Seleccione Categoría',
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
                            Text('Cargando');
                          }
                          if (snapshot.data == null)
                            return CircularProgressIndicator();

                          List<DropdownMenuItem> brandsItem = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            brandsItem.add(
                              DropdownMenuItem(
                                value: "${(snap.data() as dynamic)['brandName']}",
                                child: Text(
                                  "${(snap.data() as dynamic)['brandName']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
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
                                'Seleccione la Marca',
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
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Indique una Descripción",
                      labelText: "Descripción",
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
                            hintText: "Ingrese % de Oferta",
                            labelText: "% de Oferta",
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
                    controller: newPriceController,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Mostrar Precio Nuevo",
                      labelText: "Precio Nuevo",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton(
                      items: status
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child:  Text(value),
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

  uploadImageAndSaveItemInfo() async {
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference reference =
        FirebaseStorage.instance.ref().child("Products");
    UploadTask uploadTask =
        reference.child("Product_$productId.jpg").putFile(File(mFileImage!.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("products");
    itemsRef.doc(productId).set({
      "productId": productId,
      "shortInfo": shortInfoController.text.trim(),
      "productName": productNameController.text.trim(),
      "description": descriptionController.text.trim(),
      "orginalprice": int.parse(orginalPriceController.text),
      "newprice": int.parse(newPriceController.text),
      "offer": int.parse(offerPercentController.text),
      "publishedDate": DateTime.now(),
      "status": selectedStatusType,
      "categoryName": seletedCategory,
      "brandName": seletedBrand,
      "productImgUrl": downloadUrl,
    });
  }
}
