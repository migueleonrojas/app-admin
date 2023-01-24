import 'package:oilappadmin/Helper/dashboard.dart';
import 'package:oilappadmin/Helper/manage.dart';
import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/vehicle_model.dart';
import 'package:oilappadmin/screens/edit_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_vehicle.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';

class Vehicles extends StatefulWidget {
  @override
  _VehiclesState createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos los Vehiculos"),
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
              stream: AutoParts.firestore!
              .collection('usersVehicles')
              .snapshots(),
          
              /* stream: FirebaseFirestore.instance
                  .collection('vehicles')
                  .orderBy("registrationDate", descending: true)
                  .snapshots(), */
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const EmptyCardMessage(
                    listTitle: 'No hay vehiculos actualmente',
                    message: 'No hay vehiculos por lo momentos',
                  );
                }
                else if(snapshot.data!.docs.isEmpty) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.blueGrey.shade300,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const Center(
                            child: Text(
                              'No hay vehiculos registrados', 
                              style:TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Brand-Bold",),
                            ),
                          ),
                        ),
                      ],
                    )
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
                        VehicleModel vehicleModel = VehicleModel.fromJson(
                            (snapshot.data!.docs[index] as dynamic).data());
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => EditVehicle(
                                  vehicleModel: vehicleModel,
                                ),
                              ),
                            );
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
                                      Image.network(
                                        vehicleModel.logo!, 
                                        height: 30,
                                        width: 30,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        vehicleModel.brand!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.branding_watermark_rounded,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              vehicleModel.model!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.date_range_outlined,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              vehicleModel.year.toString(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.color_lens_sharp,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Container(
                                              color: Color(vehicleModel.color!),
                                              child: SizedBox(height: 10, width: 10,),
                                            )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),    
                                      
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
