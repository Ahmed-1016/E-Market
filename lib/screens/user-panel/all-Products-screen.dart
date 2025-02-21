// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/controllers/rating-controller.dart';
import 'package:first/models/product-model.dart';
import 'package:first/screens/user-panel/cart-screen.dart';
import 'package:first/screens/user-panel/product-deatils-screen.dart';
import 'package:first/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});
  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final Set<String> _controllerTags = {};
  TextEditingController _searchController =
      TextEditingController(); // متحكم لحقل البحث
  String _searchQuery = ''; // متغير لحفظ استعلام البحث
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    // حذف جميع الكنترولرز المسجلة
    for (var tag in _controllerTags) {
      Get.delete<CalculateProductRatingController>(tag: tag, force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 55),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.appSecondaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "جميع المنتجات",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery =
                          value.toLowerCase(); // تحديث الاستعلام عند تغيير النص
                    });
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "إبحث عن عروض",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection("products").get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                      color: Colors.blue,
                    ),
                  );
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("لم يتم اضافة منتجات"),
                  );
                }
                if (snapshot.data != null) {
                  List<ProductModel> productList =
                      snapshot.data!.docs.map((doc) {
                    return ProductModel(
                      productId: doc['productId'],
                      categoryId: doc['categoryId'],
                      productName: doc['productName'],
                      categoryName: doc['categoryName'],
                      salePrice: doc['salePrice'],
                      fullPrice: doc['fullPrice'],
                      productImages: doc['productImages'],
                      deliveryTime: doc['deliveryTime'],
                      isSale: doc['isSale'],
                      productDescription: doc['productDescription'],
                      createdAt: doc['createdAt'],
                      updatedAt: doc['updatedAt'],
                    );
                  }).toList();
                  List<ProductModel> filteredProducts =
                      productList.where((product) {
                    String query = _searchQuery.toLowerCase();
                    return product.productName.toLowerCase().contains(query) ||
                        product.categoryName.toLowerCase().contains(query) ||
                        product.productDescription
                            .toLowerCase()
                            .contains(query);
                  }).toList();

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Text("لا توجد منتجات مطابقة للبحث"),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      ProductModel productModel = filteredProducts[i];

                      if (!_controllerTags.contains(productModel.productId)) {
                        _controllerTags.add(productModel.productId);
                      }
                      final CalculateProductRatingController
                          calculateProductRatingController = Get.put(
                              CalculateProductRatingController(
                                  productModel.productId),
                              tag: productModel.productId);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ProductDeatilsScreen(
                                productModel: productModel));
                          },
                          child: Card(
                            elevation: 3,
                            child: Row(
                              children: [
                                TransparentImageCard(
                                  endColor: Colors.transparent,
                                  borderRadius: 10.0,
                                  width: Get.width / 2.1,
                                  height: Get.height / 5,
                                  imageProvider: CachedNetworkImageProvider(
                                    productModel.productImages[0],
                                  ),
                                ),
                                SizedBox(width: Get.width / 40),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productModel.productName),
                                    Text(productModel.categoryName),
                                    Row(
                                      children: [
                                        Obx(
                                          () => RatingBar.builder(
                                            glow: false,
                                            ignoreGestures: true,
                                            initialRating: double.parse(
                                                calculateProductRatingController
                                                    .averageRating
                                                    .toString()),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 25,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (value) {},
                                          ),
                                        ),
                                        Obx(
                                          () => Text(
                                            calculateProductRatingController
                                                .averageRating
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        productModel.isSale == true &&
                                                productModel.salePrice != ""
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "السعر:  ${productModel.salePrice}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2.0),
                                                  Text(
                                                    " ${productModel.fullPrice}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                "السعر: ${productModel.fullPrice}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ],
                                    ),
                                    Container(
                                        constraints: BoxConstraints(
                                            maxWidth: Get.width / 2.3),
                                        child: Text(
                                            productModel.productDescription)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
                // return Row(
                //   children: [
                //     GestureDetector(
                     
                //       child: Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Container(
                // child: FillImageCard(
                //   borderRadius: 10.0,
                //   width: Get.width / 2.2,
                //   heightImage: Get.height / 12,
                //   imageProvider: CachedNetworkImageProvider(
                //     productModel.productImages[0],
                //   ),
                //             title: Center(
                //               child: Text(
                //                 productModel.productName,
                //                 overflow: TextOverflow.ellipsis,
                //                 maxLines: 1,
                //                 style: TextStyle(
                //                   fontSize: 15,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //             footer: Center(
                             
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // );
         
