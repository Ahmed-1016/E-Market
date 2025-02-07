// ignore_for_file: file_names, prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'package:first/screens/user-panel/all-categories-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:first/widgets/banners-widget.dart';
import 'package:first/widgets/category-widget.dart';
import 'package:first/widgets/custom-drawer-widget.dart';
import 'package:first/widgets/headind-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widgets/flash-sale-widget.dart';

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
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 50,
              ),
              BannerWidget(),
              HeadingWidget(
                headingTitle: "Categories",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to((AllCategoriesScreen())),
                buttonText: "See More",
              ),
              CategoryWidget(),
              HeadingWidget(
                headingTitle: "Flah Sale",
                headingSubTitle: "According to your budget",
                onTap: () {},
                buttonText: "See More",
              ),
              FlashSaleWidget()
            ],
          ),
        ),
      ),
    );
  }
}
