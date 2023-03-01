import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/model/brand_service_and_products_model.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/model/categories_service_and_products_model.dart';
import 'package:oilappadmin/services/brandServiceAndProduct.dart';
import 'package:oilappadmin/services/brandVehicle.dart';
import 'package:oilappadmin/services/categoryServiceAndProduct_service.dart';
import 'package:oilappadmin/services/modelVehicle_service.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:path_provider/path_provider.dart';
class EditCategoryServiceAndProducts extends StatefulWidget {

  final CategoryServiceAndProductsModel categoryServiceAndProductsModel;
  const EditCategoryServiceAndProducts({super.key, required this.categoryServiceAndProductsModel});

  @override
  State<EditCategoryServiceAndProducts> createState() => _EditCategoryServiceAndProductsState();
}

class _EditCategoryServiceAndProductsState extends State<EditCategoryServiceAndProducts> {
  
  GlobalKey<FormState> _categoryformkey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  CategoryServiceAndProduct _categoryServiceAndProduct = CategoryServiceAndProduct();

  @override
  void initState() {
    super.initState();
    categoryController.text = widget.categoryServiceAndProductsModel.categoryName!;
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
              key: _categoryformkey,
              child: TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  hintText: "Editar Categoría",
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
            if (categoryController.text.isNotEmpty) {

              bool confirm = await _confirm('De que quiere actualizar la categoria del servicio o producto');

              if(!confirm) return;

              bool isDuplicate = await _categoryServiceAndProduct.validateNoDuplicateRows(categoryController.text);
              bool isUsedInServices =  await _categoryServiceAndProduct.categoryIsAssignedOnServices(categoryController.text);
              bool isUsedInProducts = await _categoryServiceAndProduct.categoryIsAssignedOnProducts(categoryController.text);

              if(isUsedInServices){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede modificar el nombre de la categoria de servicio que ya esta asignada"
                  );
                });
              }

              else if(isUsedInProducts){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede modificar el nombre de la categoria de producto que ya esta asignada"
                  );
                });
              }

              else if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "Esta modificando el nombre de la categoría de servicio o producto por una ya existente"
                  );
                });
              }
              else {
                _categoryServiceAndProduct.updateCategory(widget.categoryServiceAndProductsModel.categoryName!, categoryController.text);
                Fluttertoast.showToast(msg: 'Categoría Editada');
                Navigator.pop(context);
              }              
            } 
            
            else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor escriba una Categoría para actualizar"
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Eliminar'),
          onPressed: () async {

            bool confirm = await _confirm('De que quiere eliminar la categoria del servicio o producto');

            if(!confirm) return;
            bool isUsedInServices = await _categoryServiceAndProduct.categoryIsAssignedOnServices(categoryController.text);
            bool isUsedInProducts = await _categoryServiceAndProduct.categoryIsAssignedOnProducts(categoryController.text);

            if(isUsedInServices){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede eliminar el nombre de la categoría de servicio que ya esta asignada"
                  );
                });
              }

              else if(isUsedInProducts){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "No puede eliminar el nombre de la categoría de producto que ya esta asignada"
                  );
                });
              }

              else{
                _categoryServiceAndProduct.deleteCategory(widget.categoryServiceAndProductsModel.categoryName!);
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