import 'package:oilappadmin/Helper/dashboard.dart';
import 'package:oilappadmin/Helper/manage.dart';
import 'package:oilappadmin/model/brand_vehicle_model..dart';
import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/vehicle_model.dart';
import 'package:oilappadmin/screens/edit_brand_vehicle.dart';
import 'package:oilappadmin/screens/edit_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_vehicle.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/services/brandVehicle.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';

class BrandVehicles extends StatefulWidget {
  @override
  _BrandVehiclesState createState() => _BrandVehiclesState();
}

class _BrandVehiclesState extends State<BrandVehicles> {
  final ScrollController scrollController = ScrollController();
  BrandVehicle brandVehicle = BrandVehicle();
  int limit = 10;
  bool dataFinish = false;
  bool isLoading =  false;


  @override
  void initState() {
    super.initState();
    
    brandVehicle.getBrandsVehicleLimit(limit: limit);
    scrollController.addListener(() async {
      if(scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent) {
        if(isLoading) return;
        if(dataFinish) return;

        isLoading = true;
        await Future.delayed(const Duration(seconds: 1));
        dataFinish = await brandVehicle.getBrandsVehicleLimit(limit: 5, nextDocument: true);
        isLoading = false;
        if(scrollController.position.pixels + 200 <= scrollController.position.maxScrollExtent) return;
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 120, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.bounceOut
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          
        ),
        title: const Text("Todas las Marcas de Vehiculos"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => MainScreen(indexTab: 1,)));
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
        controller: scrollController,
        child: Column(
          children: [
            StreamBuilder(
              stream: brandVehicle.suggestionStreamBrandsVehicles,
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return circularProgress();
                }

                if(snapshot.data!.isEmpty) {

                  return const EmptyCardMessage(
                    listTitle: 'No tiene Marcas',
                    message: 'No hay Marcas de Vehiculos',
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
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        BrandVehicleModel brandVehicleModel = BrandVehicleModel.fromJson(
                            (snapshot.data![index] as dynamic));
                        return GestureDetector(
                          onTap: () {
                            final alert =  EditBrandVehicle(
                              brandVehicleModel: brandVehicleModel,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        brandVehicleModel.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      FadeInImage(
                                        placeholder: const AssetImage('assets/no-image/no-image.jpg'),
                                        image: NetworkImage(brandVehicleModel.logo!),
                                        fit: BoxFit.scaleDown,
                                        width: 40,
                                        height: 30,

                                      )
                                      
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
