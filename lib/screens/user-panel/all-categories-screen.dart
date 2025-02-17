// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/categories-model.dart';
import 'package:first/screens/user-panel/single-category-product-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.appSecondaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "التصنيفات",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("categories").get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("لم يتم اضافة تصنيفات"),
            );
          }
          if (snapshot.data != null) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 1.19,
              ),
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: snapshot.data!.docs[i]['categoryId'],
                  categoryImg: snapshot.data!.docs[i]['categoryImg'],
                  categoryName: snapshot.data!.docs[i]['categoryName'],
                  createdAt: snapshot.data!.docs[i]['createdAt'],
                  updatedAt: snapshot.data!.docs[i]['updatedAt'],
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(
                        SingleCategoryProductScreen(
                          categoryId: categoriesModel.categoryId,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 10.0,
                            width: Get.width / 2.2,
                            heightImage: Get.height / 12,
                            imageProvider: CachedNetworkImageProvider(
                              categoriesModel.categoryImg,
                            ),
                            title: Center(
                              child: Text(
                                categoriesModel.categoryName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            footer: Text(''),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
