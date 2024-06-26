import 'package:oilappadmin/model/service_model.dart';
import 'package:oilappadmin/model/user_model.dart';
import 'package:oilappadmin/screens/edit_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_user.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/product_search.dart';
import 'package:oilappadmin/screens/user_search.dart';
import 'package:oilappadmin/services/users_services.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {

  final UsersService usersService = UsersService();
  final ScrollController scrollController = ScrollController();
  int limit = 5;
  bool dataFinish = false;
  bool isLoading =  false;

  @override
  void initState() {
    super.initState();
    usersService.getUsers(limit: 10);
    scrollController.addListener(() async {
      
      if(scrollController.position.pixels + 200 > scrollController.position.maxScrollExtent) {
        if(isLoading) return;
        if(dataFinish) return;
        
        isLoading = true;
        await Future.delayed(const Duration(seconds: 1));
        dataFinish = await usersService.getUsers(limit: limit, nextDocument: true);
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
        title: const Text("Todos los Usuarios"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => MainScreen()));
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
          ),
          IconButton(
            icon: const Icon(
              Icons.search_outlined,
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (_) => UserSearch());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: usersService.suggestionStreamUsers,
              builder: (context, snapshot) {
                
                if (!snapshot.hasData) {
                  return circularProgress();
                }

                if (snapshot.data!.isEmpty) {
                  return const EmptyCardMessage(
                    listTitle: 'No hay usuarios actualmente',
                    message: 'No hay usuarios por lo momentos',
                  );
                }


                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 4,
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(2),
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModel userModel = UserModel.fromJson(
                            (snapshot.data![index] as dynamic));
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => EditUser(
                                  userModel: userModel,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Image.network(
                                  userModel.url!,
                                  width: double.infinity,
                                  height: 120,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userModel.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              userModel.email!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
