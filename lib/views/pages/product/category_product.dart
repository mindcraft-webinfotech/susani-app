import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/product_controller/product_categories_controller.dart';

import 'package:Susani/utils/routes_pages/pages_name.dart';

import 'package:Susani/views/widgets/product_categories.dart';
import 'package:Susani/views/widgets/product_design.dart';

class CategoryProduct extends StatelessWidget {
  var controller = Get.put(ProductCategoriesController());
  var productController = Get.put(ProductController());
  int id = 0;
  List<PopupMenuItem> getFilterItems() {
    var popItems = <PopupMenuItem>[];
    int i = 0;
    AppConstraints.filterList.forEach((element) {
      popItems.add(PopupMenuItem(
        child: Text(element),
        value: i,
      ));

      i++;
    });
    return popItems;
  }

  CategoryProduct() {
    id = int.parse(Get.arguments.toString());
    productController.searchedProductList.clear();
    productController.searchStatus.value = "";
    productController.searchedProductList =
        productController.searchProductByCategory(int.parse(id.toString()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            centerTitle: true,
            title: Obx(
              () => Text(
                controller.searchCategoriesName.value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
            actions: [
              Obx(() => PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black.withAlpha(50)),
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 1,
                  color: Colors.white.withAlpha(240),
                  offset: Offset(0, 40),
                  tooltip: "Filter",
                  initialValue: productController.sortIndex.value,
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        {
                          productController.sortIndex.value = value as int;

                          productController.sortProductByLatest(
                              productController.searchedProductList);
                          break;
                        }

                      case 1:
                        {
                          productController.sortProductByAtoZ(
                              productController.searchedProductList);

                          productController.sortIndex.value = value as int;
                          break;
                        }
                      case 2:
                        {
                          productController.sortProductByZtoA(
                              productController.searchedProductList);
                          productController.sortIndex.value = value as int;
                          break;
                        }
                      case 3:
                        {
                          productController.sortProductByASC(
                              productController.searchedProductList);
                          productController.sortIndex.value = value as int;
                          break;
                        }
                      case 4:
                        {
                          productController.sortProductByDESC(
                              productController.searchedProductList);
                          productController.sortIndex.value = value as int;
                          break;
                        }

                      default:
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icon/filter.png",
                      width: 30,
                      height: 30,
                      color: Colors.black,
                    ),
                  ),
                  itemBuilder: (context) => getFilterItems()))
            ]),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GetBuilder<ProductController>(builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(() => controller.searchStatus.value ==
                                "Searching"
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.3,
                                child: Center(
                                    child: new CircularProgressIndicator()))
                            : StaggeredGridView.countBuilder(
                                crossAxisCount: 4,
                                shrinkWrap: true,
                                primary: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    controller.searchedProductList.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        GestureDetector(
                                  onTap: () {
                                    //controller.loadProductDetails(controller.searchedProductList[index]);
                                    Get.toNamed(MyPagesName.productFullView,
                                        arguments: controller
                                            .searchedProductList[index].id);
                                  },
                                  child: ProductDesign(
                                          context: context,
                                          product: controller
                                              .searchedProductList[index])
                                      .productDesign,
                                ),
                                staggeredTileBuilder: (int index) =>
                                    StaggeredTile.fit(2),
                                mainAxisSpacing: 9.0,
                                crossAxisSpacing: 10.0,
                              )),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
