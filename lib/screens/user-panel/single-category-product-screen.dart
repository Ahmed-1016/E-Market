// ignore_for_file: must_be_immutable, file_names, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/product-model.dart';
import 'package:first/screens/user-panel/cart-screen.dart';
import 'package:first/screens/user-panel/product-deatils-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class SingleCategoryProductScreen extends StatefulWidget {
  final String categoryId;
  const SingleCategoryProductScreen({super.key, required this.categoryId});

  @override
  State<SingleCategoryProductScreen> createState() =>
      _SingleCategoryProductScreenState();
}

class _SingleCategoryProductScreenState
    extends State<SingleCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppConstant.appSecondaryColor,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "المنتجات",
          style: TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("products")
            .where('categoryId', isEqualTo: widget.categoryId)
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
              child: Text("لم يتم اضافة منتجات"),
            );
          }
          if (snapshot.data != null) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 1.19,
              ),
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
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
                  onTap: () => Get.to(
                      () => ProductDeatilsScreen(productModel: productModel)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 10.0,
                            width: Get.width / 2.2,
                            heightImage: Get.height / 12,
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],
                            ),
                            title: Center(
                              child: Text(
                                productModel.productName,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            footer: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  productModel.isSale == true &&
                                          productModel.salePrice != ""
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "السعر:  ${productModel.salePrice}",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            SizedBox(width: 2.0),
                                            Text(
                                              " ${productModel.fullPrice}",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppConstant
                                                      .appSecondaryColor,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "السعر: ${productModel.fullPrice}",
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
