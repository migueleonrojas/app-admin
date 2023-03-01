import 'dart:io';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/user_model.dart';
import 'package:oilappadmin/model/vehicle_model.dart';
import 'package:oilappadmin/screens/add_brand.dart';
import 'package:oilappadmin/screens/add_model.dart';
import 'package:oilappadmin/screens/add_year.dart';
import 'package:oilappadmin/screens/carNotes.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/services.dart';
import 'package:oilappadmin/screens/products.dart';
import 'package:oilappadmin/screens/vehicles.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';

class EditMotorcycle extends StatefulWidget {
  final VehicleModel? vehicleModel;
  final UserModel? userModel;

  const EditMotorcycle({Key? key, this.vehicleModel, this.userModel}) : super(key: key);

  @override
  _EditMotorcycleState createState() => _EditMotorcycleState();
}

class _EditMotorcycleState extends State<EditMotorcycle> {

  void changeColor(Color color) {
   setState(() => pickerColor = color);
  }
  
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController nameOwnerController = TextEditingController();
  TextEditingController tuitionController = TextEditingController();
  /* TextEditingController colorController = TextEditingController(); */
  Color? pickerColor;
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  int selectedIndex = 0;
  int? idBrand;
  String? logoBrand;
  int? indexBrandController;
  int? indexModelController;
  int? indexYearController;
  int? indexColorController;

  @override
  void initState() {
    brandController.text = widget.vehicleModel!.brand!;
    modelController.text = widget.vehicleModel!.model!;
    yearController.text = widget.vehicleModel!.year.toString();
    mileageController.text = widget.vehicleModel!.mileage.toString();
    nameOwnerController.text = widget.vehicleModel!.name!;
    tuitionController.text = widget.vehicleModel!.tuition!;
    /* colorController.text = widget.vehicleModel!.color.toString(); */
    pickerColor = Color(widget.vehicleModel!.color!);
    logoBrand = widget.vehicleModel!.logo;
    Future.delayed(Duration.zero, () async {
      
      await getIndexBrand();
      await getIndexModel();
      await getIndexYear();
      setState((){});
      
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text("Editar Moto"),
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
      body: 
      (indexBrandController == null && indexModelController == null && indexYearController == null)
      ? circularProgress()
      : SingleChildScrollView(
        child: Column(
          children: [
            /* GestureDetector(
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
                        : NetworkImage(widget.vehicleModel!.serviceImgUrl!) as ImageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ), */
            const SizedBox(height: 20),
            Image.network(
              logoBrand!, 
              height: 100,
              width: double.infinity,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap:addBrand,
                          child: Row(
                            children: [
                              const Text('* Marca'),
                              const Expanded(child: SizedBox(width: double.infinity,)),
                              Text((brandController.text.isEmpty? 'Seleccione la Marca': brandController.text))
                            ],
                          ),
                        ),
                      ),
                  /* TextFormField(
                    controller: brandController,
                    decoration: const InputDecoration(
                      hintText: "Editar Marca",
                      labelText: "Marca",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ), */
                  
                  const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap:addModel,
                          child: Row(
                            children: [
                              const Text('* Modelo'),
                              const Expanded(child: SizedBox(width: double.infinity,)),
                              Text((modelController.text.isEmpty? 'Seleccione el Modelo': modelController.text))
                            ],
                          ),
                        ),
                      ),
                  /* TextFormField(
                    controller: modelController,
                    decoration: const InputDecoration(
                      hintText: "Editar Modelo",
                      labelText: "Modelo",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ), */
                  const SizedBox(height: 5),
                  /* TextFormField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Editar Año",
                      labelText: "Año",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ), */
                  Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap:addYear,
                          child: Row(
                            children: [
                              const Text('* Año'),
                              const Expanded(child: SizedBox(width: double.infinity,)),
                              Text((yearController.text.isEmpty? 'Selecciona el año': yearController.text))
                            ],
                          ),
                        ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: nameOwnerController,
                    decoration: const InputDecoration(
                      hintText: "Editar Nombre",
                      labelText: "Nombre",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: tuitionController,
                    decoration: const InputDecoration(
                      hintText: "Editar Matricula",
                      labelText: "Matricula",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ColorPicker(
                    
                    pickerColor: pickerColor!,
                    onColorChanged: changeColor,
                  ),
                  
                  /* Row(
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
                              hint: Text(
                                'Select Category',
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
                            Text('Loading');
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
                              hint: Text(
                                'Select Brand',
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ), */
                  
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: TextFormField(
                          controller: orginalPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Original Price",
                            labelText: "Original Price",
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
                          decoration: InputDecoration(
                            hintText: "Enter Offer percent",
                            labelText: "Offer Percent",
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
                  ), */
                  /* Container(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton(
                      items: status
                          .map(
                            (value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
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
                      hint: Text(
                        'Select Status',
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ), */
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Actualizar Vehiculo'),
                    onPressed: () async {
                      if (brandController.text.isNotEmpty &&
                          modelController.text.isNotEmpty &&
                          yearController.text.isNotEmpty &&
                          mileageController.text.isNotEmpty 
                          ) {
                        bool confirm = await _confirm("De que quiere actualizar el vehiculo");
                        if(confirm){
                          updateVehicle();
                          Fluttertoast.showToast(
                            msg: 'Vehiculo actualizado exitosamente');
                          Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => Vehicles()));
                        }

                        
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const ErrorAlertDialog(
                                message: "Por favor indique toda la información solicitada.",
                              );
                            });
                      }
                    },
                  ),
                  ElevatedButton(
                    /* color: Colors.redAccent, */
                    child: const Text(
                      'Eliminar Vehiculo',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      bool confirm = await _confirm("De que quiere actualizar el vehiculo");
                      if(confirm){

                        deleteVehicle();
                        Fluttertoast.showToast(
                          msg: 'Vehiculo eliminado exitosamente');
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => Vehicles()));

                      }
                      
                    },
                  ),
                  SizedBox(height: 5),
                  if(widget.userModel != null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => CarNotes(
                          vehicleModel: widget.vehicleModel,
                          userModel: widget.userModel
                          
                        ))
                      );
                    },
                    child: const Text(
                      'Notas de Servicio',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    
                  )
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  /* updateVehicle() async {
    final itemsRef = FirebaseFirestore.instance.collection("vehicles");
    await itemsRef.doc(widget.vehicleModel!.vehicleId).update({
      "brand": brandController.text.trim(),
      "name": nameOwnerController.text,
      "model": modelController.text.trim(),
      "year": int.parse(yearController.text),
      "tuition": tuitionController.text,
      "color": pickerColor!.value,
    });
  } */
  updateVehicle() async {

    final model = VehicleModel(
      vehicleId: widget.vehicleModel!.vehicleId,
      userId: widget.vehicleModel!.userId,
      brand: brandController.text.trim(), 
      model: modelController.text.trim(),
      mileage: widget.vehicleModel!.mileage,
      year: int.parse(yearController.text),
      color: pickerColor!.value,
      name: nameOwnerController.text,
      tuition: tuitionController.text,
      logo: logoBrand,
      registrationDate: widget.vehicleModel!.registrationDate,
      updateDate: widget.vehicleModel!.updateDate
    ).toJson();

    await FirebaseFirestore.instance
      .collection(AutoParts.collectionUser)
      .doc(widget.vehicleModel!.userId)
      .collection(AutoParts.vehicles)
      .doc(widget.vehicleModel!.vehicleId)
      .update(model)
      .whenComplete(() { 
        updateVehicleForAdmin();
      })
      .then((value) => {

      });
  }
  updateVehicleForAdmin(){
    final model = VehicleModel(
      vehicleId: widget.vehicleModel!.vehicleId,
      userId: widget.vehicleModel!.userId,
      brand: brandController.text.trim(), 
      model: modelController.text.trim(),
      mileage: widget.vehicleModel!.mileage,
      year: int.parse(yearController.text),
      color: pickerColor!.value,
      name: nameOwnerController.text,
      tuition: tuitionController.text,
      logo: logoBrand,
      registrationDate: DateTime.now(),
      updateDate: widget.vehicleModel!.updateDate
    ).toJson();

    FirebaseFirestore.instance.collection('usersVehicles')
      .doc(widget.vehicleModel!.vehicleId)
      .update(model);
  }

  deleteVehicle() async {
    FirebaseFirestore.instance
      .collection(AutoParts.collectionUser)
      .doc(widget.vehicleModel!.userId)
      .collection(AutoParts.vehicles)
      .doc(widget.vehicleModel!.vehicleId)
      .delete()
      .whenComplete(() { 
        deleteVehicleForAdmin();
      })
      .then((value) => {

      });
  }  

  deleteVehicleForAdmin(){
    FirebaseFirestore.instance.collection('usersVehicles')
      .doc(widget.vehicleModel!.vehicleId)
      .delete();
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

    void addBrand() async {
      final alert = (indexBrandController == null && brandController.text == '' && idBrand == null && logoBrand == null) ? AddBrand(collection: 'brandsMotorcycle',):AddBrand(collection: 'brandsMotorcycle',selectedIndex:indexBrandController, brandName: brandController.text, brandId: idBrand, logoBrand:logoBrand);
      
      final returnDataBrand = await showDialog(context: context, barrierDismissible: false, builder: (_) => alert);
      final indexBrand = (returnDataBrand[0] == '')? '' : returnDataBrand[0];
      final brandName = (returnDataBrand[1] == null)? '' : returnDataBrand[1];
      final idBrandReturned = (returnDataBrand[2] == null)? '' : returnDataBrand[2];
      final logoBrandReturned = (returnDataBrand[3] == null)? '' : returnDataBrand[3];
      final confirmChanges = returnDataBrand[4];
      if(indexBrand != '' && brandName != '' && idBrandReturned != '' && logoBrandReturned != ''){
        indexBrandController = indexBrand;
        brandController.text = brandName;
        idBrand = idBrandReturned;
        logoBrand = logoBrandReturned;
        if(confirmChanges) modelController.text = '';
        indexModelController = null;
        setState(() {});
      }
  }

  void addModel() async {
    
    if(idBrand == null) return;
    final alert = (indexModelController == null && modelController.text == '') ? AddModel(collection: 'modelsMotorcycle',brandId: idBrand):AddModel(collection: 'modelsMotorcycle',selectedIndex:indexModelController, modelName: modelController.text, brandId: idBrand);
    
    final returnDataModel = await showDialog(context: context, barrierDismissible: false, builder: (_) => alert);
    final indexModel = (returnDataModel[0] == '')? '' : returnDataModel[0];
    final ModelName = (returnDataModel[1] == null)? '' : returnDataModel[1];
    if(indexModel != '' && ModelName != ''){
      indexModelController = indexModel;
      modelController.text = ModelName.toString();
      setState(() {});
    }
    
    
  }

  void addYear() async {

    
    final alert = (indexYearController == null && yearController.text == '') ? AddYear():AddYear(selectedIndex:indexYearController, year: int.parse(yearController.text));
    
    final returnDataYear = await showDialog(context: context, barrierDismissible: false, builder: (_) => alert);
    final indexYear = (returnDataYear[0] == '')? '' : returnDataYear[0];
    final year = (returnDataYear[1] == null)? '' : returnDataYear[1];
    if(indexYear != '' && year != ''){
      indexYearController = indexYear;
      yearController.text = year.toString();
      setState(() {});
    }
    
    
  }

  getIdBrand() async {
      final modelByName = await AutoParts.firestore!
        .collection('modelsVehicle')
        .where('name', isEqualTo: widget.vehicleModel!.model).get();
      final docModel = modelByName.docs;
      for(final doc in docModel){
        idBrand = doc.data()['id_brand'];
      }
  }
  Future <int> getIndexBrand() async {
      QuerySnapshot<Map<String, dynamic>> brandsMotorcycles = await AutoParts.firestore!
        .collection('brandsMotorcycle')
        .orderBy('name',descending: false)
        .get();
      int index = 0;
      for(final brandsMotorcycle in brandsMotorcycles.docs){
        
        if(widget.vehicleModel!.brand == brandsMotorcycle.data()['name']){
          break;
        }
        index++;
      }
      indexBrandController = index;
      
      return index;

    }

    Future <int> getIndexModel() async {

      final brand = await AutoParts.firestore!
        .collection('brandsMotorcycle')
        .where('name', isEqualTo: widget.vehicleModel!.brand).get();

      QuerySnapshot<Map<String, dynamic>> modelsMotorcycles = await AutoParts.firestore!
        .collection('modelsMotorcycle')
        .where('id_brand', isEqualTo: brand.docs[0].data()['id'])
        .orderBy('name',descending: false)
        .get();
      int index = 0;
      idBrand = brand.docs[0].data()['id'];
      
      for(final modelsMotorcycle in modelsMotorcycles.docs){
        
        if(widget.vehicleModel!.model == modelsMotorcycle.data()['name'].toString()){
          
          break;
        }
        index++;
      }
      indexModelController = index;
      
      return index;


    }

    Future <int> getIndexYear() async {

      QuerySnapshot<Map<String, dynamic>> yearsVehicles = await AutoParts.firestore!
        .collection(AutoParts.yearsVehicle)
        .orderBy('year',descending: true)
        .get();
      int index = 0;
      for(final yearsVehicle in yearsVehicles.docs){
        
        if(widget.vehicleModel!.year == yearsVehicle.data()['year']){
          break;
        }
        index++;
      }
      indexYearController = index;
      
      return index;


    }

    /* updateItemInfo(downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("service");
    itemsRef.doc(widget.vehicleModel!.serviceId).update({
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
  } */

    /* deleteItem() {
    final itemsRef = FirebaseFirestore.instance.collection("service");
    itemsRef.doc(widget.vehicleModel!.serviceId).delete();
  } */

  /* offerpercentageCalculation() {
    int orginalpricevalue = int.parse(orginalPriceController.text);
    int offervalue = int.parse(offerPercentController.text);
    double offerpercent = offervalue / 100;
    double mofferwithorginal = orginalpricevalue * offerpercent;
    double newpricevalue = orginalpricevalue - mofferwithorginal;
    setState(() {
      newPriceController.text = newpricevalue.toStringAsFixed(0);
    });
  } */

  /* takeImage(mContext) {
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
                  title: "Capture with Camera",
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: CustomSimpleDialogOption(
                  icon: Icons.photo_outlined,
                  title: "Select from Gallery",
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancle",
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
  } */

  /* capturePhotoWithCamera() async {
    Navigator.pop(context);
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      file = imageFile;
    });
  } */

  /* void pickPhotoFromGallery() async {
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
      String imageDownloadUrl = widget.vehicleModel!.serviceImgUrl!;
      updateItemInfo(imageDownloadUrl);
    }
  } */

  /* Future<String> uploadItemImage(mFileImage) async {
    final Reference reference =
        FirebaseStorage.instance.ref().child("Services");
    UploadTask uploadTask = reference
        .child("Service_${widget.vehicleModel!.serviceId}.jpg")
        .putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  } */

}
