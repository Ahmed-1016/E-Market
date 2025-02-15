// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة

import '../utils/app-constant.dart'; // استيراد الثوابت من ملف app-constant

class GetDeviceTokenController extends GetxController { // تعريف كلاس وحدة التحكم للحصول على رمز الجهاز

  String? deviceToken; // تعريف متغير لتخزين رمز الجهاز

  @override
  void onInit() { // دالة تهيئة وحدة التحكم
    super.onInit(); // استدعاء دالة التهيئة الأساسية
    getDeviceToken(); // استدعاء دالة الحصول على رمز الجهاز
  }

  Future<void> getDeviceToken() async { // تعريف دالة للحصول على رمز الجهاز
    try {
      String? token = await FirebaseMessaging.instance.getToken(); // محاولة الحصول على رمز الجهاز
      if (token != null) { // التحقق من أن الرمز غير فارغ
        deviceToken = token; // تعيين رمز الجهاز
        update(); // تحديث الحالة
      }
    } catch (e) { // التعامل مع الأخطاء
      Get.snackbar(
        'Error', // عنوان الرسالة
        "$e", // محتوى الرسالة
        snackPosition: SnackPosition.BOTTOM, // موضع الرسالة
        backgroundColor: AppConstant.appSecondaryColor, // لون خلفية الرسالة
        colorText: AppConstant.appTextColor, // لون نص الرسالة
      );
    }
  }
}