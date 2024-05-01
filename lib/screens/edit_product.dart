import 'dart:io';

import 'package:oilappadmin/model/product_model.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/products.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget {
  final ProductModel? productModel;

  const EditProduct({Key? key, this.productModel}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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
  void initState() {
    shortInfoController.text = widget.productModel!.shortInfo!;
    productNameController.text = widget.productModel!.productName!;
    descriptionController.text = widget.productModel!.description!;
    orginalPriceController.text = widget.productModel!.orginalprice.toString();
    newPriceController.text = widget.productModel!.newprice.toString();
    offerPercentController.text = widget.productModel!.offervalue.toString();
    selectedStatusType = widget.productModel!.status;
    seletedBrand = widget.productModel!.brandName;
    seletedCategory = widget.productModel!.categoryName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Producto"),
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
                        : NetworkImage(widget.productModel!.productImgUrl!) as ImageProvider ,
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
                    maxLines: 2,
                    controller: shortInfoController,
                    decoration: const InputDecoration(
                      hintText: "Información Corta",
                      labelText: "Información Corta",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      hintText: "Ingrese Nombre del Producto",
                      labelText: "Nombre del Producto",
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
                            const Text('Cargando');
                          }
                          if (snapshot.data == null)
                            return CircularProgressIndicator();

                          List<DropdownMenuItem> categoriesItem = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            categoriesItem.add(
                              DropdownMenuItem(
                                value: "${(snap.data() as dynamic)['categoryName']}",
                                child: Text(
                                  "${(snap.data() as dynamic)['categoryName']}",
                                  style: TextStyle(color: Colors.black),
                                ),
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
                                'Seleccionar Categoria',
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
                                value: "${(snap.data() as dynamic)['brandName']}",
                                child:  Text(
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
                  const SizedBox(height: 5),
                  TextFormField(
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Descripción",
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
                            hintText: "Ingresar Precio Original",
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
                            hintText: "Enter % porcentaje de descuento",
                            labelText: "% porcentaje de descuento",
                            labelStyle:
                                TextStyle(color: Colors.deepOrangeAccent),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: ElevatedButton(
                          child: Text('='),
                          onPressed: () {
                            offerpercentageCalculation();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: newPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Mostrat Nuevo Precio",
                      labelText: "Nuevo Precio",
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    child: const Text(
                      'Actualizar Producto',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onPressed: () async {
                      if (shortInfoController.text.isNotEmpty &&
                          productNameController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          orginalPriceController.text.isNotEmpty &&
                          newPriceController.text.isNotEmpty &&
                          offerPercentController.text.isNotEmpty &&
                          seletedCategory != null &&
                          seletedBrand != null &&
                          selectedStatusType != null) {

                        bool confirm = await _confirm('De que quiere actualizar el producto');

                        if(confirm){
                          uploadImageAndSaveItemInfo();
                          Fluttertoast.showToast(
                            msg: 'Producto Actualizado Exitosamente');
                          Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => Products()));
                        }
                        
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const ErrorAlertDialog(
                                message: "Por favor ingresar toda la información solicitada",
                              );
                            });
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    /* color: Colors.redAccent, */
                    child: const Text(
                      'Eliminar Producto',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      bool confirm = await _confirm('De que quiere eliminar el producto');
                      if(confirm){
                        deleteItem();
                        Fluttertoast.showToast(
                          msg: 'Producto Eliminado Exitosamente');
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => Products()));
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
                  icon: Icons.photo_camera_outlined,
                  title: "Capturar desde la camara",
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
      String imageDownloadUrl = widget.productModel!.productImgUrl!;
      updateItemInfo(imageDownloadUrl);
    }
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference reference =
        FirebaseStorage.instance.ref().child("Products");
    UploadTask uploadTask = reference
        .child("Product_${widget.productModel!.productId}.jpg")
        .putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  updateItemInfo(downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("products");
    itemsRef.doc(widget.productModel!.productId).update({
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

  deleteItem() {
    final itemsRef = FirebaseFirestore.instance.collection("products");
    itemsRef.doc(widget.productModel!.productId).delete();
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
