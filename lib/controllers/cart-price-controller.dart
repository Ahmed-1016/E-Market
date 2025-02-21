// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPriceController extends GetxController {
  RxDouble totalPrice = 0.0.obs;
  int checkcart = 0;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    fetchProductPrice();
    super.onInit();
  }

  void fetchProductPrice() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    double sum = 0.0;
    int quantity = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data != null && data.containsKey('productTotalPrice')) {
        sum += (data['productTotalPrice'] as num).toDouble();
        quantity = (data['productQuantity'] as num).toInt();
      }
    }
    totalPrice.value = sum;
    debugPrint('totalPrice.value: ${totalPrice.value}');
    checkcart = quantity;
    debugPrint('checkcart: $checkcart');
  }
}
