// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/controllers/cart-price-controller.dart';
import 'package:first/models/cart-model.dart';
import 'package:first/screens/user-panel/checkout-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final CartPriceController cartPriceController =
      Get.put(CartPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.appSecondaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "عربة التسوق",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("cart")
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
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
              child: Text("No Products found"),
            );
          }
          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  CartModel cartModel = CartModel(
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
                    productQuantity: snapshot.data!.docs[i]['productQuantity'],
                    productTotalPrice: snapshot.data!.docs[i]
                        ['productTotalPrice'],
                  );

                  cartPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          await FirebaseFirestore.instance
                              .collection("cart")
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .delete();
                          cartPriceController.fetchProductPrice();
                        },
                      )
                    ],
                    child: Card(
                      elevation: 10,
                      color: AppConstant.appTextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appMainColor,
                          backgroundImage:
                              NetworkImage(cartModel.productImages[0]),
                          radius: 40,
                        ),
                        title: Text(cartModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(cartModel.productTotalPrice.toString()),
                            SizedBox(width: Get.width / 20.0),
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuantity > 1) {
                                  await FirebaseFirestore.instance
                                      .collection("cart")
                                      .doc(user!.uid)
                                      .collection('cartOrders')
                                      .doc(cartModel.productId)
                                      .update({
                                    "productQuantity":
                                        cartModel.productQuantity - 1,
                                    "productTotalPrice": double.parse(
                                            cartModel.isSale == true
                                                ? cartModel.salePrice
                                                : cartModel.fullPrice) *
                                        (cartModel.productQuantity - 1),
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: AppConstant.appMainColor,
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width / 20),
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuantity > 0) {
                                  await FirebaseFirestore.instance
                                      .collection("cart")
                                      .doc(user!.uid)
                                      .collection('cartOrders')
                                      .doc(cartModel.productId)
                                      .update({
                                    "productQuantity":
                                        cartModel.productQuantity + 1,
                                    "productTotalPrice": double.parse(
                                            cartModel.isSale == true
                                                ? cartModel.salePrice
                                                : cartModel.fullPrice) *
                                        (cartModel.productQuantity + 1),
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: AppConstant.appMainColor,
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width / 50),
                            Text(
                              "Q: ${cartModel.productQuantity.toString()}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 8.0, right: 8.0, bottom: 100.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  "Total Price: ${cartPriceController.totalPrice.value.toStringAsFixed(1)} EGP ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Material(
                child: Container(
                  width: Get.width / 3,
                  height: Get.height / 15,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: ()  {
                      if (cartPriceController.checkcart >0) {
                        
                    
                        Get.to(() => CheckOutScreen());
                        }else{
                          Get.snackbar(
                                        "انتبه", "لاتوجد منتجات",
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor:
                                            AppConstant.appSecondaryColor,
                                        colorText: AppConstant.appTextColor);
                        }
                    },
                    child: Text(
                      "checkout",
                      style: TextStyle(
                        fontSize: 16,
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
      ),
    );
  }
}
