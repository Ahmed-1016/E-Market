// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/cart-model.dart';
import 'package:first/models/product-model.dart';
import 'package:flutter/material.dart';

Future<void> checkProductExistence({
  required ProductModel productModel,
  required String uId,
  int quantityIncrement = 1,
  required BuildContext context,
}) async {
  final DocumentReference documentReference = FirebaseFirestore.instance
      .collection("cart")
      .doc(uId)
      .collection('cartOrders')
      .doc(productModel.productId.toString());
  DocumentSnapshot snapshot = await documentReference.get();

  if (snapshot.exists) {
    int currentQuantity = snapshot['productQuantity'];
    int updatedQuantity = currentQuantity + quantityIncrement;
    double totalPrice = double.parse(productModel.isSale == true
            ? productModel.salePrice
            : productModel.fullPrice) *
        updatedQuantity;

    await documentReference.update({
      'productQuantity': updatedQuantity,
      'productTotalPrice': totalPrice,
    });
    print("تم اضافة المنتج مرة اخرى");
  } else {
    await FirebaseFirestore.instance.collection("cart").doc(uId).set(
      {
        'uId': uId,
        'createdAt': DateTime.now(),
      },
    );
    CartModel cartModel = CartModel(
      productId: productModel.productId,
      categoryId: productModel.categoryId,
      productName: productModel.productName,
      categoryName: productModel.categoryName,
      salePrice: productModel.salePrice,
      fullPrice: productModel.fullPrice,
      productImages: productModel.productImages,
      deliveryTime: productModel.deliveryTime,
      isSale: productModel.isSale,
      productDescription: productModel.productDescription,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      productQuantity: 1,
      productTotalPrice: double.parse(productModel.isSale == true
          ? productModel.salePrice
          : productModel.fullPrice),
    );
    await documentReference.set(cartModel.toMap());
    print("تم اضافة المنتج الى السلة");
  }
}
