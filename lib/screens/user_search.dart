import 'package:oilappadmin/model/product_model.dart';
import 'package:oilappadmin/model/user_model.dart';
import 'package:oilappadmin/screens/edit_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/screens/edit_user.dart';
import 'package:oilappadmin/screens/main_screen.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  final searchUserController = TextEditingController();

  List _allUserResults = [];
  List _userResultList = [];
  List _usersFiltered = [];
  Future? userResultsLoaded;
  @override
  void initState() {
    searchUserController.addListener(_onUserSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchUserController.removeListener(_onUserSearchChanged);
    searchUserController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userResultsLoaded = getAllSearchUsersData();
  }

  _onUserSearchChanged() {
    searchUsersResultsList();
  }

  searchUsersResultsList() async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .orderBy("name", descending: true)
        .get();
    setState(() {
      _allUserResults = data.docs;
    });
    var showResult = [];
    if (searchUserController.text != "") {
      for (var userfromjson in _allUserResults) {
        String username = UserModel.fromSnaphot(userfromjson).name!.toLowerCase();
        String email = UserModel.fromSnaphot(userfromjson).email!.toLowerCase();
        String phone = UserModel.fromSnaphot(userfromjson).phone!.toLowerCase();
        String address = UserModel.fromSnaphot(userfromjson).address!.toLowerCase();

        if (username.contains(searchUserController.text.toLowerCase())) {
          showResult.add(userfromjson);
        }
        if (email.contains(searchUserController.text.toLowerCase())) {
          showResult.add(userfromjson);
        }
        if (phone.contains(searchUserController.text.toLowerCase().replaceFirst('0', ''))) {
          showResult.add(userfromjson);
        }
        if (address.contains(searchUserController.text.toLowerCase().replaceFirst('0', ''))) {
          showResult.add(userfromjson);
        }


      }
    } else {
      showResult = List.from(_allUserResults);
    }
    _userResultList = showResult;
    _usersFiltered = _userResultList;
  }

  getAllSearchUsersData() async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .orderBy("name", descending: true)
        .get();
    setState(() {
      _allUserResults = data.docs;
    });
    searchUsersResultsList();
    return "Completo";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          onChanged: (searchProductController) {
            setState(() {
              searchProductController;
            });
          },
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          controller: searchUserController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 0,
            ),
            hintText: 'Buscar Usuarios...',
            hintStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            // Route route = MaterialPageRoute(builder: (_) => Products());
            // Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              searchUserController.text = "";
            },
          ),
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
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 8.0,
            //     vertical: 10.0,
            //   ),
            //   child: Form(
            //     key: _formKey,
            //     child: TextFormField(
            //       autofocus: true,
            //       controller: searchProductController,
            //       decoration: InputDecoration(
            //         filled: true,
            //         fillColor: Color(0xFFF6F8F9),
            //         contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            //         hintText: 'Search in thousands of products',
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10.0)),
            //         prefixIcon: IconButton(
            //           icon: Icon(Icons.search),
            //           onPressed: () {},
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            Container(
              width: double.infinity,
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                crossAxisCount: 4,
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                itemCount: _usersFiltered.length,
                itemBuilder: (BuildContext context, int index) {
                  UserModel userModel = UserModel.fromSnaphot(_usersFiltered[index]);
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
          ],
        ),
      ),
    );
  }
}
