// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/controllers/cart-price-controller.dart';
import 'package:first/models/order-model.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
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
          "الطلبات",
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
            .collection("orders")
            .doc(user!.uid)
            .collection('confirmOrders')
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
              child: Text("لا يوجد طلبات"),
            );
          }
          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  OredrModel oredrModel = OredrModel(
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
                    customerId: snapshot.data!.docs[i]['customerId'],
                    status: snapshot.data!.docs[i]['status'],
                    customerName: snapshot.data!.docs[i]['customerName'],
                    customerPhone: snapshot.data!.docs[i]['customerPhone'],
                    customerAddress: snapshot.data!.docs[i]['customerAddress'],
                    customerDeviceToken: snapshot.data!.docs[i]
                        ['customerDeviceToken'],
                  );

                  cartPriceController.fetchProductPrice();
                  return Card(
                    elevation: 10,
                    color: AppConstant.appTextColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appMainColor,
                        backgroundImage:
                            NetworkImage(oredrModel.productImages[0]),
                        radius: 40,
                      ),
                      title: Text(oredrModel.productName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(oredrModel.productTotalPrice.toString()),
                          SizedBox(
                            width: 50.0,
                          ),
                          oredrModel.status != true
                              ? Text(
                                  "يتم التحضير",
                                  style: TextStyle(color: Colors.green),
                                )
                              : Text(
                                  "تم التسليم",
                                  style: TextStyle(color: Colors.red),
                                )
                        ],
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
    );
  }
}
