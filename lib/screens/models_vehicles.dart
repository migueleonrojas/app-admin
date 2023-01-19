import 'package:oilappadmin/Helper/dashboard.dart';
import 'package:oilappadmin/Helper/manage.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/model/model_vehicle_model.dart';
import 'package:oilappadmin/model/model_vehicle_with_brand.dart';
import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/vehicle_model.dart';
import 'package:oilappadmin/screens/edit_brand_vehicle.dart';
import 'package:oilappadmin/screens/edit_model_vehicle.dart';
import 'package:oilappadmin/screens/edit_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_vehicle.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:rxdart/rxdart.dart';

import '../services/modelVehicle.dart';

class ModelsVehicles extends StatefulWidget {
  @override
  _ModelsVehiclesState createState() => _ModelsVehiclesState();
}

class _ModelsVehiclesState extends State<ModelsVehicles> {

  ModelVehicle modelVehicle = ModelVehicle();

  @override
  void initState() {
    super.initState();
    modelVehicle.getModelsVehicle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos los Modelos de Vehiculos"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => MainScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: modelVehicle.suggestionStream,
              builder: (context, snapshotModel) {

                if (snapshotModel.data == null) return Text('');
                
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 4,
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(2),
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      itemCount: snapshotModel.data!.length,
                      itemBuilder: (BuildContext context, int index)   {

                        if (snapshotModel.data == null) return Text('');
                        final modelWithBrandName = snapshotModel.data!;
                
                        ModelVehicleWithBrand modelVehicleWithBrand = ModelVehicleWithBrand.fromJson(
                          modelWithBrandName[index].toJson()
                        );

                        ModelVehicleModel modelVehicleModel = ModelVehicleModel.fromJson(
                          modelVehicleWithBrand.modelVehicle!
                        );
                    
                        
                        return GestureDetector(
                          onTap: () async {
                            final alert =  EditModelVehicle(
                              modelVehicleModel: modelVehicleModel,
                              brandVehicle: modelVehicleWithBrand.brandName!,
                            );
                            final modify = await showDialog(context: context, builder: (_) => alert) ?? false;

                            if(modify) modelVehicle.getModelsVehicle();
                            
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 5),
                                
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(modelVehicleWithBrand.brandName!),
                                      Text(
                                        modelVehicleModel.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),                                
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  

  
  

}
