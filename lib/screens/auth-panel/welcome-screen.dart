// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers

import 'package:first/controllers/google-sign-in-controller.dart';
import 'package:first/screens/auth-panel/sign-in-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppConstant.appMainColor,
          title: const Text(
            "Wecome to my app",
            style: TextStyle(fontSize: 30, color: AppConstant.appTextColor),
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(child: Lottie.asset('assets/images/splash-sales.json')),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: const Text(
                  "Ahmed",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: Get.height / 30,
              ),
              Material(
                child: Container(
                  width: Get.width / 1.2,
                  height: Get.height / 12,
                  decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor,
                      borderRadius: BorderRadius.circular(40)),
                  child: TextButton.icon(
                    onPressed: () {
                      _googleSignInController.signInWithGoogle();
                    },
                    icon: Image.asset('assets/images/google-icon.png'),
                    label: Text(
                      "sign in with google",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 50,
              ),
              Material(
                child: Container(
                  width: Get.width / 1.2,
                  height: Get.height / 12,
                  decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor,
                      borderRadius: BorderRadius.circular(40)),
                  child: TextButton.icon(
                    onPressed: () {
                      Get.to(() => SigninScreen());
                    },
                    icon: Icon(Icons.email),
                    label: Text(
                      "sign in with e-mail",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
