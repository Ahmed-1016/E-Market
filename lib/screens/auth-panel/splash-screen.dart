// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:async'; // استيراد مكتبة المؤقتات


import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/controllers/get-user-data-controller.dart';
import 'package:first/screens/admin-panel/admin-main-screen.dart';
import 'package:first/screens/auth-panel/welcome-screen.dart'; // استيراد شاشة الترحيب
import 'package:first/screens/user-panel/user-main-screen.dart';
import 'package:first/utils/app-constant.dart'; // استيراد الثوابت من ملف app-constant
import 'package:flutter/material.dart'; // استيراد مكتبة Flutter لبناء واجهات المستخدم
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة
import 'package:lottie/lottie.dart'; // استيراد مكتبة Lottie لعرض الرسوم المتحركة

class SplashScreen extends StatefulWidget {
  // تعريف كلاس شاشة البداية
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState(); // إنشاء حالة الشاشة
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser; // تعريف متغير لحالة المستخدم
  @override
  void initState() {
    super.initState(); // استدعاء دالة التهيئة الأساسية
    Timer(
      Duration(seconds: 3), // تعيين مدة المؤقت إلى ثانيتين
      () {
        loggdin(context); // استدعاء دالة تسجيل الدخول
      },
    );
  }

  Future<void> loggdin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);

      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => AdminMainScreen());  // تحويل المستخدم إلى شاشة المسؤول
      } else {
        Get.offAll(() => UserMainScreen());       // تحويل المستخدم إلى شاشة المستخدم
      }
    } else {
      Get.offAll(() => WelcomeScreen());  // تحويل المستخدم إلى شاشة الترحيب
    }
  }  // دالة تسجيل الدخول

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor, // تعيين لون خلفية الشاشة
      appBar: AppBar(
        backgroundColor:
            AppConstant.appSecondaryColor, // تعيين لون خلفية شريط التطبيق
        elevation: 0, // تعيين ارتفاع شريط التطبيق
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: Get.width/2, // تعيين عرض الحاوية
                alignment: Alignment.center, // محاذاة المحتوى في المنتصف
                child: Image.asset(
                    'assets/images/tlogo.png'), // عرض الرسوم المتحركة
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0), // تعيين هامش سفلي
              width: Get.width, // تعيين عرض الحاوية
              alignment: Alignment.center, // محاذاة المحتوى في المنتصف
              child: Text(
                AppConstant.appPoweredBy, // نص "مدعوم من"
                style: TextStyle(
                    color: AppConstant.appTextColor, // تعيين لون النص
                    fontSize: 20, // تعيين حجم النص
                    fontWeight: FontWeight.bold), // تعيين وزن الخط
              ),
            )
          ],
        ),
      ),
    );
  }
}
