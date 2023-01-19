import 'package:oilappadmin/Helper/dashboard.dart';
import 'package:oilappadmin/Helper/manage.dart';
import 'package:oilappadmin/model/brand_service_and_products_model.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/model/categories_service_and_products_model.dart';
import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/vehicle_model.dart';
import 'package:oilappadmin/screens/edit_brand_service_and_products.dart';
import 'package:oilappadmin/screens/edit_brand_vehicle.dart';
import 'package:oilappadmin/screens/edit_category_service_and_products.dart';
import 'package:oilappadmin/screens/edit_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_vehicle.dart';
import 'package:oilappadmin/screens/main_screen.dart';

class CategoriesServicesAndProducts extends StatefulWidget {
  @override
  _CategoriesServicesAndProductsState createState() => _CategoriesServicesAndProductsState();
}

class _CategoriesServicesAndProductsState extends State<CategoriesServicesAndProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todas las Categorias de Servicios y Productos"),
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
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null) return const Text('');
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
                        CategoryServiceAndProductsModel categoryServiceAndProductsModel = CategoryServiceAndProductsModel.fromJson(
                            (snapshot.data!.docs[index] as dynamic).data());
                        return GestureDetector(
                          onTap: () {
                            final alert =  EditCategoryServiceAndProducts(
                              categoryServiceAndProductsModel: categoryServiceAndProductsModel,
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
                                        categoryServiceAndProductsModel.categoryName!,
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