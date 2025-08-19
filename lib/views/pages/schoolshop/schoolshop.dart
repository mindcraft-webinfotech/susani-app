import 'dart:convert';

import 'package:Susani/consts/string_extension.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/views/pages/dashboard/dashboard_page.dart';
import 'package:Susani/views/pages/ecom/screens/EcomCart.dart';
import 'package:Susani/views/pages/ecom/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/views/widgets/product_categories.dart';
import '../../../contollers/dashboard_controller/dashboard_controller.dart';
import 'package:http/http.dart' as http;
import '../../../contollers/product_controller/prodcut_CAT_controller.dart';
import '../../../contollers/product_controller/product_categories_controller.dart';
import '../../../models/category.dart';
import '../../../services/remote_servies.dart';
import '../../../utils/routes_pages/pages_name.dart';
import '../../widgets/product_design.dart';
import 'Search_School.dart';

class Schoolshop extends StatefulWidget {
  School school;

  Schoolshop({required this.school});

  @override
  State<Schoolshop> createState() => _SchoolshopState();
}

class _SchoolshopState extends State<Schoolshop> {
  var controller = Get.put(ProductCategoriesController());
  var productController = Get.put(ProductController());
  var searchEditFieldController = TextEditingController();
  var cartController = Get.put(CartController());
  var dashboardController = Get.put(DashboardController());
  final SchoolCategoryController schoolcontrollerCAT = Get.put(
      SchoolCategoryController());


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

  static const _pageSize = 20;

  @override
  Widget build(BuildContext context) {
    print("product page     ${controller.type.value} ${productController.type
        .value} ${productController.user_id.value}");

    // controller.type.value = "laundry";
    // productController.type.value = "laundry";
    // productController.user_id.value="0";

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            forceMaterialTransparency: true,
            title: Row(
              children: [
                Expanded(
                    child: TextField(
                        onChanged: (value) {
                          print("value ==" + value);
                          productController.productList.clear();
                          if (value.length >= 3) {
                            productController.searchProductByKey(value);
                          } else {
                            productController.fetchProduct();
                          }
                        },
                        controller: searchEditFieldController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            hintText: "Search ${productController.type
                                .value} Products".capitalizeFirst,
                            hintStyle: TextStyle(color: Colors.grey,
                              fontWeight: FontWeight.w400,

                            ),

                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                            contentPadding: EdgeInsets.only(left: 10)))),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // Get.back();
                    // dashboardController.goToTab(3);
                    Get.to(Ecomcart());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: AppColor.backgroundColor,
                    child: Obx(
                          () =>
                          Badge(
                            label: Text(
                              cartController.totalQuantity.toString(),
                              style: TextStyle(color: AppColor.backgroundColor),
                            ),
                            child: Icon(
                              FontAwesomeIcons.cartPlus,
                              color: AppColor.bottomitemColor2,
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Obx(() =>
                  PopupMenuButton(
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
                                  productController.productList);
                              break;
                            }

                          case 1:
                            {
                              productController
                                  .sortProductByAtoZ(
                                  productController.productList);

                              productController.sortIndex.value = value as int;
                              break;
                            }
                          case 2:
                            {
                              productController
                                  .sortProductByZtoA(
                                  productController.productList);
                              productController.sortIndex.value = value as int;
                              break;
                            }
                          case 3:
                            {
                              productController
                                  .sortProductByASC(
                                  productController.productList);
                              productController.sortIndex.value = value as int;
                              break;
                            }
                          case 4:
                            {
                              productController
                                  .sortProductByDESC(
                                  productController.productList);
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
                          color: AppColor.bottomitemColor2,
                        ),
                      ),
                      itemBuilder: (context) => getFilterItems()))
            ]),
        body: Column(
          children: [
            // ImageWithShimmer(imageUrl: AppConstraints.PROFILE_URL +
            //     widget.school.aadharPhoto!, height: 100, width: double.infinity, Fit: BoxFit.fitWidth),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  "${widget.school.name.toString().toTitleCase()} ",),
              ),
            ),
            // ---------------------------------- categories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() =>
              controller.isLoading.value ? CircularProgressIndicator() :
              SizedBox(
                height: 60,
                child: GetBuilder<ProductCategoriesController>(
                    init: ProductCategoriesController(),
                    builder: (controller) {
                      return ProductCategoriesDesign(
                        itemList: controller.categories,
                        category: (id) {
                          ProductController pc = Get.find<ProductController>();
                          pc.isError.value = false;
                          pc.isLoading.value = true;
                          print("id -----" + id);
                          // pc.productList = pc.fetchProductByCategory(int.parse(id));
                          if (id == "0") {
                            pc.fetchProduct();
                          } else {
                            pc.productList =
                                pc.fetchProductByCategory(int.parse(id));
                          }
                        },
                      );
                    }),
              )),
            ),
            // ----------------------------------product list
            Obx(() {
              if (controller.isLoading.value) {
                return Expanded(child: buildShimmerEffect(context));
              }
              return Expanded(
                child: GetBuilder<ProductController>(builder: (controller) {
                  if (controller.productList.isEmpty)
                    return Center(child: Text(
                      "No product available",));

         if (controller.isLoading.value)
                    return Center(child: Text(
                      "Loading products ...",));

                  if(controller.isError.value)
                      return Center(
                        child: Text("Data not found in this category"),
                      );


                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(() =>

                    controller.productList.isEmpty
                        ? Center(child: Text(
                      "No product available",)) :
                    StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      controller: controller.scroll,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.productList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                            onTap: () {
                              print("object");
                              //controller.loadProductDetails(controller.productList[index]);
                              Get.toNamed(MyPagesName.productFullView,
                                  arguments: controller.productList[index].id);
                            },
                            child: ProductDesign(
                                context: context,
                                product: controller.productList[index])
                                .productDesignschool,
                          ),
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.fit(2),
                      mainAxisSpacing: 9.0,
                      crossAxisSpacing: 10.0,
                    )),
                  );
                }),
              );
            }),
          ],
        ));
  }
}
