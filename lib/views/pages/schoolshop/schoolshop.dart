import 'dart:convert';

import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/views/pages/dashboard/dashboard_page.dart';
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
  final SchoolCategoryController controllerCAT = Get.put(SchoolCategoryController());

  var prod_ctrl = Get.put(ProductCategoriesController());

  var productController = Get.put(ProductController());

  var searchEditFieldController = TextEditingController();

  var cartController = Get.put(CartController());

  var dashboardController = Get.put(DashboardController());

  final TextEditingController searchController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    //controllerCA.fetchProductByCategory("0","school",school.id!);
    prod_ctrl.type.value = "school";
    productController.type.value = "school";
    productController.user_id.value = widget.school.id!;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                  child: TextField(
                      onChanged: (value) {
                        print("value ==" + value);
                        productController.productList.clear();
                        if (value != "")
                          productController.searchProductByKey(value);
                        else
                          productController.fetchProduct();
                      },
                      controller: searchEditFieldController,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          hintText: "Search Products",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(100))),
                          contentPadding: EdgeInsets.only(left: 10)))),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.back();
                  Get.back();
                  dashboardController.goToTab(3);
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
        ),

        body: Column(
            children: [
              Text(widget.school.name! + " " + widget.school.lastname,
                style: TextStyle(fontSize: 20),),

              // ---------------------------------- categories
              Obx(()=>prod_ctrl.isLoading.value ? CircularProgressIndicator() : SizedBox(
                  height: 60,
                  child: GetBuilder<ProductCategoriesController>(
                      init: ProductCategoriesController(),
                      builder: (controller) {
                        return ProductCategoriesDesign(
                          itemList: controller.categories,
                          category: (id) {
                            ProductController pc = Get.find<
                                ProductController>();
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
                )
              ),
              // ----------------------------------product list
              Expanded(
                child: GetBuilder<ProductController>(builder: (controller) {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Obx(() =>
                    controller.isLoading.value
                        ? Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 1.3,
                        child: Center(
                            child: controller.isError.value
                                ? Text("Data not found in this category")
                                : new CircularProgressIndicator(
                              color: Colors.black,
                            )))
                        : StaggeredGridView.countBuilder(
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
                                .productDesign,
                          ),
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.fit(2),
                      mainAxisSpacing: 9.0,
                      crossAxisSpacing: 10.0,
                    )),
                  );
                }),
              ),
              Obx(
                    () =>
                    Container(
                      child: productController.isLoadingbyfetch.value
                          ? new CircularProgressIndicator(
                        color: Colors.black,
                      )
                          : SizedBox(
                        height: 0,
                      ),
                    ),
              )
            ]
        )
    )
    ;
  }
}
