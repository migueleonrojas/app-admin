
import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/model/addresss.dart';
import 'package:oilappadmin/model/service_order_payment_details_model.dart';
import 'package:oilappadmin/model/users_vehicles_model.dart';
import 'package:oilappadmin/screens/editAddress.dart';
import 'package:oilappadmin/screens/main_screen.dart';

import 'package:oilappadmin/services/service_status_service.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserServiceDetails extends StatefulWidget {
  final UsersVehiclesModel usersVehiclesModel;
  final String? orderId;
  final String? addressId;
  final String idOrderPaymentDetails;

  const UserServiceDetails({Key? key, this.orderId, this.addressId, required this.usersVehiclesModel, required this.idOrderPaymentDetails})
      : super(key: key);
  @override
  _UserServiceDetailsState createState() => _UserServiceDetailsState();
}

class _UserServiceDetailsState extends State<UserServiceDetails> {

  GlobalKey<FormState> _intervalformkey = GlobalKey<FormState>();
  TextEditingController mileageController = TextEditingController();

  CameraPosition? cameraPosition;

  GoogleMapController? _controller;

  final Set<Marker> _markers = {};

  late DateTime currentUpdateDate = widget.usersVehiclesModel.updateDate!;

  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de la Orden"),
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
              SizedBox(height: 5,),
              Center(
                child: Text(
                  'ID de la orden:${widget.orderId}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                child: Card(
                  elevation: 3,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'datos del vehiculo'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Marca: ${widget.usersVehiclesModel.brand}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        Text(
                          'Modelo: ${widget.usersVehiclesModel.model}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        Text(
                          'Año: ${widget.usersVehiclesModel.year}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center ,
                          children: [
                            const Text(
                              'Color: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )
                            ),
                            Container(color: Color(widget.usersVehiclesModel.color!),child: const SizedBox(height: 10, width: 30,),)
                          ],
                        ),
                        Text(
                          'Kilometraje: ${widget.usersVehiclesModel.mileage}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        const SizedBox(height: 5,)
                      ],
                    )
                  
                )
              ),
              StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                .collection('serviceOrderPaymentDetails')
                .where('idOrderPaymentDetails', isEqualTo: widget.idOrderPaymentDetails)
                .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return circularProgress();
                  }
                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        ServiceOrderPaymentDetailsModel serviceOrderPaymentDetailsModel = ServiceOrderPaymentDetailsModel
                        .fromJson((snapshot.data!.docs[index] as dynamic).data(),);

                        return Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  'detalle del pago'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: size.height * 0.026,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.all(size.height * 0.012),
                                child: Column(
                                  children: [
                                    Text(
                                      serviceOrderPaymentDetailsModel.paymentMethod!,
                                      style: TextStyle(
                                        fontSize: size.height * 0.022,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    (serviceOrderPaymentDetailsModel.confirmationNumber != 0)
                                      ? Text(
                                        'Número de Confirmación: ${serviceOrderPaymentDetailsModel.confirmationNumber.toString()}',
                                        style: TextStyle(
                                          fontSize: size.height * 0.022,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                      : Container(),
                                      (serviceOrderPaymentDetailsModel.paymentMethod == "Zelle")
                                      ? Text(
                                        'Fecha del Pago: ${DateFormat('dd/MM/yyyy').format(serviceOrderPaymentDetailsModel.paymentDate!)}',
                                        style: TextStyle(
                                          fontSize: size.height * 0.022,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                      :Container(),
                                    (serviceOrderPaymentDetailsModel.issuerName != "")
                                      ?Text(
                                        'Nombre del Emisor: ${serviceOrderPaymentDetailsModel.issuerName.toString()}',
                                        style: TextStyle(
                                          fontSize: size.height * 0.022,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                      :Container(),
                                    (serviceOrderPaymentDetailsModel.issuerName != "")
                                      ?Text(
                                        'Nombre del Titular: ${serviceOrderPaymentDetailsModel.holderName.toString()}',
                                        style: TextStyle(
                                          fontSize: size.height * 0.022,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                      :Container(),
                                    (serviceOrderPaymentDetailsModel.observations != "")
                                      ?Text(                                        
                                        'Observaciones: ${serviceOrderPaymentDetailsModel.observations.toString()}',
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontSize: size.height * 0.022,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                      :Container(),
                                    

                                  ],
                                )
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid',isEqualTo: widget.usersVehiclesModel.userId)
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
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'datos del usuario'.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Text(
                                      'Nombre del Usuario: ${(snapshot.data!.docs[index] as dynamic)['name']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Text(
                                      'Email del Usuario: ${(snapshot.data!.docs[index] as dynamic)['email']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );

                } ,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("serviceOrder")
                    .where("orderId", isEqualTo: widget.orderId)
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
                                (snapshot.data!.docs[index] as dynamic)
                                    .data()['serviceImage'],
                                width: 80,
                                height: 80,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (snapshot.data!.docs[index] as dynamic)
                                        .data()['serviceName'],
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Date: " +
                                        (snapshot.data!.docs[index] as dynamic)
                                            .data()['date'],
                                    maxLines: 2,
                                    style: TextStyle(
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
                                  ),
                                  Text(
                                      'Observaciones: ${(snapshot.data!.docs[index] as dynamic)
                                        .data()['observations']
                                              .toString()}',
                                      maxLines: 5,
                                      style: const TextStyle(
                                        
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        
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
                                      style: TextStyle(
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
                      cameraPosition =  CameraPosition(
                        target: LatLng(
                          (snapshot.data!.docs[index].data() as dynamic )['latitude'],
                          (snapshot.data!.docs[index].data() as dynamic )['longitude']
                        ),
                        zoom: 18
                      );
                      _markers.add(
                        Marker(
                          markerId: const MarkerId('pin'),
                          position: cameraPosition!.target,
                          icon: BitmapDescriptor.defaultMarker,
                        )
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  'dirección de entrega'.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ) 
                              ),
                              SizedBox(height: 5,),
                              Table(
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
                                      const KeyText(msg: "Área"),
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
                              SizedBox(height: 5,),
                              Center(
                                child: Text(
                                  'ubicación en el mapa'.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ),
                              SizedBox(height: 5,),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.50,
                                child: GoogleMap(
                                  initialCameraPosition: cameraPosition!,
                                  onMapCreated: ((controller) {
                                  _controller = controller;
                                    setState(() {});
                                  }),
                                  markers: _markers,
                                ),
                              ),
                              SizedBox(height: 10,),
                              
                              ElevatedButton(
                                
                              onPressed: () async {
                                UserAddressModel addressModel = UserAddressModel.fromJson(
                                  (snapshot.data!.docs[index] as dynamic).data()
                                  
                                );
                                
                                Route route = MaterialPageRoute(
                                  builder: (_) => EditAddress(
                                    addressModelEdit: addressModel,
                                    userId: widget.usersVehiclesModel.userId!,
                                  ),
                                );
                                final newCameraPosition = await Navigator.push(context, route);
                                if(newCameraPosition == null) return;
                                cameraPosition =  CameraPosition(
                                  target: LatLng(
                                    newCameraPosition.target.latitude,
                                    newCameraPosition.target.longitude
                                  ),
                                  zoom: 18
                                );
                                await _controller!.animateCamera(
                                  CameraUpdate.newCameraPosition(cameraPosition!),
                                );
                                setState(() {});

                              }, 
                              child: const Text('Editar dirección')
                            )
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
                      "Estatus de la Orden",
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
                      .collection("serviceOrder")
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
                          DateTime beingPreParedTime = ((snapshot
                                  .data!.docs[index] as dynamic)
                                  .data()['beingPreParedTime'])
                              .toDate();
                          DateTime onTheWayTime =
                              ((snapshot.data!.docs[index] as dynamic).data()['onTheWayTime'])
                                  .toDate();
                          DateTime deliverdTime =
                              ((snapshot.data!.docs[index] as dynamic).data()['deliverdTime'])
                                  .toDate();

                          DateTime cancelledTime =
                            ((snapshot.data!.docs[index] as dynamic).data()['orderCancelledTime'])
                                .toDate();

                          return Column(
                            children: [
                              /* ElevatedButton(          
                                onPressed: () async {
                                  bool confirm = await _onBackPressed('De que quieres cancelar la orden');
                                  if(!confirm) return;
                                  if((snapshot.data!.docs[index] as dynamic)
                                                          .data()['deliverd'] =='Done') {
                                    Fluttertoast.showToast(
                                      toastLength: Toast.LENGTH_LONG,
                                      msg: "No puede cancelar una orden que ya ha sido entregado"
                                    );
                                    return;
                                  }
                                  await ServiceOrderStatusService().cancelledOrder((snapshot.data!.docs[index] as dynamic)
                                                            .data()['orderId']);
                                }, 
                                child: const Text('Cancelar Orden')
                              ), */
                              Card(
                                elevation: 3,
                                child: Container(
                                  height: 600,
                                  width: double.infinity,
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
                                              /* dividerBetweenDoneIcon(
                                                ((snapshot.data!.docs[index] as dynamic)
                                                            .data()['orderCancelled'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                                ((snapshot.data!.docs[index] as dynamic)
                                                            .data()['orderCancelled'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                              ), */
                                              /* IconDoneOrNotDone(
                                                isdone: ((snapshot.data!.docs[index] as dynamic)
                                                            .data()['orderCancelled'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                              ), */
                                              
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                OrderStatusCard(
                                                  title: "Orden Recibida",
                                                  isPressed: ((snapshot.data
                                                                  !.docs[index] as dynamic)
                                                                  .data()[
                                                              'orderRecived'] ==
                                                          "Done")
                                                      ? true
                                                      : false,
                                                  onPressed: () async {
                                                    bool confirm = await _onBackPressed('De que quieres cambiar el estatus de la orden');
                                                      if(!confirm) return;
                                                    if((snapshot.data!.docs[index] as dynamic)
                                                        .data()['orderCancelled'] =='Done') {
                                                      Fluttertoast.showToast(
                                                        toastLength: Toast.LENGTH_LONG,
                                                        msg: "No puede cambiar el estatus de una orden que esta cancelada"
                                                      );
                                                      return;
                                                    }
                                                    ServiceOrderStatusService()
                                                        .updateOrderRecived(
                                                      (snapshot.data!.docs[index] as dynamic)
                                                          .data()['orderId'],
                                                    );
                                                    Fluttertoast.showToast(
                                                        msg: "Orden Recibida");
                                                  },
                                                  time: DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(orderRecivedTime),
                                                ),
                                                SizedBox(height: 15),
                                                OrderStatusCard(
                                                  title: "Persona del servicio preparado",
                                                  isPressed: ((snapshot.data!
                                                                  .docs[index] as dynamic)
                                                                  .data()[
                                                              'beingPrePared'] ==
                                                          'Done')
                                                      ? true
                                                      : false,
                                                  onPressed: () async {
                                                    bool confirm = await _onBackPressed('De que quieres cambiar el estatus de la orden');
                                                      if(!confirm) return;
                                                    if((snapshot.data!.docs[index] as dynamic)
                                                        .data()['orderCancelled'] =='Done') {
                                                      
                                                      Fluttertoast.showToast(
                                                        toastLength: Toast.LENGTH_LONG,
                                                        msg: "No puede cambiar el estatus de una orden que esta cancelada"
                                                      );
                                                      return;
                                                    }
                                                    ServiceOrderStatusService()
                                                        .updateBeingPrePared(
                                                      (snapshot.data!.docs[index] as dynamic)
                                                          .data()['orderId'],
                                                    );
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Persona del servicio preparado");
                                                  },
                                                  time: DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(beingPreParedTime),
                                                ),
                                                SizedBox(height: 15),
                                                OrderStatusCard(
                                                  title: "En camino",
                                                  isPressed: ((snapshot.data!
                                                                  .docs[index] as dynamic)
                                                                  .data()[
                                                              'onTheWay'] ==
                                                          'Done')
                                                      ? true
                                                      : false,
                                                  onPressed: () async {
                                                    bool confirm = await _onBackPressed('De que quieres cambiar el estatus de la orden');
                                                      if(!confirm) return;
                                                    if((snapshot.data!.docs[index] as dynamic)
                                                        .data()['orderCancelled'] =='Done') {
                                                      Fluttertoast.showToast(
                                                        toastLength: Toast.LENGTH_LONG,
                                                        msg: "No puede cambiar el estatus de una orden que esta cancelada"
                                                      );
                                                      return;
                                                    }
                                                    ServiceOrderStatusService()
                                                        .updateOnTheWay(
                                                      (snapshot.data!.docs[index] as dynamic)
                                                          .data()['orderId'],
                                                    );
                                                    Fluttertoast.showToast(
                                                        msg: "En camino");
                                                  },
                                                  time: DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(onTheWayTime),
                                                ),
                                                SizedBox(height: 15),
                                                OrderStatusCard(
                                                  title: "Servicio Completado",
                                                  isPressed: ((snapshot.data!
                                                                  .docs[index] as dynamic)
                                                                  .data()[
                                                              'deliverd'] ==
                                                          'Done')
                                                      ? true
                                                      : false,
                                                  onPressed: () async {
                                                    bool confirm = await _onBackPressed('De que quieres cambiar el estatus de la orden');
                                                    if(!confirm) return;
                                                    if((snapshot.data!.docs[index] as dynamic)
                                                        .data()['orderCancelled'] =='Done') {
                                                      Fluttertoast.showToast(
                                                        toastLength: Toast.LENGTH_LONG,
                                                        msg: "No puede cambiar el estatus de una orden que esta cancelada"
                                                      );
                                                      return;
                                                    }
                                                    bool restartInterval = await _restartIntervalVehicle();
                                                    if(!restartInterval) return;
                                                    ServiceOrderStatusService()
                                                        .updateDeliverd(
                                                      (snapshot.data!.docs[index] as dynamic)
                                                          .data()['orderId'],
                                                    );
                                                    Fluttertoast.showToast(
                                                        msg: "Servicio Completado");
                                                  },
                                                  time: DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(deliverdTime),
                                                ),
                                                 SizedBox(height: 15),
                                                OrderStatusCard(
                                                  title: ((snapshot.data!
                                                                  .docs[index] as dynamic).data()[
                                                              'orderCancelled'] ==
                                                          'Done') ?"Servicio Cancelado":"¿Cancelar servicio?",
                                                  isPressed: ((snapshot.data!
                                                                  .docs[index] as dynamic)
                                                                  .data()[
                                                              'orderCancelled'] ==
                                                          'Done')
                                                      ? true
                                                      : false,
                                                  onPressed: () async {
                                  
                                  
                                                    bool confirm = await _onBackPressed('De que quieres cancelar la orden');
                                                    if(!confirm) return;
                                                    if((snapshot.data!.docs[index] as dynamic)
                                                        .data()['deliverd'] =='Done') {
                                                      Fluttertoast.showToast(
                                                        toastLength: Toast.LENGTH_LONG,
                                                        msg: "No puede cancelar una orden que ya ha sido entregado"
                                                      );
                                                      return;
                                                    }
                                                    await ServiceOrderStatusService().cancelledOrder((snapshot.data!.docs[index] as dynamic)
                                                                              .data()['orderId']);
                                                    Fluttertoast.showToast(
                                                        msg: "Servicio Cancelado");
                                                  },
                                                  time: DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(cancelledTime),
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
                                            ? "!!Felicitaciones!!\nEl servicio se completó con éxito."
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
                            ],
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _onBackPressed(String msg) async {
    return await showDialog(
          context: context,
          builder: (context) =>  AlertDialog(
            title:  Text('Estas seguro?'),
            content:  Text(msg),
            actions: <Widget>[
               GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("YES"),
                ),
              ),
              const SizedBox(height: 16),
               GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("NO"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ) ??
        false;
  }

  Future _restartIntervalVehicle() async {
    return await showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        title: Text('Indicar nuevo kilometraje'),
        content: Container(
          height: 70,
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: mileageController,
                  decoration: const InputDecoration(
                    hintText: "Ingrese el kilometraje actual del Vehiculo",
                  ),
                ),
              ],
            )
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              
              DateTime? lastDateCarNote;

              QuerySnapshot<Map<String, dynamic>> carNotesUserVehicles = await FirebaseFirestore.instance
                .collection('carNotesUserVehicles')
                .where('vehicleId',isEqualTo: widget.usersVehiclesModel.vehicleId)
                .where('serviceName', isEqualTo: 'Aceite con filtro')
                .orderBy('date',descending: false)                    
                .get();

              for(final carNotesUserVehicle in carNotesUserVehicles.docs){
                
                lastDateCarNote = carNotesUserVehicle.data()['date'].toDate();
      
              }
              
              if(lastDateCarNote == null){

                bool restartInterval =  await updateVehicle();
                if(restartInterval){
                  Navigator.of(context).pop(true);
                }
                else{
                  Navigator.of(context).pop(false);
                }

              }
              else {

                if(DateTime.now().compareTo(lastDateCarNote) > 0){

                  bool restartInterval =  await updateVehicle();
                  if(restartInterval){
                    Navigator.of(context).pop(true);
                  }
                  else{
                    Navigator.of(context).pop(false);
                  }

                }
                else {
                  Navigator.of(context).pop(true);
                }

              }

            },
            child: Text('Aceptar')
          ),
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            }, 
            child: Text('Cancelar')
          )
        ], 

      )
    )?? false;
  }

  Container dividerBetweenDoneIcon(bool isdone, bool isPressed) {
    return Container(
      height: (isPressed) ? 55 : 80,
      width: 2,
      color: (isdone) ? Colors.deepOrangeAccent[200] : Colors.grey,
    );
  }

  Future <bool> updateVehicle() async {

    final serviceOrder = await FirebaseFirestore.instance.collection(AutoParts.serviceOrder).doc(widget.orderId).get();

    if(mileageController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Indique un kilometraje");
      return false;
    }

    if(int.parse(mileageController.text) <=  widget.usersVehiclesModel.mileage!) {
      Fluttertoast.showToast(msg: "Indique un kilometraje mayor al actual");
      return false;
    }

    if((serviceOrder.data() as dynamic)['categoryName'] == "Cambio de Aceite"){
      currentUpdateDate = DateTime.now();
    }

    
    final model = UsersVehiclesModel(
      vehicleId: widget.usersVehiclesModel.vehicleId,
      userId: widget.usersVehiclesModel.userId,
      brand: widget.usersVehiclesModel.brand, 
      model: widget.usersVehiclesModel.model,
      mileage: int.parse(mileageController.text),
      year: widget.usersVehiclesModel.year,
      color: widget.usersVehiclesModel.color,
      name: widget.usersVehiclesModel.name,
      tuition: widget.usersVehiclesModel.tuition,
      logo: widget.usersVehiclesModel.logo,
      registrationDate: widget.usersVehiclesModel.registrationDate,
      updateDate: currentUpdateDate
    ).toJson();

    await FirebaseFirestore.instance
      .collection(AutoParts.collectionUser)
      .doc(widget.usersVehiclesModel.userId)
      .collection(AutoParts.vehicles)
      .doc(widget.usersVehiclesModel.vehicleId)
      .update(model)
      .whenComplete(() { 
        updateVehicleForAdmin();
      })
      .then((value) => {

      });
  
    return true;
  }

  updateVehicleForAdmin(){

    final model = UsersVehiclesModel(
      vehicleId: widget.usersVehiclesModel.vehicleId,
      userId: widget.usersVehiclesModel.userId,
      brand: widget.usersVehiclesModel.brand,
      model: widget.usersVehiclesModel.model,
      mileage: int.parse(mileageController.text),
      year: widget.usersVehiclesModel.year,
      color: widget.usersVehiclesModel.color,
      name: widget.usersVehiclesModel.name,
      tuition: widget.usersVehiclesModel.tuition,
      logo: widget.usersVehiclesModel.logo,
      registrationDate: widget.usersVehiclesModel.registrationDate,
      updateDate: currentUpdateDate
    ).toJson();

    FirebaseFirestore.instance.collection('usersVehicles')
      .doc(widget.usersVehiclesModel.vehicleId)
      .update(model);

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
            style: const TextStyle(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  ),
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
