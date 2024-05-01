import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/model/service_order_model.dart';
import 'package:oilappadmin/model/service_order_with_vehicles_model.dart';
import 'package:oilappadmin/model/user_model.dart';
import 'package:oilappadmin/model/users_vehicles_model.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/service_order_search.dart';
import 'package:oilappadmin/screens/user_service_details.dart';
import 'package:oilappadmin/services/services_order_service.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ServiceOrdersByUser extends StatefulWidget {

  final UserModel userModel;
  ServiceOrdersByUser({required this.userModel});

  @override
  _ServiceOrdersByUserState createState() => _ServiceOrdersByUserState();
}

class _ServiceOrdersByUserState extends State<ServiceOrdersByUser> {
  final serviceOrdersService = ServiceOrdersService();
  final ScrollController scrollController = ScrollController();
  int limit = 5;
  bool dataFinish = false;
  bool isLoading =  false;
  @override
  void initState() {
    super.initState();
    
    serviceOrdersService.getServiceOrderWithVehicle(limit: 5, userId: widget.userModel.uid!);
    scrollController.addListener(() async {
      
      if(scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent) {
        if(isLoading) return;
        if(dataFinish) return;
        
        isLoading = true;
        await Future.delayed(const Duration(seconds: 1));
        dataFinish = await serviceOrdersService.getServiceOrderWithVehicle(limit: limit, nextDocument: true, userId: widget.userModel.uid!);
        isLoading = false;
        
        if(scrollController.position.pixels + 200 <= scrollController.position.maxScrollExtent) return;
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 120, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.fastOutSlowIn
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
        title: const Text("Ordenes de Servicios"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
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
          ),
          IconButton(
            icon: const Icon(
              Icons.search_outlined,
            ),
            onPressed: () {
              showSearch(context: context, delegate: ServiceOrderSearch());
              /* Route route = MaterialPageRoute(builder: (_) => ServiceOrderSearch());
              Navigator.push(context, route); */
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder(
              stream: serviceOrdersService.suggestionStreamServiceOrder,
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }

                if (snapshot.data!.isEmpty) {
                  return const EmptyCardMessage(
                    listTitle: 'No hay Ordenes actualmente',
                    message: 'No hay Ordenes por lo momentos',
                  );
                }

                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final serviceOrderWithVehicle = snapshot.data!;

                    ServiceOrderWithVehicleModel seviceOrderWithVehicleModel = ServiceOrderWithVehicleModel.fromJson(
                        serviceOrderWithVehicle[index].toJson()
                    );

                    UsersVehiclesModel usersVehiclesModel = UsersVehiclesModel.fromJson(
                      seviceOrderWithVehicleModel.vehicleModel!
                    );

                    ServiceOrderModel serviceOrderModel = ServiceOrderModel.fromJson(
                      seviceOrderWithVehicleModel.serviceOrderModel!
                    );

                    return OrderBody(
                        itemCount: snapshot.data!.length,
                        data: serviceOrderModel,
                        vehicleModel: usersVehiclesModel,    
                    );
                  } ,
                );
                

              })
            ),
          ],
        )
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
              _status(data),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black
                ),
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
  Widget _status(ServiceOrderModel data) {

    Widget text = Text('');

    if(data.orderRecived == "Done") {
      text = const Text('Estatus: Orden recibida.');
    }

    if(data.beingPrePared == "Done"){
      text = const Text('Estatus: Persona del servicio preparado.');
    }

    if(data.onTheWay == "Done"){
      text = const Text('Estatus: En camino.');
    }

    if(data.deliverd == "Done"){
      text = const Text("Estatus: Servicio Completado.");
    }
    if (data.orderCancelled =="Done") {
      text = const Text("Estatus: Servicio Cancelado.");
    }

    return text;

  }
}
