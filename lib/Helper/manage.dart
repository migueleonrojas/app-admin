import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:oilappadmin/Helper/custom_manage_button.dart';
import 'package:oilappadmin/screens/add_carousel.dart';
import 'package:oilappadmin/screens/add_motorcycle.dart';
import 'package:oilappadmin/screens/add_product.dart';
import 'package:oilappadmin/screens/add_service.dart';
import 'package:oilappadmin/screens/add_vehicle.dart';
import 'package:oilappadmin/screens/brands_services_and_products.dart';
import 'package:oilappadmin/screens/brands_vehicles.dart';
import 'package:oilappadmin/screens/categories_services_and_products.dart';
import 'package:oilappadmin/screens/control_orders.dart';
import 'package:oilappadmin/screens/models_vehicles.dart';
import 'package:oilappadmin/screens/service_order.dart';
import 'package:oilappadmin/screens/services.dart';
import 'package:oilappadmin/screens/products.dart';
import 'package:oilappadmin/screens/vehicles.dart';
import 'package:oilappadmin/screens/years_vehicles.dart';
import 'package:oilappadmin/services/brand.dart';
import 'package:oilappadmin/services/category.dart';
import 'package:oilappadmin/widgets/error_dialog.dart';
import 'package:oilappadmin/widgets/nointernetalertdialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Manage extends StatefulWidget {
  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  GlobalKey<FormState> _categoryformkey = GlobalKey<FormState>();
  GlobalKey<FormState> _brandformkey = GlobalKey<FormState>();
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController brandTextEditingController = TextEditingController();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomManageButton(
            icon: Icons.add,
            title: "Agregar Producto / Servicio / Vehiculo / Moto",
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    title: const Text("Seleccione una opción"),
                    
                    actions:  [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Agregar Producto",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
    
                          Route route = MaterialPageRoute(builder: (c) => const AddProduct());
                          if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Agregar Servicio",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
    
                          Route route = MaterialPageRoute(builder: (c) => const AddService());
                          if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Agregar Carro",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
    
                          Route route = MaterialPageRoute(builder: (c) => const AddVehicle());
                          if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Agregar Moto",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
    
                          Route route = MaterialPageRoute(builder: (c) => const AddMotorcycle());
                          if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          CustomManageButton(
            icon: Icons.category_outlined,
            title: "Agregar Categoria de Producto o Servicio",
            onTap: addCategory,
          ),
          CustomManageButton(
            icon: Icons.branding_watermark_outlined,
            title: "Agregar Marca del Producto o Servicio ",
            onTap: addBrand,
          ),
          CustomManageButton(
            icon: Icons.slideshow_outlined,
            title: "Agregar Carrusel de Productos",
            onTap: () async {
              var connectivityResult = await Connectivity().checkConnectivity();
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi) {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const NoInternetAlertDialog();
                  },
                );
              }
              Route route = MaterialPageRoute(builder: (c) => AddCarousel());
              if(!mounted)return;
              Navigator.push(context, route);
            },
          ),
          CustomManageButton(
            icon: Icons.list_alt_outlined,
            title: "Ver todos los Productos / Servicios / Vehiculos",
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    title: const Text("Selecciona una opción"),
                    
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todos los Productos",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
                          if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todos los Servicios",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
                              if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todos los Vehiculos",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
    
                          Route route = MaterialPageRoute(builder: (c) => Vehicles());
                              if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        "Cancelar",
                        style:  TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            },
          ),
          CustomManageButton(
            icon: Icons.car_repair,
            title: "Ver (Marcas / Categorías) de Productos y Servicios",
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    title: const Text("Selecciona una opción"),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todas las marcas de Productos y Servicios",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
                          if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todas las categorías de Productos y Servicios",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
                              if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        "Cancelar",
                        style:  TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            },
          ),
          CustomManageButton(
            icon: Icons.car_repair,
            title: "Ver (Marcas / Modelos / Años) de Vehiculos",
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    title: const Text("Selecciona una opción"),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todas las marcas de Vehiculos",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
    
                          Route route = MaterialPageRoute(builder: (c) => BrandVehicles());
                          if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todos los Modelos de los Vehiculos",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
    
                          Route route = MaterialPageRoute(builder: (c) => ModelsVehicles());
                              if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todos los años de los Vehiculos",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
    
                          Route route = MaterialPageRoute(builder: (c) => YearsVehicles());
                              if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        "Cancelar",
                        style:  TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            },
          ),
          /* CustomManageButton(
            icon: Icons.local_shipping_outlined,
            title: "Control de Ordenes",
            onTap: () async {
              var connectivityResult = await Connectivity().checkConnectivity();
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
              if(!mounted) return;
              Navigator.push(context, route);
              if(!mounted)return;
            },
          ), */
          CustomManageButton(
            icon: Icons.car_repair,
            title: "Control de Ordenes",
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    title: const Text("Selecciona una opción"),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todas las ordenes de Productos",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
                          if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text(
                          "Ver todas las ordenes de Servicios",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onPressed: () async {
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
                              if(!mounted)return;
                          Navigator.push(context, route);
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        "Cancelar",
                        style:  TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void addCategory() {
    var alert = AlertDialog(
      content: Form(
        key: _categoryformkey,
        child: TextFormField(
          controller: categoryTextEditingController,
          decoration: const InputDecoration(
            hintText: "Agregar Categoría",
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Agregar'),
          onPressed: () async {
            if (categoryTextEditingController.text.isNotEmpty) {

              bool isDuplicate = await _categoryService.validateNoDuplicateRows(categoryTextEditingController.text);

              if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "La categoría que quiere agregar ya existe"
                  );
                });
              }
              else {
                _categoryService.createCategory(categoryTextEditingController.text);
                Fluttertoast.showToast(msg: 'Categoría Creada');
                setState(() {
                  categoryTextEditingController.text = '';
                });
                Navigator.pop(context);
              }

              
              
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor indique un nombre de la Categoría.",
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            categoryTextEditingController.text = '';
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void addBrand() {
    var alert = AlertDialog(
      content: Form(
        key: _brandformkey,
        child: TextFormField(
          controller: brandTextEditingController,
          decoration: const InputDecoration(
            hintText: "Agregar Marca de Producto o Servicio",
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Agregar'),
          onPressed: () async {
            if (brandTextEditingController.text.isNotEmpty) {
              bool isDuplicate = await _brandService.validateNoDuplicateRows(brandTextEditingController.text);

              if(isDuplicate){
                showDialog(
                context: context,
                builder: (c) {
                  return const ErrorAlertDialog(
                     message: "La marca del producto o servicio que quiere agregar ya existe"
                  );
                });
              }
              else {
                _brandService.createBrad(brandTextEditingController.text);
                Fluttertoast.showToast(msg: 'Marca Creada');
                setState(() {
                  brandTextEditingController.text = '';
                });
                Navigator.pop(context);
              }

              
              
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorAlertDialog(
                      message: "Por favor indique un nombre de Marca",
                    );
                  });
            }
          },
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            brandTextEditingController.text = '';
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}
