// ignore_for_file: avoid_print, file_names, implementation_imports

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/screens/user-panel/my-home-page-screen.dart';
import 'package:first/models/order-model.dart';
import 'package:first/services/generate-order-id-services.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken,
}) async {
  User? user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "برجاء الانتظار");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
        String orderId = generateOrderId();
        OredrModel cartModel = OredrModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );
        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerDeviceToken': customerDeviceToken,
              'orderStatus': false,
              'createAt': DateTime.now()
            },
          );
          //upload orders
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());

          //delet cart products
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print('حذف المنتج من السلة $cartModel.productId.toString()');
          });
        }
      }
      print("تم تأكيد الطلب");
      Get.snackbar(
        "Order Confirmed",
        "تم تأكيد الطلب",
        backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
        duration: Duration(seconds: 5),
      );
      EasyLoading.dismiss();
      Get.offAll(() => MyHomePage());
    } catch (e) {
      print("Error $e");
    }
  }
}
