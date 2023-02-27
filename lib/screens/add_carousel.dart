import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:oilappadmin/screens/all_carousel.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/services/carousel_service.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:oilappadmin/widgets/nointernetalertdialog.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddCarousel extends StatefulWidget {
  @override
  _AddCarouselState createState() => _AddCarouselState();
}

class _AddCarouselState extends State<AddCarousel> {
  XFile? file;
  String carouselId = DateTime.now().microsecondsSinceEpoch.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Carrusel"),
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
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
                        : const AssetImage(
                            "assets/authenticaiton/carousel1.png",
                          ) as ImageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(    
                  backgroundColor: Color.fromARGB(255, 3, 3, 247),
                  shape: const StadiumBorder()
                ),
                onPressed: () async {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult != ConnectivityResult.mobile &&
                      connectivityResult != ConnectivityResult.wifi) {

                    return showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return NoInternetAlertDialog();
                      }
                    );
                  }
                  if (file != null) {
                    CarouselService()
                        .uploadCarouselImageAndSavePublishedDate(File(file!.path));
                    Fluttertoast.showToast(msg: 'Carrusel Agregado Exitosamente');
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (c) {
                        return const ErrorAlertDialog(
                          message: "Por favor Seleccione una Imagen",
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  "Cargar Imagen",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /* color: Colors.deepOrangeAccent, */
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(    
                  backgroundColor: Color.fromARGB(255, 3, 3, 247),
                  shape: const StadiumBorder()
                ),
                onPressed: () {
                  Route route =
                      MaterialPageRoute(builder: (_) => AllCarousel());
                  Navigator.push(context, route);
                },
                child: const Text(
                  "Todas las Imagenes del Carrusel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /* color: Colors.deepOrangeAccent[200], */
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: const Text(
              "Seleccionar Imagen para el Carrusel",
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
                  title: "Capturar con la Camara",
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
}
