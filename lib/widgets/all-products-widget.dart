// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/product-model.dart';
import 'package:first/screens/user-panel/product-deatils-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class AllProductsWidget extends StatelessWidget {
  const AllProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("products")
          .where('isSale', isEqualTo: false)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Get.height / 5,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No Product found"),
          );
        }
        if (snapshot.data != null) {
          return Container(
            height: Get.height / 5,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                ProductModel productModel = ProductModel(
                  productId: snapshot.data!.docs[i]['productId'],
                  categoryId: snapshot.data!.docs[i]['categoryId'],
                  productName: snapshot.data!.docs[i]['productName'],
                  categoryName: snapshot.data!.docs[i]['categoryName'],
                  salePrice: snapshot.data!.docs[i]['salePrice'],
                  fullPrice: snapshot.data!.docs[i]['fullPrice'],
                  productImages: snapshot.data!.docs[i]['productImages'],
                  deliveryTime: snapshot.data!.docs[i]['deliveryTime'],
                  isSale: snapshot.data!.docs[i]['isSale'],
                  productDescription: snapshot.data!.docs[i]
                      ['productDescription'],
                  createdAt: snapshot.data!.docs[i]['createdAt'],
                  updatedAt: snapshot.data!.docs[i]['updatedAt'],
                );
                return GestureDetector(
                  onTap: ()=>Get.to(()=>ProductDeatilsScreen(productModel:productModel)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 3.5,
                            heightImage: Get.height / 12,
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],
                            ),
                            title: Center(
                              child: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            footer: Center(
                                child: Text(
                                  "Price: "+" ${productModel.fullPrice}",
                                  style: TextStyle(
                                      fontSize: 15,
                                  )
                                ),
                              ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
