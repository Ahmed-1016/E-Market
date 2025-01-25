// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:async';

import 'package:first/screens/auth-panel/welcome-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

void initState() { 
  super.initState();
  Timer(Duration(seconds: 2), (){
    Get.offAll(()=>WelcomeScreen());
      },);
  
}

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      appBar: 
    AppBar(
      backgroundColor: AppConstant.appSecondaryColor,
    elevation: 0,
    ),
    body: Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
               width: Get.width,
                alignment: Alignment.center,
              child: Lottie.asset('assets/images/splash-sales.json'),
              ),
          ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              width: Get.width,
              alignment: Alignment.center,
              child: Text(AppConstant.appPoweredBy,
            style: TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
            )            ,)
        ],
      ),
    ),
    );
  }
}