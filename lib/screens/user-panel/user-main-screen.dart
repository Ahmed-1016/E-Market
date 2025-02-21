// ignore_for_file: file_names, prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/screens/user-panel/all-Products-screen.dart';
import 'package:first/screens/user-panel/all-flash-sale-products-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:first/widgets/all-products-widget.dart';
import 'package:first/widgets/banners-widget.dart';
import 'package:first/widgets/custom-drawer-widget.dart';
import 'package:first/widgets/headind-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widgets/flash-sale-widget.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'صباح الخير';
    } else if (hour >= 12 && hour < 18) {
      return 'مساء الخير';
    } else {
      return 'مساء الخير'; // أو أي تحية أخرى تناسب الليل
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 55),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppConstant.appSecondaryColor,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: AppConstant.appMainColor,
        title: Text("الصفحة الرئيسية",
            style: TextStyle(
                color: AppConstant.appTextColor,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: CustomDrawerWidget(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "${_getGreeting()}،  ",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        user?.displayName ?? "",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.waving_hand,
                        color: Colors.amber,
                      )
                    ],
                  ),
                ),
                BannerWidget(),
                // HeadingWidget(
                //     headingTitle: "التصنيفات",
                //     headingSubTitle: "طلبك بسعر الجملة",
                //     onTap: () => Get.to(() => AllCategoriesScreen()),
                //     buttonText: "المزيد"),
                // CategoryWidget(),
                HeadingWidget(
                    headingTitle: " العروض",
                    headingSubTitle: "عروض مخصصة لك",
                    onTap: () => Get.to(() => AllFlashSaleProductsScreen()),
                    buttonText: "المزيد"),
                FlashSaleWidget(),
                HeadingWidget(
                    headingTitle: "جميع المنتجات",
                    headingSubTitle: "اكبر تشكيلة منتجات",
                    onTap: () => Get.to(() => AllProductsScreen()),
                    buttonText: "المزيد"),
                AllProductsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
