// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers

import 'package:first/controllers/google-sign-in-controller.dart'; // استيراد وحدة التحكم لتسجيل الدخول بواسطة جوجل
import 'package:first/screens/auth-panel/sign-in-screen.dart'; // استيراد شاشة تسجيل الدخول
import 'package:first/utils/app-constant.dart'; // استيراد الثوابت من ملف app-constant
import 'package:flutter/material.dart'; // استيراد مكتبة Flutter لبناء واجهات المستخدم
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة
import 'package:lottie/lottie.dart'; // استيراد مكتبة Lottie لعرض الرسوم المتحركة

class WelcomeScreen extends StatelessWidget {
  // تعريف كلاس شاشة الترحيب
  WelcomeScreen({super.key});
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController()); // حقن تحكم الوصول للجوجل

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0, // تعيين ارتفاع شريط التطبيق
          centerTitle: true, // تعيين عنوان شريط التطبيق في المنتصف
          backgroundColor:
              AppConstant.appSecondaryColor, // تعيين لون خلفية شريط التطبيق
          title: const Text(
            "Wecome to my app", // عنوان شريط التطبيق
            style: TextStyle(
                fontSize: 30, color: AppConstant.appTextColor), // تنسيق النص
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            
            
            mainAxisAlignment: MainAxisAlignment.start,
            // محاذاة العناصر في العمود إلى الأعلى
            children: [
              Container(
                width: 300,
                height: 300,
                child: Image.asset('assets/images/tlogo.png'),
              ), // عرض الرسوم المتحركة
              Container(
                margin: EdgeInsets.only(top: 20.0), // تعيين هامش علوي
                child: const Text(
                  "Ahmed", // نص الترحيب
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold), // تنسيق النص
                ),
              ),
              SizedBox(
                height: Get.height / 30, // إضافة مساحة عمودية
              ),
              Material(
                child: Container(
                  width: Get.width / 1.2, // تعيين عرض الحاوية
                  height: Get.height / 12, // تعيين ارتفاع الحاوية
                  decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor, // تعيين لون الخلفية
                      borderRadius:
                          BorderRadius.circular(40)), // تعيين نصف قطر الزوايا
                  child: TextButton.icon(
                    onPressed: () {
                      _googleSignInController
                          .signInWithGoogle(); // تسجيل الدخول بواسطة جوجل
                    },
                    icon:
                        Image.asset('assets/images/google.png'), // أيقونة جوجل
                    label: Text(
                      "sign in with google", // نص الزر
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appTextColor), // تنسيق النص
                      textAlign: TextAlign.center, // محاذاة النص في المنتصف
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 50, // إضافة مساحة عمودية
              ),
              Material(
                child: Container(
                  width: Get.width / 1.2, // تعيين عرض الحاوية
                  height: Get.height / 12, // تعيين ارتفاع الحاوية
                  decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor, // تعيين لون الخلفية
                      borderRadius:
                          BorderRadius.circular(40)), // تعيين نصف قطر الزوايا
                  child: TextButton.icon(
                    onPressed: () {
                      Get.to(() =>
                          SigninScreen()); // الانتقال الى صفحة تسجيل الدخول
                    },
                    icon: Image.asset(
                        "assets/images/mail.png"), // أيقونة البريد الإلكتروني
                    label: Text(
                      "sign in with e-mail", // نص الزر
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appTextColor), // تنسيق النص
                      textAlign: TextAlign.center, // محاذاة النص في المنتصف
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
