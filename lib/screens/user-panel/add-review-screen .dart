// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/models/order-model.dart';
import 'package:first/models/reviewModel.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewScreen extends StatefulWidget {
  final OrderModel orderModel;
  const AddReviewScreen({super.key, required this.orderModel});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  TextEditingController feadbackController = TextEditingController();
  double productRating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 55),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.appSecondaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "التقييمات",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("اضف تقييمك من فضلك"),
            SizedBox(
              height: 20.0,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                productRating = rating;
                setState(() {});
                print(productRating);
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("التعليقات"),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: feadbackController,
              decoration: InputDecoration(label: Text("اترك تعليقك هنا")),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  EasyLoading.show(status: "please wait...");
                  String feadback = feadbackController.text.trim();
                  User? user = FirebaseAuth.instance.currentUser;
                  ReviewModel reviewModel = ReviewModel(
                    customerName: widget.orderModel.customerName,
                    customerPhone: widget.orderModel.customerPhone,
                    customerAddress: widget.orderModel.customerAddress,
                    customerDeviceToken: widget.orderModel.customerDeviceToken,
                    customerId: widget.orderModel.customerId,
                    feadback: feadback,
                    rating: productRating.toString(),
                    createdAt: DateTime.now(),
                  );
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(widget.orderModel.productId)
                      .collection('reviews')
                      .doc(user!.uid)
                      .set(reviewModel.toMap());
                  EasyLoading.dismiss();
                },
                child: Text("ارسال"))
          ],
        ),
      ),
    );
  }
}
