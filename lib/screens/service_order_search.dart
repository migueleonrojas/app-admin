
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oilappadmin/model/service_order_model.dart';
import 'package:oilappadmin/model/service_order_with_vehicles_model.dart';
import 'package:oilappadmin/model/users_vehicles_model.dart';
import 'package:oilappadmin/screens/user_service_details.dart';
import 'package:oilappadmin/services/services_order_service.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
class ServiceOrderSearch extends SearchDelegate {

  @override
  String get searchFieldLabel => 'Buscar Ordenes de Servicio';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(
        icon: Icon( Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    
  }

  @override
  Widget buildResults(BuildContext context) {

    if(query.isEmpty) {
      return EmptyCardMessage(
        listTitle: 'No hay resultados',
        message: 'No hay resultados',
      );
    }

    ServiceOrdersService serviceOrdersService = ServiceOrdersService();

    serviceOrdersService.getSuggestionsByQuery({
      "useLimit":false,
      "orderId": query
    });

    return StreamBuilder(
      stream: serviceOrdersService.suggestionStreamServiceOrder,
      builder: (_, AsyncSnapshot snapshot){
        if( !snapshot.hasData ) return circularProgress();

        if(snapshot.data!.isEmpty){
          return const EmptyCardMessage(
            listTitle: 'No hay Ordenes actualmente',
            message: 'No hay Ordenes por lo momentos',
          );
        }

        return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,                
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  
                  final serviceOrderWithVehicle = snapshot.data[index];

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
                    itemCount: snapshot.data.length,
                    data: serviceOrderModel,
                    vehicleModel: usersVehiclesModel,    
                  );
                  
                },
        );

      }
    );


  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty) {
      return EmptyCardMessage(
        listTitle: 'No hay resultados',
        message: 'No hay resultados',
      );
    }

    ServiceOrdersService serviceOrdersService = ServiceOrdersService();
    if(query.isNotEmpty){
      serviceOrdersService.getSuggestionsByQuery({
      "useLimit":false,
      "orderId": query
    });
    }
    

    return StreamBuilder(
      stream: serviceOrdersService.suggestionStreamServiceOrder,
      builder: (_, AsyncSnapshot snapshot){
        if( !snapshot.hasData ) return circularProgress();

        if(snapshot.data!.isEmpty){
          return const EmptyCardMessage(
            listTitle: 'No hay Ordenes actualmente',
            message: 'No hay Ordenes por lo momentos',
          );
        }

        return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,                
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  
                  final serviceOrderWithVehicle = snapshot.data[index];

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
                    itemCount: snapshot.data.length,
                    data: serviceOrderModel,
                    vehicleModel: usersVehiclesModel,    
                  );
                  
                },
        );

      }
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