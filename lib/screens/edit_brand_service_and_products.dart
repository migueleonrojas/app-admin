import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/model/brand_service_and_products_model.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/services/brandServiceAndProduct.dart';
import 'package:oilappadmin/services/brandVehicle.dart';
import 'package:oilappadmin/services/modelVehicle_service.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:path_provider/path_provider.dart';
class EditBrandServiceAndProducts extends StatefulWidget {

  final BrandServiceAndProductsModel brandServiceAndProductsModel;
  const EditBrandServiceAndProducts({super.key, required this.brandServiceAndProductsModel});

  @override
  State<EditBrandServiceAndProducts> createState() => _EditBrandServiceAndProductsState();
}

class _EditBrandServiceAndProductsState extends State<EditBrandServiceAndProducts> {
  
  GlobalKey<FormState> _brandformkey = GlobalKey<FormState>();
  TextEditingController brandController = TextEditingController();
  BrandServiceAndProduct _brandServiceAndProduct = BrandServiceAndProduct();

  @override
  void initState() {
    super.initState();
    brandController.text = widget.brandServiceAndProductsModel.brandName!;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 60,
        child: Column(
          children: [
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
            bool confirm = await _confirm('De que quiere actualizar la marca del producto o servicio');

            if (!confirm) return;
            if (brandController.text.isNotEmpty) {

             
              bool isDuplicate = await _brandServiceAndProduct.validateNoDuplicateRows(brandController.text);
              bool isUsedInServices = await _brandServiceAndProduct.brandNameIsAssignedOnServices(brandController.text);
              bool isUsedInProducts = await _brandServiceAndProduct.brandNameIsAssignedOnProducts(brandController.text);

              if(isUsedInServices){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede modificar el nombre de la marca de producto que ya esta asignada"
                  );
                });
              }

              else if(isUsedInProducts){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede modificar el nombre de la marca de servicio que ya esta asignada"
                  );
                });
              }

              else if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "Esta modificando el nombre de la marca de servicio o producto por una ya existente"
                  );
                });
              }
              else {
                
                _brandServiceAndProduct.updateBrand(widget.brandServiceAndProductsModel.brandName!, brandController.text);
                Fluttertoast.showToast(msg: 'Marca Editada');
                Navigator.pop(context);
              }              
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor escriba una Marca para actualizar"
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Eliminar'),
          onPressed: () async {
            bool confirm = await _confirm('De que quiere eliminar la marca del producto o servicio');

            if (!confirm) return;
            bool isUsedInServices = await _brandServiceAndProduct.brandNameIsAssignedOnServices(brandController.text);
            bool isUsedInProducts = await _brandServiceAndProduct.brandNameIsAssignedOnProducts(brandController.text);

            if(isUsedInServices){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede eliminar el nombre de la marca de servicio que ya esta asignada"
                  );
                });
              }

              else if(isUsedInProducts){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede eliminar el nombre de la marca de producto que ya esta asignada"
                  );
                });
              }
              else{
                _brandServiceAndProduct.deleteBrand(widget.brandServiceAndProductsModel.brandName!);
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