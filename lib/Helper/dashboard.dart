import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:oilappadmin/Helper/custom_card.dart';
import 'package:oilappadmin/screens/brands_services_and_products.dart';
import 'package:oilappadmin/screens/categories_services_and_products.dart';
import 'package:oilappadmin/screens/control_orders.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oilappadmin/screens/products.dart';
import 'package:oilappadmin/screens/service_order.dart';
import 'package:oilappadmin/screens/services.dart';
import 'package:oilappadmin/screens/users.dart';
import 'package:oilappadmin/screens/vehicles.dart';
import 'package:oilappadmin/widgets/nointernetalertdialog.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    // int totalRevenue = 0;
    // int totalServiceRevenue = 0;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Column(
            //       children: [
            //         Text(
            //           "Total Revenue \nFrom Order",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //         SizedBox(height: 10),
            //         StreamBuilder<QuerySnapshot>(
            //             stream: _db
            //                 .collection("orders")
            //                 .where("deliverd", isEqualTo: "Done")
            //                 .snapshots(),
            //             builder: (context, snapshot) {
            //               if (snapshot.data == null) return Text('');
            //               for (int i = 0; i < snapshot.data.docs.length; i++) {
            //                 totalRevenue = totalRevenue +
            //                     snapshot.data.docs[i].data()['totalPrice'];
            //               }
            //               return Text(
            //                 "\৳" + totalRevenue.toString(),
            //                 style: TextStyle(
            //                   fontSize: 22,
            //                   color: Colors.deepOrangeAccent[200],
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               );
            //             }),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Text(
            //           "Total Revenue \nFrom Service",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //         SizedBox(height: 10),
            //         StreamBuilder<QuerySnapshot>(
            //             stream: _db
            //                 .collection("serviceOrder")
            //                 .where("deliverd", isEqualTo: "Done")
            //                 .snapshots(),
            //             builder: (context, snapshot) {
            //               if (snapshot.data == null) return Text('');
            //               for (int i = 0; i < snapshot.data.docs.length; i++) {
            //                 totalServiceRevenue = totalServiceRevenue +
            //                     snapshot.data.docs[i].data()['totalPrice'];
            //               }
            //               return Text(
            //                 "\৳" + totalServiceRevenue.toString(),
            //                 style: TextStyle(
            //                   fontSize: 22,
            //                   color: Colors.deepOrangeAccent[200],
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               );
            //             }),
            //       ],
            //     ),
            //   ],
            // ),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("users").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Text('');
                    return CustomCard(
                      titleicon: Icons.people_alt_outlined,
                      titletext: "Usuarios",
                      counttext: snapshot.data!.docs.length.toString(),
                                              onTap: () async {
                          var connectivityResult =  await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
    
                                return const NoInternetAlertDialog();
                              },
                            );
                          }
    
                          Route route = MaterialPageRoute(builder: (c) => Users());
                              
                          Navigator.push(context, route);
                        },
                      
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("categories").snapshots(),
                  builder: (context, snapshot) {
                    
                    if (snapshot.data == null) return const Text('');
                    return CustomCard(
                      titleicon: Icons.category_outlined,
                      titletext: "Categorias",
                      counttext: snapshot.data!.docs.length.toString(),
                      onTap: () async {
                        var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
    
                                return const NoInternetAlertDialog();
                              },
                            );
                          }
    
                          Route route = MaterialPageRoute(builder: (c) => CategoriesServicesAndProducts());
                          
                          Navigator.push(context, route);
                      },
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("products").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return const Text('');
                    return CustomCard(
                      titleicon: Icons.list_alt_outlined,
                      titletext: "Productos",
                      counttext: snapshot.data!.docs.length.toString(),
                      onTap: () async {
                        var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
    
                                return const NoInternetAlertDialog();
                              },
                            );
                          }
    
                          Route route = MaterialPageRoute(builder: (c) => Products());
                          
                          Navigator.push(context, route);
                      },
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("brands").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Text('');
                    return CustomCard(
                      titleicon: Icons.branding_watermark_outlined,
                      titletext: "Marcas",
                      counttext: snapshot.data!.docs.length.toString(),
                      onTap: () async {
                        var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
    
                                return const NoInternetAlertDialog();
                              },
                            );
                          }
    
                          Route route = MaterialPageRoute(builder: (c) => BrandsServicesAndProducts());
                          
                          Navigator.push(context, route);
                      },
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _db.collection("service").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Text('');
                      return CustomCard(
                        titleicon: Icons.calendar_today_outlined,
                        titletext: "Servicios",
                        counttext: snapshot.data!.docs.length.toString(),
                        onTap: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
    
                                return const NoInternetAlertDialog();
                              },
                            );
                          }
    
                          Route route = MaterialPageRoute(builder: (c) => Services());
                              
                          Navigator.push(context, route);
                        },
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: _db.collection("orders").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Text('');
                      return CustomCard(
                        titleicon: Icons.local_shipping_outlined,
                        titletext: "Pedidos",
                        counttext: snapshot.data!.docs.length.toString(),
                        onTap: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
    
                                return const NoInternetAlertDialog();
                              },
                            );
                          }
    
                          Route route = MaterialPageRoute(builder: (c) => ControlOrders());
                          Navigator.push(context, route);
                        },
                        
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: _db.collection("serviceOrder").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Text('');
                      return CustomCard(
                        titleicon: Icons.date_range_outlined,
                        titletext: "Ordenes",
                        counttext: snapshot.data!.docs.length.toString(),
                        onTap: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
    
                                return const NoInternetAlertDialog();
                              },
                            );
                          }
    
                          Route route = MaterialPageRoute(builder: (c) => ServiceOrders());
                        
                          Navigator.push(context, route);
                        },
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: _db.collection("usersVehicles").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Text('');
                      return CustomCard(
                        titleicon: Icons.car_repair,
                        titletext: "Vehiculos",
                        counttext: snapshot.data!.docs.length.toString(),
                        onTap: () async {
                          var connectivityResult =  await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
    
                                return const NoInternetAlertDialog();
                              },
                            );
                          }
    
                          Route route = MaterialPageRoute(builder: (c) => Vehicles());
                              
                          Navigator.push(context, route);
                        },
                      );
                    }),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
