// ignore_for_file: unused_field, body_might_complete_normally_nullable, file_names

import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firestore للتعامل مع قاعدة البيانات
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Authentication للتعامل مع تسجيل الدخول
import 'package:first/utils/app-constant.dart'; // استيراد الثوابت من ملف app-constant
import 'package:flutter_easyloading/flutter_easyloading.dart'; // استيراد مكتبة EasyLoading لعرض الرسائل التحميل
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة

class SignInController extends GetxController { // تعريف كلاس وحدة التحكم لتسجيل الدخول
  final FirebaseAuth _auth = FirebaseAuth.instance; // إنشاء كائن FirebaseAuth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // إنشاء كائن FirebaseFirestore

  //for password visibility
  var isPasswordVisible = true.obs; // تعريف متغير لمراقبة حالة رؤية كلمة المرور

  Future<UserCredential?> signInMethod( // تعريف دالة لتسجيل الدخول
    String useremail, // البريد الإلكتروني للمستخدم
    String userpassword, // كلمة مرور المستخدم
  ) async {
    try {
      EasyLoading.show(status: "please wait..."); // عرض رسالة "please wait..." أثناء التحميل
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: useremail, // تعيين البريد الإلكتروني
        password: userpassword, // تعيين كلمة المرور
      );

      EasyLoading.dismiss(); // إخفاء رسالة التحميل
      return userCredential; // إرجاع بيانات المستخدم الذي تم تسجيل دخوله
    } on FirebaseAuthException catch (e) { // التعامل مع أخطاء Firebase Authentication
      EasyLoading.dismiss(); // إخفاء رسالة التحميل في حالة حدوث خطأ
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
