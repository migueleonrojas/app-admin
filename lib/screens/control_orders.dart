import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/screens/user_order_details.dart';
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
  QuerySnapshot<Map<String, dynamic>>? _docSnapStream;
  int lengthCollection = 0;
  bool isLoading =  false;
  List listDocument = [];
  QuerySnapshot? collectionState;

  @override
  void initState() {
    super.initState();
    getDocuments();
    scrollController.addListener(() {
      if(scrollController.position.pixels + 500 > scrollController.position.maxScrollExtent){
        getDocumentsNext();
      }
      
    });
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
      body: 
      (listDocument.isNotEmpty)
      ? ListView.builder(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        itemCount: listDocument.length,
        itemBuilder: (context, index)  {
          DateTime myDateTime = (listDocument[index]['orderTime']).toDate();
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
                          text: listDocument[index]['orderId'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  (listDocument[index][AutoParts.productID].length > 1) 
                    ?Text(
                      "(" + (listDocument[index][AutoParts.productID].length -1).toString() +" elemento)",
                      style: const TextStyle(
                      color: Colors.grey,
                        fontSize: 16,
                      ),
                    )
                    :Text(
                      "(" +(listDocument[index][AutoParts.productID].length -1).toString() +" elemento)",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Precio Total: " + listDocument[index]['totalPrice'].toString() +" \$",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMd().add_jm().format(myDateTime),
                    ),
                    Text(timeago.format(DateTime.tryParse(listDocument[index]['orderTime'].toDate().toString())!).toString()),
                    ElevatedButton(
                      /* shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      ), */
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserOrderDetails(
                              orderId: listDocument[index]['orderId'],
                              addressId: listDocument[index]['addressID'],
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

        })
        :(listDocument.isNotEmpty)
          ? Center(
            child: circularProgress(),
          )
          : Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.blueGrey.shade300,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: const Center(
                  child: Text(
                    'No hay productos', 
                    style:TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Brand-Bold",),),
                ),
              )
            ],
          )
        ) 
      
    );
  }
    Future<void> getDocuments() async {
    int limit = 1;

    

    _docSnapStream = await AutoParts.firestore!
      .collection("orders")
      .orderBy("orderTime", descending: true)
      .get();

    lengthCollection = _docSnapStream!.docs.length;

    if(lengthCollection == 0) {
      return;
    }

    if(lengthCollection <= 4){
      limit = lengthCollection;
    }
    else if(lengthCollection > 4){
      limit = 5;
    }

    
    final collection =  AutoParts.firestore!
      .collection("orders")
      .orderBy("orderTime", descending: true)
      .limit(limit);

      fetchDocuments(collection);
  }
  fetchDocuments(Query collection){
    collection.get().then((values) {
      collectionState = values; 
      for(final value in values.docs){
        
        listDocument.add(value.data());
      }
      
      setState((){});
      
    
    });
  }
  Future<void> getDocumentsNext() async {
  
    if (isLoading) return;
    isLoading = true;
    await Future.delayed(const Duration(seconds: 1));

    int limit = 1;

    if(lengthCollection == listDocument.length){
      return;
    }
    if((lengthCollection - listDocument.length ) % 5 == 0){
      limit = 5;
    }
    else if((lengthCollection - listDocument.length ) % 5 != 0 && (lengthCollection - listDocument.length ) <= 5){
      limit = lengthCollection - listDocument.length;
    }
    
    // Get the last visible document
    final lastVisible = collectionState!.docs[collectionState!.docs.length-1];
    final collection = AutoParts.firestore!
      .collection("orders")
      .orderBy("orderTime", descending: true)
      .startAfterDocument(lastVisible)
      .limit(limit);

    fetchDocuments(collection);
    isLoading = false;
    if(scrollController.position.pixels + 100 <= scrollController.position.maxScrollExtent) return;
    scrollController.animateTo(
      scrollController.position.pixels + 120, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.fastOutSlowIn
    );

  }
}
