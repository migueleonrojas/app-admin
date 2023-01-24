import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/screens/user_order_details.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/screens/service_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ControlOrders extends StatefulWidget {
  @override
  _ControlOrdersState createState() => _ControlOrdersState();
}

class _ControlOrdersState extends State<ControlOrders> {
  final ScrollController scrollController = ScrollController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ordenes de Producto"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        /* actions: [
           IconButton(
            icon: Image.asset(
              "assets/authenticaiton/service.png",
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ServiceOrders()));
            },
          ),
          SizedBox(width: 10),
        ], */
      ),

      body: FutureBuilder(
        future: getControlOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          if(snapshot.data!.isEmpty) {
            return const EmptyCardMessage(
              listTitle: 'No hay pedidos',
              message: 'No hay pedidos actualmente',
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index)  {
              DateTime myDateTime = (snapshot.data as dynamic)[index]['orderTime'].toDate();
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                              text: (snapshot.data as dynamic)[index]['orderId'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ((snapshot.data as dynamic)[index][AutoParts.productID].length > 1) 
                        ?Text(
                          "(" + ((snapshot.data as dynamic)[index][AutoParts.productID].length -1).toString() +" elemento)",
                          style: const TextStyle(
                          color: Colors.grey,
                            fontSize: 16,
                          ),
                        )
                        :Text(
                          "(" +((snapshot.data as dynamic)[index][AutoParts.productID].length -1).toString() +" elemento)",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Precio Total: " + (snapshot.data as dynamic)[index]['totalPrice'].toString() +" \$",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd().add_jm().format(myDateTime),
                        ),
                        Text(timeago.format(DateTime.tryParse((snapshot.data as dynamic)[index]['orderTime'].toDate().toString())!).toString()),
                        ElevatedButton(
                          /* shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          ), */
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserOrderDetails(
                                  orderId: (snapshot.data as dynamic)[index]['orderId'],
                                  addressId: (snapshot.data as dynamic)[index]['addressID'],
                                ),
                              ),
                            );
                          },
                          /* color: Colors.deepOrangeAccent[200], */
                          child: const Text(
                            "Detalle de la Orden",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );

            }
          );

        },
      ),
      
    );
  }


    Future <List<Map<String,dynamic>>> getControlOrders() async {

      List <Map<String,dynamic>> listControlOrders = [];

      QuerySnapshot<Map<String, dynamic>> controlOrders = await AutoParts.firestore!
      .collection("orders")
      .orderBy("orderTime", descending: true)
      .get();

      for(final controlOrder in controlOrders.docs) {

        listControlOrders.add(controlOrder.data());

      }

      return listControlOrders;

    }
  
}
