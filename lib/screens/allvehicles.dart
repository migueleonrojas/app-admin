import 'package:oilappadmin/Helper/dashboard.dart';
import 'package:oilappadmin/Helper/manage.dart';
import 'package:oilappadmin/config/config.dart';
import 'package:oilappadmin/screens/motorcycles.dart';
import 'package:oilappadmin/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:oilappadmin/screens/vehicles.dart';

class AllVehicles extends StatefulWidget {
  final int? indexTab;
  AllVehicles({this.indexTab});

  @override
  _AllVehiclesState createState() => _AllVehiclesState();
}

class _AllVehiclesState extends State<AllVehicles>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.index =  widget.indexTab ?? 0;
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        title: const Text(
          "Vehiculos",
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: "Brand-Regular",
          ),
        ),
        centerTitle: true,
        actions: [
          /* IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              bool confirm = await _onBackPressed("De que quiere salir");
              if(!confirm) return;
              AutoParts.auth!.signOut().then((c) {
                Route route =
                    MaterialPageRoute(builder: (_) => SplashScreen());
                /* Navigator.pushReplacement(context, route); */
                Navigator.pushAndRemoveUntil(context, route, (route) => false);
                
              });
            },
          ), */
        ],
        bottom: TabBar(
          unselectedLabelColor: Colors.black12,
          labelColor: Colors.black,
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dashboard_customize),
                  SizedBox(width: 5),
                  Text(
                    "Carros",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.filter_frames),
                  SizedBox(width: 5),
                  Text(
                    "Motos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Vehicles(),
          Motorcycles(),
        ],
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("YES"),
                ),
              ),
              SizedBox(height: 16),
               GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("NO"),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ) ??
        false;
  }
}
