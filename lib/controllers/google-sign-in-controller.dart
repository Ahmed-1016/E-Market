// ignore_for_file: file_names, unused_local_variable, unused_field, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firestore للتعامل مع قاعدة البيانات
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Authentication للتعامل مع تسجيل الدخول
import 'package:first/controllers/get-device-token-controller.dart'; // استيراد وحدة التحكم للحصول على رمز الجهاز
import 'package:first/screens/user-panel/my-home-page-screen.dart';
import 'package:first/models/user-model.dart'; // استيراد نموذج بيانات المستخدم
import 'package:flutter_easyloading/flutter_easyloading.dart'; // استيراد مكتبة EasyLoading لعرض الرسائل التحميل
import 'package:get/get.dart'; // استيراد مكتبة GetX لإدارة الحالة
import 'package:google_sign_in/google_sign_in.dart'; // استيراد مكتبة Google Sign-In لتسجيل الدخول باستخدام Google

class GoogleSignInController extends GetxController {
  // تعريف كلاس وحدة التحكم لتسجيل الدخول باستخدام Google
  final GoogleSignIn googleSignIn = GoogleSignIn(); // إنشاء كائن GoogleSignIn
  final FirebaseAuth _auth = FirebaseAuth.instance; // إنشاء كائن FirebaseAuth

  Future<void> signInWithGoogle() async {
    // تعريف دالة لتسجيل الدخول باستخدام Google
    final GetDeviceTokenController getDeviceTokenController = Get.put(
        GetDeviceTokenController()); // الحصول على وحدة التحكم للحصول على رمز الجهاز
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn(); // محاولة تسجيل الدخول باستخدام Google

      if (googleSignInAccount != null) {
        // التحقق من نجاح تسجيل الدخول
        EasyLoading.show(
            status:
                "please wait..."); // عرض رسالة "please wait..." أثناء التحميل
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount
                .authentication; // الحصول على بيانات المصادقة من حساب Google

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken:
              googleSignInAuthentication.accessToken, // تعيين رمز الوصول
          idToken: googleSignInAuthentication.idToken, // تعيين رمز المعرف
        ); // إنشاء بيانات الاعتماد باستخدام GoogleAuthProvider

        final UserCredential userCredential = await _auth.signInWithCredential(
            credential); // تسجيل الدخول باستخدام بيانات الاعتماد

        final User? user =
            userCredential.user; // الحصول على المستخدم الذي تم تسجيل دخوله

        if (user != null) {
          // التحقق من أن المستخدم غير فارغ
          UserModel userModel = UserModel(
            uId: user.uid, // تعيين معرف المستخدم
            username: user.displayName.toString(), // تعيين اسم المستخدم
            email: user.email.toString(), // تعيين البريد الإلكتروني
            phone: user.phoneNumber.toString(), // تعيين رقم الهاتف
            userImg: user.photoURL.toString(), // تعيين صورة المستخدم
            userDeviceToken: getDeviceTokenController.deviceToken
                .toString(), // تعيين رمز جهاز المستخدم
            country: '', // تعيين البلد
            city: '', // تعيين المدينة
            userAddress: '', // تعيين عنوان المستخدم
            street: '', // تعيين الشارع
            isAdmin: false, // تعيين حالة المستخدم كمسؤول
            isActive: true, // تعيين حالة نشاط المستخدم
            createdOn: DateTime.now(), // تعيين تاريخ الإنشاء
          );
          await FirebaseFirestore.instance
              .collection('users') // الوصول إلى مجموعة المستخدمين في Firestore
              .doc(user.uid) // تعيين معرف الوثيقة
              .set(userModel.toMap()); // تخزين بيانات المستخدم في Firestore
          EasyLoading.dismiss(); // إخفاء رسالة التحميل

          Get.offAll(() => const MyHomePage()); // الانتقال إلى الشاشة الرئيسية
        }
      }
    } catch (e) {
      EasyLoading.dismiss(); // إخفاء رسالة التحميل في حالة حدوث خطأ
      print('error $e'); // طباعة رسالة الخطأ
    }
  }
}
