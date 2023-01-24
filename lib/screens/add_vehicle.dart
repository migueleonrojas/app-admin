import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oilappadmin/Helper/custom_manage_button.dart';
import 'package:oilappadmin/services/brandVehicle.dart';
import 'package:oilappadmin/services/colorVehicle.dart';
import 'package:oilappadmin/services/modelVehicle.dart';
import 'package:oilappadmin/services/yearVehicle.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:oilappadmin/widgets/customsimpledialogoption.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';

import 'add_brandVehicle.dart';
class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {

  GlobalKey<FormState> _modelsformkey = GlobalKey<FormState>();
  GlobalKey<FormState> _yearformkey = GlobalKey<FormState>();

  
  TextEditingController modelsController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  
  
  String serviceId = DateTime.now().microsecondsSinceEpoch.toString();

  BrandVehicle _brandVehicle = BrandVehicle();
  ModelVehicle _modelVehicle = ModelVehicle();
  YearVehicle _yearVehicle = YearVehicle();
  ColorVehicle _colorVehicle = ColorVehicle();

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  

  void changeColor(Color color) {
   setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Vehiculo"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
           CustomManageButton(
            icon: Icons.branding_watermark_outlined,
            title: "Agregar Marca de Vehiculo",
            onTap: addBrand
          ),
          CustomManageButton(
            icon: Icons.my_library_add_rounded,
            title: "Agregar Modelo de Vehiculo",
            onTap: addModel
          ),
          CustomManageButton(
            icon: Icons.numbers,
            title: "Agregar Año de Vehiculo",
            onTap: addYear
          ),
          /* CustomManageButton(
            icon: Icons.color_lens_rounded,
            title: "Add Color",
            onTap: addColor
          ), */
        ],
      ),
    );
    
  }

  void addBrand() {
    final alert =  AddBrandVehicle();
    showDialog(context: context, builder: (_) => alert);
  }

  void addModel() async {

    final brands = await _brandVehicle.getBrandsVehicle();
    String brandId = '';
    var alert = AlertDialog(
      content: Container(
        height: 100,
        child: Form(
          child: Column(
            children: [
              DropdownButtonFormField(
                hint: const Text('Selecciona Marca del Vehiculo'),
                items: 
                  brands.map((e) {
                    return DropdownMenuItem(
                      value: e['id'],
                      child: Text(e['name']),
                    );
                  }).toList(),
                onChanged: (value) {
                  brandId = value.toString();
                },
              ),
              TextFormField(
                controller: modelsController,
                decoration: const InputDecoration(
                  hintText: "Agregar Modelo del Vehiculo",
                ),
              ),
            ]
          ),
        )
      ),
      actions: [
        TextButton(
          child: const Text('Agregar'),
          onPressed: () async {
            if (modelsController.text.isNotEmpty && brandId != '') {
              
              String name = modelsController.text.trim().toLowerCase();
              String newname = name.replaceAllMapped(RegExp(r'(\s+[a-z]|^[a-z])'), (Match m) {
                if(m[0]!.length > 1) { return "-"+ "${m[0]}".trim().toUpperCase(); }
                else { return '${m[0]}'.toUpperCase();}
              });

              bool isDuplicate = await _modelVehicle.validateNoDuplicateRows(newname, newname.toLowerCase(), int.parse(brandId));
              if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "El modelo que quiere agregar ya existe"
                  );
                });
              }
              else {
                final lastId = await _modelVehicle.getLastIdRow();
                
                _modelVehicle.createModelVehicle(int.parse(brandId), lastId, newname, newname.toLowerCase());

                Fluttertoast.showToast(msg: 'Modelo del Vehiculo Creado');
                setState(() {
                  modelsController.text = '';
                });
                if(!mounted)return;
                Navigator.pop(context);
              }

            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor indique un Modelo o Marca del Vehiculo.",
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            modelsController.text = '';
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void addYear() {
    var alert = AlertDialog(
      content: Form(
        key: _yearformkey,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: yearController,
          decoration: const InputDecoration(
            hintText: "Agregar Año del Vehiculo",
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Agregar'),
          onPressed: () async {
            if (yearController.text.isNotEmpty) {

              bool isDuplicate = await _yearVehicle.validateNoDuplicateRows(int.parse(yearController.text));
              if(isDuplicate){
                showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "El año que quiere agregar ya existe.",
                    );
                });
              }
              else{
                _yearVehicle.createYearVehicle(int.parse(yearController.text));
                Fluttertoast.showToast(msg: 'Año del Vehiculo creado');
                setState(() {
                  yearController.text = '';
                });
                if(!mounted) return;
                Navigator.pop(context);
              }
              
              
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor escriba un año del Vehiculo.",
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            yearController.text = '';
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void addColor() {
    var alert = AlertDialog(
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Add'),
          onPressed: () {
           
            _colorVehicle.createColorVehicle(pickerColor.value);
            Fluttertoast.showToast(msg: 'Color Created');
            Navigator.pop(context);
            
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

}