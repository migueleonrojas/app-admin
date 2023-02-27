import 'package:oilappadmin/model/product_model.dart';
import 'package:oilappadmin/screens/edit_product.dart';
import 'package:oilappadmin/screens/main_screen.dart';
import 'package:oilappadmin/screens/product_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oilappadmin/widgets/emptycardmessage.dart';
import 'package:oilappadmin/widgets/loading_widget.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos los Productos"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
            /* Route route = MaterialPageRoute(builder: (_) => MainScreen(indexTab: 1,));
            Navigator.pushAndRemoveUntil(context, route, (route) => false); */
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search_outlined,
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (_) => ProductSearch());
              Navigator.push(context, route);
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return circularProgress();
                }

                if(snapshot.data!.docs.isEmpty) {
                  return const EmptyCardMessage(
                    listTitle: 'No hay productos',
                    message: 'No hay productos actualmente',
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
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        ProductModel productData =
                            ProductModel.fromJson((snapshot.data!.docs[index] as dynamic).data());
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => EditProduct(
                                  productModel: productData,
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
                                SizedBox(height: 5),
                                Image.network(
                                  productData.productImgUrl!,
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
                                        productData.productName!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.category_outlined,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              productData.categoryName!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.branding_watermark_outlined,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              productData.brandName!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      (productData.offervalue!.toInt() < 1)
                                          ? Text(
                                              "\$${productData.orginalprice}",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '\$${productData.newprice}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '\$${productData.orginalprice}',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                        '- ${productData.offervalue}%')
                                                  ],
                                                ),
                                              ],
                                            ),
                                      Text(
                                        productData.status!,
                                      ),
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
