import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/services/order_status_service.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UserOrderDetails extends StatefulWidget {
  final String? orderId;
  final String? addressId;

  const UserOrderDetails({Key? key, this.orderId, this.addressId})
      : super(key: key);
  @override
  _UserOrderDetailsState createState() => _UserOrderDetailsState();
}

class _UserOrderDetailsState extends State<UserOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Orden"),
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
        child: Container(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("orderHistory")
                    .where("orderHistoyId", isEqualTo: widget.orderId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return circularProgress();
                  }
                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.network(
                                (snapshot.data!.docs[index] as dynamic).data()['pImage'],
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (snapshot.data!.docs[index] as dynamic).data()['pName'],
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "\$" +
                                        (snapshot.data!.docs[index] as dynamic)
                                            .data()['newPrice']
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrangeAccent[200],
                                    ),
                                  )
                                ],
                              ),
                              trailing: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "✖",
                                      style: TextStyle(
                                        color: Colors.deepOrangeAccent[200],
                                      ),
                                    ),
                                    TextSpan(
                                      text: (snapshot.data!.docs[index] as dynamic)
                                          .data()['quantity']
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("useraddress")
                    .where("addressId", isEqualTo: widget.addressId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Container(
                          width: double.infinity,
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  const KeyText(msg: "Nombre del Cliente"),
                                  Text(
                                    (snapshot.data!.docs[index] as dynamic)
                                        .data()['customerName'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const KeyText(msg: "Teléfono"),
                                  Text(
                                    (snapshot.data!.docs[index] as dynamic)
                                        .data()['phoneNumber'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const KeyText(msg: "Ciudad"),
                                  Text(
                                    (snapshot.data!.docs[index] as dynamic).data()['city'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const KeyText(msg: "Area"),
                                  Text(
                                    (snapshot.data!.docs[index] as dynamic).data()['area'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const KeyText(msg: "Número de la casa"),
                                  Text(
                                    (snapshot.data!.docs[index] as dynamic)
                                        .data()['houseandroadno'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const KeyText(msg: "Código de Área"),
                                  Text(
                                    (snapshot.data!.docs[index] as dynamic)
                                        .data()['areacode'],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
             
             
             
              Card(
                elevation: 3,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Estatus de Orden",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.deepOrangeAccent[200],
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),


              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("orders")
                      .where("orderId", isEqualTo: widget.orderId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DateTime orderRecivedTime = ((snapshot.data!.docs[index] as dynamic)
                                  .data()['orderRecivedTime'])
                              .toDate();
                          DateTime beingPreParedTime = ( (snapshot
                                  .data!.docs[index] as dynamic)
                                  .data()['beingPreParedTime'])
                              .toDate();
                          DateTime onTheWayTime =
                              ((snapshot.data!.docs[index] as dynamic).data()['onTheWayTime'])
                                  .toDate();
                          DateTime deliverdTime =
                              ( (snapshot.data!.docs[index] as dynamic).data()['deliverdTime'])
                                  .toDate();
                          return Card(
                            elevation: 3,
                            child: Container(
                              height: 500,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            IconDoneOrNotDone(
                                              isdone: ((snapshot.data!.docs[index] as dynamic)
                                                              .data()[
                                                          'orderRecived'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            dividerBetweenDoneIcon(
                                              ((snapshot.data!.docs[index] as dynamic).data()[
                                                          'beingPrePared'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                              ((snapshot.data!.docs[index] as dynamic).data()[
                                                          'beingPrePared'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            IconDoneOrNotDone(
                                              isdone: ((snapshot.data!.docs[index] as dynamic)
                                                              .data()[
                                                          'beingPrePared'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            dividerBetweenDoneIcon(
                                              ((snapshot.data!.docs[index] as dynamic)
                                                          .data()['onTheWay'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                              ((snapshot.data!.docs[index] as dynamic)
                                                          .data()['onTheWay'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            IconDoneOrNotDone(
                                              isdone: ((snapshot.data!.docs[index] as dynamic)
                                                          .data()['onTheWay'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            dividerBetweenDoneIcon(
                                              ((snapshot.data!.docs[index] as dynamic)
                                                          .data()['deliverd'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                              ((snapshot.data!.docs[index] as dynamic)
                                                          .data()['deliverd'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            IconDoneOrNotDone(
                                              isdone: ((snapshot.data!.docs[index] as dynamic)
                                                          .data()['deliverd'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                          ],
                                        ),
                                       
                                       
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              OrderStatusCard(
                                                title: "Orden recibida",
                                                isPressed: ((snapshot.data
                                                                !.docs[index] as dynamic)
                                                                .data()[
                                                            'orderRecived'] ==
                                                        "Done")
                                                    ? true
                                                    : false,
                                                onPressed: () {
                                                  OrderStatusService()
                                                      .updateOrderRecived(
                                                    (snapshot.data!.docs[index] as dynamic)
                                                        .data()['orderId'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "Orden recibida");
                                                },
                                                time: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(orderRecivedTime),
                                              ),
                                              SizedBox(height: 15),
                                              OrderStatusCard(
                                                title: "Esta preparado",
                                                isPressed: ((snapshot.data!
                                                                .docs[index] as dynamic)
                                                                .data()[
                                                            'beingPrePared'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                                onPressed: () {
                                                  OrderStatusService()
                                                      .updateBeingPrePared(
                                                    (snapshot.data!.docs[index] as dynamic)
                                                        .data()['orderId'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "Esta preparado");
                                                },
                                                time: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(beingPreParedTime),
                                              ),
                                              SizedBox(height: 15),
                                              OrderStatusCard(
                                                title: "En camino",
                                                isPressed: ((snapshot.data
                                                                !.docs[index] as dynamic)
                                                                .data()[
                                                            'onTheWay'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                                onPressed: () {
                                                  OrderStatusService()
                                                      .updateOnTheWay(
                                                    (snapshot.data!.docs[index] as dynamic)
                                                        .data()['orderId'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "En Camino");
                                                },
                                                time: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(onTheWayTime),
                                              ),
                                              SizedBox(height: 15),
                                              OrderStatusCard(
                                                title: "Entregado",
                                                isPressed: ((snapshot.data!
                                                                .docs[index] as dynamic)
                                                                .data()[
                                                            'deliverd'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                                onPressed: () {
                                                  OrderStatusService()
                                                      .updateDeliverd(
                                                    (snapshot.data!.docs[index] as dynamic)
                                                        .data()['orderId'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "Entregado");
                                                },
                                                time: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(deliverdTime),
                                              ),
                                            ],
                                          ),
                                        ),
                                     
                                     
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      ((snapshot.data!.docs[index] as dynamic)
                                                  .data()['deliverd'] ==
                                              'Done')
                                          ? "¡¡Felicitaciones!!\nEl pedido ha sido entregado con éxito."
                                          : "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.deepOrangeAccent[200],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Container dividerBetweenDoneIcon(bool isdone, bool isPressed) {
    return Container(
      height: (isPressed) ? 55 : 80,
      width: 2,
      color: (isdone) ? Colors.deepOrangeAccent[200] : Colors.grey,
    );
  }
}

class IconDoneOrNotDone extends StatelessWidget {
  const IconDoneOrNotDone({
    this.isdone,
    Key? key,
  }) : super(key: key);
  final bool? isdone;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: CircleAvatar(
        backgroundColor: (isdone!) ? Colors.deepOrangeAccent[200] : Colors.grey,
        child: Icon(
          (isdone!) ? Icons.done : null,
          color: Colors.white,
        ),
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.time,
    this.isPressed,
  }) : super(key: key);
  final String title;
  final VoidCallback onPressed;
  final String time;

  final bool? isPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          (isPressed!)
              ? Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              : ElevatedButton(
                  /* color: Colors.deepOrangeAccent[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ), */
                  onPressed: onPressed,
                  child: Text(
                    "Hecho",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
          SizedBox(height: 10),
          Container(
            height: 3,
            width: double.infinity,
            color: Colors.blueGrey[50],
          ),
        ],
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String? msg;

  const KeyText({Key? key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg!,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
