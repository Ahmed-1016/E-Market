// ignore_for_file: file_names, avoid_unnecessary_containers, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/controllers/rating-controller.dart';
import 'package:first/models/product-model.dart';
import 'package:first/models/reviewModel.dart';
import 'package:first/screens/user-panel/cart-screen.dart';
import 'package:first/services/check-product-in-cart-services.dart';
import 'package:first/services/send-message-on-whatspp-services.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ProductDeatilsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDeatilsScreen({super.key, required this.productModel});

  @override
  State<ProductDeatilsScreen> createState() => _ProductDeatilsScreenState();
}

class _ProductDeatilsScreenState extends State<ProductDeatilsScreen> {
  User? user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    CalculateProductRatingController calculateProductRatingController = Get.put(
        CalculateProductRatingController(widget.productModel.productId));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 55),
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
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "تفاصيل المنتج",
          style: TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: Get.height / 50),
            CarouselSlider(
              items: widget.productModel.productImages
                  .map(
                    (imageUrls) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrls,
                        fit: BoxFit.cover,
                        width: Get.width - 20,
                        placeholder: (context, url) => ColoredBox(
                          color: Colors.white,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                aspectRatio: 2.5,
                viewportFraction: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "اسم المنتج: ${widget.productModel.productName}",
                            ),
                            Icon(Icons.favorite_outline)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Obx(
                            () => RatingBar.builder(
                              glow: false,
                              ignoreGestures: true,
                              initialRating: double.parse(
                                  calculateProductRatingController.averageRating
                                      .toString()),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 25,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {},
                            ),
                          ),
                          Obx(
                            () => Text(calculateProductRatingController
                                .averageRating
                                .toString()),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          children: [
                            widget.productModel.isSale == true &&
                                    widget.productModel.salePrice != ""
                                ? Text(
                                    "السعر: ${widget.productModel.salePrice}")
                                : Text(
                                    "السعر: ${widget.productModel.fullPrice}"),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              "اسم التصنيف: ${widget.productModel.categoryName}",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(
                          "وصف المنتج: ${widget.productModel.productDescription}",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            child: Container(
                              width: Get.width / 2.5,
                              height: Get.height / 15,
                              decoration: BoxDecoration(
                                color: AppConstant.appSecondaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton.icon(
                                onPressed: () {
                                  sendMessageOnWhatsApp(
                                      productModel: widget.productModel);
                                },
                                label: Text(
                                  "رسالة واتساب",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstant.appTextColor,
                                  ),
                                ),
                                icon: Icon(Icons.call),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Material(
                            child: Container(
                              width: Get.width / 3,
                              height: Get.height / 15,
                              decoration: BoxDecoration(
                                color: AppConstant.appSecondaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton.icon(
                                onPressed: () async {
                                  await checkProductExistence(
                                      uId: user!.uid,
                                      productModel: widget.productModel,
                                      context: context);
                                },
                                label: Text(
                                  "اضافة الى السلة",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstant.appTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(widget.productModel.productId)
                  .collection('reviews')
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    child: Text("لا يوجد تقييمات"),
                  );
                }
                if (snapshot.data != null) {
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        ReviewModel reviewModel = ReviewModel(
                            customerName: snapshot.data!.docs[i]
                                ['customerName'],
                            customerPhone: snapshot.data!.docs[i]
                                ['customerPhone'],
                            customerAddress: snapshot.data!.docs[i]
                                ['customerAddress'],
                            customerDeviceToken: snapshot.data!.docs[i]
                                ['customerDeviceToken'],
                            customerId: snapshot.data!.docs[i]['customerId'],
                            feadback: snapshot.data!.docs[i]['feadback'],
                            rating: snapshot.data!.docs[i]['rating'],
                            createdAt: snapshot.data!.docs[i]['createdAt']);

                        return Card(
                          elevation: 5.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(reviewModel.customerName[0]),
                            ),
                            title: Text(reviewModel.customerName),
                            subtitle: Text(reviewModel.feadback),
                            trailing: Text(reviewModel.rating),
                          ),
                        );
                      });
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
