import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/model/user_model.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/user_order_details.dart';
import 'package:oilappadmin/services/controls_order_service.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oilappadmin/screens/service_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ControlOrdersByUser extends StatefulWidget {
  final UserModel userModel;

  ControlOrdersByUser({required this.userModel});
  @override
  _ControlOrdersByUserState createState() => _ControlOrdersByUserState();
}

class _ControlOrdersByUserState extends State<ControlOrdersByUser> {
  final ControlsOrdersService controlsOrdersService = ControlsOrdersService();
  final ScrollController scrollController = ScrollController();
  int limit = 5;
  bool dataFinish = false;
  bool isLoading =  false;

  @override
  void initState() {
    super.initState();
    controlsOrdersService.getControlsOrders(limit: 5, userId: widget.userModel.uid!);
    scrollController.addListener(() async {
      
      if(scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent) {
        if(isLoading) return;
        if(dataFinish) return;
        
        isLoading = true;
        await Future.delayed(const Duration(seconds: 1));
        dataFinish = await controlsOrdersService.getControlsOrders(limit: limit, nextDocument: true, userId: widget.userModel.uid!);
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
        title: const Text("Ordenes de Producto"),
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
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder(
              
              stream: controlsOrdersService.suggestionStreamControlOrders,
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }

                if (snapshot.data!.isEmpty ) {
                  return const EmptyCardMessage(
                    listTitle: 'No hay Ordenes actualmente',
                    message: 'No hay Ordenes por lo momentos',
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black
                                ),  
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
              }),
            )
          ],
        ),
      ),
      
      
    );
  }
  
}
