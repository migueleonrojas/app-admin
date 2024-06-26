import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceOrderStatusService {
  Future updateOrderRecived(String orderId) async {
    await FirebaseFirestore.instance.collection("serviceOrder").doc(orderId).update({
      "orderRecived": "Done",
      "orderRecivedTime": DateTime.now(),
    });
  }

  Future updateBeingPrePared(String orderId) async {
    await FirebaseFirestore.instance.collection("serviceOrder").doc(orderId).update({
      "beingPrePared": "Done",
      "beingPreParedTime": DateTime.now(),
    });
  }

  Future updateOnTheWay(String orderId) async {
    await FirebaseFirestore.instance.collection("serviceOrder").doc(orderId).update({
      "onTheWay": "Done",
      "onTheWayTime": DateTime.now(),
    });
  }

  Future updateDeliverd(String orderId) async {
    await FirebaseFirestore.instance.collection("serviceOrder").doc(orderId).update({
      "deliverd": "Done",
      "deliverdTime": DateTime.now(),
    });
  }

  Future cancelledOrder(String orderId) async {
    await FirebaseFirestore.instance.collection("serviceOrder").doc(orderId).update({
      "orderCancelled": "Done",
      "orderCancelledTime": DateTime.now(),
    });
  }
}
