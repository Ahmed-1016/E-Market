// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CalculateProductRatingController extends GetxController {
  final String productId;
  RxDouble averageRating = 0.0.obs;

  CalculateProductRatingController(this.productId);

  @override
  void onInit() {
    super.onInit();
    calculateAverageRating();
  }

  void calculateAverageRating() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .get();

    if (snapshot.docs.isNotEmpty) {
      double totalRating = 0;
      int numberOfReviews = 0;
      snapshot.docs.forEach((doc) {
        final ratingAsString = doc['rating'] as String;
        // Convert string rating to double
        final rating = double.tryParse(ratingAsString);
        if (rating != null) {
          totalRating += rating;
          numberOfReviews++;
        }
      });
      if (numberOfReviews != 0) {
        averageRating.value = totalRating / numberOfReviews;
      } else {
        averageRating.value = 0.0;
      }
    } else {
      averageRating.value = 0.0;
    }
  }

  @override
  void onClose() {
    // تنظيف أي موارد مثل إغلاق الـ streams أو الـ subscriptions
    super.onClose();
  }
}
