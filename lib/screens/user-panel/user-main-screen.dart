// ignore_for_file: file_names, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/screens/auth-panel/welcome-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:first/widgets/banners-widget.dart';
import 'package:first/widgets/custom-drawer-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserMainScreen extends StatelessWidget {
  const UserMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppConstant.appSecondaryColor,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.userScrenMainName,
          style: TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(children: [
            SizedBox(height: Get.height/90,),
            Text("Natural"),
            BannerWidget()
          ],),
        ),
      ),
    );
  }
}
