// ignore_for_file: body_might_complete_normally_nullable, unused_import, file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/models/user-model.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //for password visibility
  var isPasswordVisible = true.obs;

  Future<UserCredential?> signUPMethod(
    String username,
    String useremail,
    String userphone,
    String userCity,
    String userpassword,
    String userDeviceToken,
  ) async {
    try {
    EasyLoading.show(status:  "please wait...");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: useremail,
        password: userpassword,
      );
//Send email verification
      await userCredential.user!.sendEmailVerification();
      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: username,
        email: useremail,
        phone: userphone,
        userImg: '',
        userDeviceToken: userDeviceToken,
        country: '',
        city: '',
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: false,
        createdOn: DateTime.now(),
      );

      //add user data to firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
      EasyLoading.dismiss();
          return userCredential;

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appSecondaryColor,
        colorText: AppConstant.appTextColor,
      );
    }
  }
}
