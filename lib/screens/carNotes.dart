import 'package:oilappadmin/Helper/dashboard.dart';
import 'package:oilappadmin/Helper/manage.dart';
import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/user_model.dart';
import 'package:oilappadmin/model/vehicle_model.dart';
import 'package:oilappadmin/screens/edit_car_notes.dart';
import 'package:oilappadmin/screens/edit_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_vehicle.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/services/carNotes_service.dart';
import 'package:oilappadmin/services/vehicles_service.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';

class CarNotes extends StatefulWidget {

  final VehicleModel? vehicleModel;
  final UserModel? userModel;
  CarNotes({required this.vehicleModel, this.userModel});
  @override
  _CarNotesState createState() => _CarNotesState();
}

class _CarNotesState extends State<CarNotes> {
  List <VehicleModel>? usersVehicles = [];
  List <Map<String,dynamic>> listAttachments = [];

  final CarNoteService carNoteService = CarNoteService();
  final ScrollController scrollController = ScrollController();
  int limit = 5;
  bool dataFinish = false;
  bool isLoading =  false;
  bool attachmentsLoaded = false;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, () async {

      await getListAttachments();
      if(mounted){
        setState(() {});
      }
      
    });
    
    carNoteService.getCarNotes(limit: 10, vehicleId: widget.vehicleModel!.vehicleId!);
    scrollController.addListener(() async {
      
      if(scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent) {
        if(isLoading) return;
        if(dataFinish) return;
        
        isLoading = true;
        await Future.delayed(const Duration(seconds: 1));
        dataFinish = await carNoteService.getCarNotes(limit: limit, nextDocument: true, vehicleId: widget.vehicleModel!.vehicleId!);
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas de Servicio"),
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
        controller: scrollController,
        child: Column(
          children: [
            StreamBuilder(
              stream: carNoteService.suggestionStreamCarNotes,
              /* stream: AutoParts.firestore!
              .collection('usersVehicles')
              .snapshots(), */
          
              /* stream: FirebaseFirestore.instance
                  .collection('vehicles')
                  .orderBy("registrationDate", descending: true)
                  .snapshots(), */
              builder: (context, snapshot) {
                
                if (!snapshot.hasData) {
                  return circularProgress();
                }

                

                if (snapshot.data!.isEmpty) {
                  return const EmptyCardMessage(
                    listTitle: 'No hay notas de servicio',
                    message: 'No hay notas de servicio',
                  );
                }
                
                return 
                listAttachments.isEmpty
                ? circularProgress()
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder:  (context, index) {
                    
                    return ListTile(
                      leading: FadeInImage(
                        placeholder: const AssetImage('assets/no-image/no-image.jpg'),
                        image: NetworkImage((snapshot.data![index] as dynamic)["serviceImage"]),
                        width: size.width * 0.07,
                        fit:BoxFit.contain
                      ),
                      title: Text((snapshot.data![index] as dynamic)["serviceName"]),
                      onTap: () async {
                        
                        VehicleModel? userVehicleReturned;
                        List listAttachmentsReturned = [];
                        for(final listAttachment in listAttachments) {
                         if(listAttachment["carNoteId"] == (snapshot.data![index] as dynamic)["carNoteId"] ){
                          listAttachmentsReturned.add(listAttachment["urlImg"]);
                         }
                        }
                        
                        if(widget.vehicleModel == null) {

                          for(final userVehicle in usersVehicles!){
                            if(userVehicle.vehicleId == (snapshot.data![index] as dynamic)["vehicleId"]){
                              userVehicleReturned = userVehicle;
                            }
                          }

                        }
                        if(listAttachments.isEmpty) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) =>  EditCarNote(
                              noteCar: {
                                "image":(snapshot.data![index] as dynamic)["serviceImage"],
                                "name":(snapshot.data![index] as dynamic)["serviceName"],
                                "date":(snapshot.data![index] as dynamic)["date"],
                                "comments":(snapshot.data![index] as dynamic)["comments"],
                                "carNoteId":(snapshot.data![index] as dynamic)["carNoteId"],
                                "mileage":(snapshot.data![index] as dynamic)["mileage"] 
                              }, 
                              vehicleModel: widget.vehicleModel!,
                              attachmentsFromDB: listAttachmentsReturned,
                              userModel: widget.userModel,
                              
                            )
                          ),
                        );
                      },
                    );
                  });
                
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  getUserVehicle() async {

    QuerySnapshot<Map<String, dynamic>> docUsersVehicles = await FirebaseFirestore.instance
      .collection('usersVehicles')
      .where('userId',isEqualTo: widget.userModel!.uid)
      .get();

    for(final docUserVehicle in docUsersVehicles.docs) {

      usersVehicles!.add(VehicleModel.fromJson(docUserVehicle.data()));
    }
    
  }

  getListAttachments() async {
    QuerySnapshot<Map<String, dynamic>> carNotesUsers = await FirebaseFirestore.instance
      .collection("carNotesUserVehicles")
      .where('userId',isEqualTo: widget.userModel!.uid)
      .get();
    QuerySnapshot<Map<String, dynamic>>? attachmentsDocs;

    

    for(final carNotesUser in carNotesUsers.docs) {

      QuerySnapshot<Map<String, dynamic>> attachmentsDocs = await carNotesUser.reference
        .collection("attachmentsCarNotesUsers")
        .where('userId',isEqualTo: widget.userModel!.uid).get();
      
      
      for(final attachmentsDoc in attachmentsDocs.docs){

        listAttachments.add(attachmentsDoc.data());
      }

    }
    attachmentsLoaded = true;

    
    
  }
}
