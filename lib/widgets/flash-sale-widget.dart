// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/product-model.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("products")
          .where('isSale', isEqualTo: true)
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
                return Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 3.5,
                            heightImage: Get.height / 12,
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages,
                            ),
                            title: Center(
                              child: Text(
                                productModel.categoryName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            footer: Row(children: [
                              Text(
                                "Rs ${productModel.salePrice}",
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(width: 2.0),
                              Text(
                                " ${productModel.fullPrice}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppConstant.appSecondaryColor,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ])),
                      ),
                    )
                  ],
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
