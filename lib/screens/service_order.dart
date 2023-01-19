import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/model/service_order_model.dart';
import 'package:oilappadmin/model/service_order_with_vehicles_model.dart';
import 'package:oilappadmin/model/users_vehicles_model.dart';
import 'package:oilappadmin/screens/user_service_details.dart';
import 'package:oilappadmin/services/services_order.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ServiceOrders extends StatefulWidget {
  @override
  _ServiceOrdersState createState() => _ServiceOrdersState();
}

class _ServiceOrdersState extends State<ServiceOrders> {
  final serviceOrdersService = ServiceOrdersService();
  final ScrollController scrollController = ScrollController();
  int limit = 5;
  bool dataFinish = false;
  bool isLoading =  false;
  @override
  void initState() {
    super.initState();
    
    serviceOrdersService.getServiceOrderWithVehicle(limit: 5);
    scrollController.addListener(() async {
      
      if(scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent) {
        if(isLoading) return;
        if(dataFinish) return;
        
        isLoading = true;
        await Future.delayed(const Duration(seconds: 1));
        dataFinish = await serviceOrdersService.getServiceOrderWithVehicle(limit: limit, nextDocument: true);
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
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder(
              stream: serviceOrdersService.suggestionStream,
              builder: ((context, snapshot) {
                if (snapshot.data == null) return Center(
                  child:  Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        child:  CircularProgressIndicator(),
                      ),
                    ],
                  ),
                );

                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final serviceOrderWithVehicle = snapshot.data!;

                    ServiceOrderWithVehicle seviceOrderWithVehicleModel = ServiceOrderWithVehicle.fromJson(
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
