//import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
//import 'package:circular_bottom_navigation/tab_item.dart';
import 'dart:io';

import 'package:Susani/contollers/order_history/OrderHistory.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/search_controller/search_controller.dart';
import 'package:Susani/utils/common_tools.dart';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/views/pages/cart/cart_page.dart';
import 'package:Susani/views/pages/news/news_page.dart';
import 'package:Susani/views/pages/product/product_page.dart';
import 'package:Susani/views/pages/profile/profile_page.dart';
import 'package:Susani/views/pages/search/search_page.dart';
import 'package:Susani/views/widgets/bottom_navigation/circular_bottom_navigation.dart';
import 'package:Susani/views/widgets/bottom_navigation/tab_item.dart';

import '../../../models/User.dart';
// changed Get<view>(DashboardController()) to StatefullWidget

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  CartController cartController = Get.put(CartController());

  SignInController signInController = Get.put(SignInController());

  ProductController productController = Get.put(ProductController());

  SearchControllerone searchController = Get.put(SearchControllerone());

  OrderHistoryController orderHistory = Get.put(OrderHistoryController());

  SignInController signinController = Get.put(SignInController());

  DashboardController controller = Get.put(DashboardController());

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: ()   async {


        var returnvalue = true;

        Get.defaultDialog(
            content: Text("Do you realy want to exit?"),
            confirm: ElevatedButton(
                onPressed: () {
                  returnvalue = true;
                  exit(0);
                },
                child: Text("Exit")),
            cancel: ElevatedButton(
                onPressed: () {
                  returnvalue = false;
                  Get.back();
                },
                child: Text("Cancel")));
        return Future.value(returnvalue);

        },
    child: Scaffold(
      body: SizedBox.expand(
        child: PageView(
          physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          children: [
            NewsPage(),
            ProductPage(),
            SearchPage(),
            CartPage(),
            ProfilePage()
          ],
          controller: controller.pageController,
        ),
      ),
      bottomNavigationBar: Obx(
        () => MyCircularBottomNavigation(
          tabItems: [
            TabItem("assets/icon/house.png", "", AppColor.bottomitemColor1),
            TabItem("assets/icon/p.png", "", AppColor.bottomitemColor1),
            TabItem('assets/icon/search.png', "", AppColor.bottomitemColor1),
            TabItem('assets/icon/cart.png', "", AppColor.bottomitemColor1),
            TabItem(
              "assets/icon/account.png",
              "",
              AppColor.bottomitemColor1,
            ),
          ],
          controller: controller.navigationController,
          selectedPos: controller.currentIndex.value,
          normalIconColor: AppColor.bottomitemColor2,
          barHeight: 60,
          iconsSize: 25,
          barBackgroundColor: Colors.white,
          circleStrokeWidth: 0,
          selectedCallback: (int position) {
            controller.currentIndex.value = position;
            controller.pageController.jumpToPage(position);
            if (position == 3) {
              CartController cartController = Get.put(CartController());
              SignInController signInController = Get.put(SignInController());

              cartController
                  .getCartItems(signInController.user.value.id.toString());
            } else if (position == 0) {
              CartController cartController = Get.put(CartController());
              SignInController signInController = Get.put(SignInController());
              cartController
                  .getCartItems(signInController.user.value.id.toString());
            } else if (position == 2) {
              if (searchController.searchKey.value != "") {
                searchController
                    .searchProduct(searchController.searchKey.value);
              }
            } else if (position == 4) {
              orderHistory.fetchOrders();
              orderHistory.orderHistory(signinController.user.value);
            } else if (position == 1) {
              productController.productList.clear();
              productController.fetchProduct();
            }
          },
        ),
      ),
    )
    );
  }

  Future<void> getData() async {
    CommonTool().getUserId().then((value) => {
          cartController.getCartItems(
              User(id: signInController.id.value.toString()).id as String)
        });
  }

}
