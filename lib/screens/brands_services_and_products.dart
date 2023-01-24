import 'package:oilappadmin/Helper/dashboard.dart';
import 'package:oilappadmin/Helper/manage.dart';
import 'package:oilappadmin/model/brand_service_and_products_model.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/vehicle_model.dart';
import 'package:oilappadmin/screens/edit_brand_service_and_products.dart';
import 'package:oilappadmin/screens/edit_brand_vehicle.dart';
import 'package:oilappadmin/screens/edit_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_vehicle.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';

class BrandsServicesAndProducts extends StatefulWidget {
  @override
  _BrandsServicesAndProductsState createState() => _BrandsServicesAndProductsState();
}

class _BrandsServicesAndProductsState extends State<BrandsServicesAndProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todas las Marcas de Servicios y Productos"),
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('brands')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }

                if(snapshot.data!.docs.isEmpty) {
                  return const EmptyCardMessage(
                    listTitle: 'No hay marcas de productos o servicios',
                    message: 'No hay marcas de productos o servicios actualmente',
                  );
                }
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
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        BrandServiceAndProductsModel brandServiceAndProductsModel = BrandServiceAndProductsModel.fromJson(
                            (snapshot.data!.docs[index] as dynamic).data());
                        return GestureDetector(
                          onTap: () {
                            final alert =  EditBrandServiceAndProducts(
                              brandServiceAndProductsModel: brandServiceAndProductsModel,
                            );
                            showDialog(context: context, builder: (_) => alert);
                            
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
                                      Text(
                                        brandServiceAndProductsModel.brandName!,
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
