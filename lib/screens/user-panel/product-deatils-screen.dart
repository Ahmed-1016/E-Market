// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:first/models/product-model.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductDeatilsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDeatilsScreen({super.key, required this.productModel});

  @override
  State<ProductDeatilsScreen> createState() => _ProductDeatilsScreenState();
}

class _ProductDeatilsScreenState extends State<ProductDeatilsScreen> {
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
            "Product Deatils",
            style: TextStyle(
                color: AppConstant.appTextColor,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(height: Get.height / 50),
              CarouselSlider(
                items: widget.productModel.productImages
                    .map(
                      (imageUrls) => ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: imageUrls,
                          fit: BoxFit.cover,
                          width: Get.width - 20,
                          placeholder: (context, url) => ColoredBox(
                            color: Colors.white,
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  aspectRatio: 2.5,
                  viewportFraction: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "productName: ${widget.productModel.productName}",
                              ),
                              Icon(Icons.favorite_outline)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              widget.productModel.isSale == true &&
                                      widget.productModel.salePrice != ""
                                  ? Text(
                                      "Price: ${widget.productModel.salePrice}")
                                  : Text(
                                      "Price: ${widget.productModel.fullPrice}"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "categoryName: ${widget.productModel.categoryName}",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "productDescription: ${widget.productModel.productDescription}",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              child: Container(
                                width: Get.width / 2.5,
                                height: Get.height / 15,
                                decoration: BoxDecoration(
                                  color: AppConstant.appSecondaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {},
                                  label: Text(
                                    "WhatsApp",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                  icon: Icon(Icons.call),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Material(
                              child: Container(
                                width: Get.width / 3,
                                height: Get.height / 15,
                                decoration: BoxDecoration(
                                  color: AppConstant.appSecondaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {},
                                  label: Text(
                                    "Add To Cart",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
