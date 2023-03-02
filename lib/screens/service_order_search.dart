import 'package:oilappadmin/model/product_model.dart';
import 'package:oilappadmin/model/service_order_model.dart';
import 'package:oilappadmin/model/service_order_with_vehicles_model.dart';
import 'package:oilappadmin/model/user_model.dart';
import 'package:oilappadmin/model/users_vehicles_model.dart';
import 'package:oilappadmin/screens/edit_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oilappadmin/screens/user_service_details.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_user.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/services/services_order_service.dart';

class ServiceOrderSearch extends StatefulWidget {
  @override
  _ServiceOrderSearchState createState() => _ServiceOrderSearchState();
}

class _ServiceOrderSearchState extends State<ServiceOrderSearch> {
  final searchServiceOrderController = TextEditingController();

  List _allServiceOrderResults = [];
  List _serviceOrderResultList = [];
  List _serviceOrdersFiltered = [];
  Future? serviceOrdersResultsLoaded;
  ServiceOrdersService serviceOrdersService = ServiceOrdersService();
  @override
  void initState() {
    searchServiceOrderController.addListener(_onServiceOrderSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchServiceOrderController.removeListener(_onServiceOrderSearchChanged);
    searchServiceOrderController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    serviceOrdersResultsLoaded = getAllSearchServiceOrdersData();
  }

  _onServiceOrderSearchChanged() {
    searchServiceOrdersResultsList();
  }

  searchServiceOrdersResultsList() async {
    serviceOrdersService.setEmptyServiceOrderWithVehicleList();
    await serviceOrdersService.getServiceOrderWithVehicle(useLimit: false, orderId: searchServiceOrderController.text);
    var data = serviceOrdersService.serviceOrderWithVehicle;
    
    if(mounted){
      setState(() {
      _allServiceOrderResults = data;
      });
    }
    var showResult = [];
    if (searchServiceOrderController.text != "") {
      for (var userfromjson in _allServiceOrderResults) {
        /* String username = UserModel.fromSnaphot(userfromjson).name!.toLowerCase();
        String email = UserModel.fromSnaphot(userfromjson).email!.toLowerCase();
        String phone = UserModel.fromSnaphot(userfromjson).phone!.toLowerCase();
        String address = UserModel.fromSnaphot(userfromjson).address!.toLowerCase();

        if (username.contains(searchServiceOrderController.text.toLowerCase())) {
          showResult.add(userfromjson);
        }
        else if (email.contains(searchServiceOrderController.text.toLowerCase())) {
          showResult.add(userfromjson);
        }
        else if (phone.contains(searchServiceOrderController.text.toLowerCase().replaceFirst('0', ''))) {
          showResult.add(userfromjson);
        }
        else if (address.contains(searchServiceOrderController.text.toLowerCase().replaceFirst('0', ''))) {
          showResult.add(userfromjson);
        } */
        showResult.add(userfromjson);

      }
    } else {
      showResult = List.from(_allServiceOrderResults);
    }
    _serviceOrderResultList = showResult;
    _serviceOrdersFiltered = _serviceOrderResultList;
  }

  getAllSearchServiceOrdersData() async {
    await serviceOrdersService.getServiceOrderWithVehicle(useLimit: false, orderId: searchServiceOrderController.text);
    var data = serviceOrdersService.serviceOrderWithVehicle;
    if(mounted){
      setState(() {
      _allServiceOrderResults = data;
      });
    }
    searchServiceOrdersResultsList();
    return "Completo";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          onChanged: (searchProductController) {
            if(mounted){
              setState(() {
                searchProductController;
              });
            }
          },
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          controller: searchServiceOrderController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 0,
            ),
            hintText: 'Buscar Usuarios...',
            hintStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            // Route route = MaterialPageRoute(builder: (_) => Products());
            // Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              searchServiceOrderController.text = "";
            },
          ),
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
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,                
                itemCount: _serviceOrdersFiltered.length,
                itemBuilder: (BuildContext context, int index) {
                  
                  final serviceOrderWithVehicle = _serviceOrdersFiltered[index];

                  ServiceOrderWithVehicleModel seviceOrderWithVehicleModel = ServiceOrderWithVehicleModel.fromJson(
                      serviceOrderWithVehicle.toJson()
                  );

                  UsersVehiclesModel usersVehiclesModel = UsersVehiclesModel.fromJson(
                    seviceOrderWithVehicleModel.vehicleModel!
                  );

                  ServiceOrderModel serviceOrderModel = ServiceOrderModel.fromJson(
                    seviceOrderWithVehicleModel.serviceOrderModel!
                  );


                  return OrderBody(
                    itemCount: _serviceOrdersFiltered.length,
                    data: serviceOrderModel,
                    vehicleModel: usersVehiclesModel,    
                  );
                  
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderBody extends StatelessWidget {
  const OrderBody({
    required this.itemCount,
    required this.data,
    required this.vehicleModel,
    Key? key,
  }) : super(key: key);
  final int itemCount;
  final ServiceOrderModel data;
  final UsersVehiclesModel vehicleModel;
  @override
  Widget build(BuildContext context) {

    DateTime myDateTime = (data.orderTime)!;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "ID de la Orden: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    TextSpan(
                      text: data.orderId,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                  ],
                ),
              ),
              Text(
                "Vehiculo: ${vehicleModel.brand}, ${vehicleModel.model} ",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Servicio: ${data.serviceName}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Precio Total: " + data.totalPrice.toString() + " \$.",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(DateFormat.yMMMd().add_jm().format(myDateTime)),
              Text(timeago.format(DateTime.tryParse(data.orderTime!.toString())!).toString()),
              ElevatedButton(
                /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                ), */
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserServiceDetails(
                        orderId: data.orderId!,
                        addressId: data.addressID!,
                        usersVehiclesModel: vehicleModel,
                        idOrderPaymentDetails: data.idOrderPaymentDetails!,
                      ),
                    ),
                  );
                },
                /* color: Colors.deepOrangeAccent[200], */
                child: const Text(
                  "Detalle de la orden",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ]
          ),
        )
      )
    );
  }
}
