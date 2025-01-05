import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:Susani/contollers/search_controller/search_controller.dart';

import '../../../consts/app_color.dart';
import '../../../contollers/cart_controller/cart_controller.dart';
import '../../../contollers/dashboard_controller/dashboard_controller.dart';
import '../../../contollers/signin/SignInController.dart';
import '../../../utils/routes_pages/pages_name.dart';
import '../profile/profile_page.dart';

class SearchPage extends StatelessWidget {
  var searchController = Get.put(SearchControllerone());
  var searchEditFieldController = TextEditingController();
  var cartController = Get.put(CartController());
  var dashboardController = Get.put(DashboardController());
  SignInController signInController = Get.put(SignInController());
  var message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              signInController.id.value == "" ||
                                      signInController.id.value == "null"
                                  ? Get.toNamed(MyPagesName.SignIn)
                                  : Get.to(() => ProfilePage());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.view_headline_rounded,
                                color: AppColor.bottomitemColor2,
                                size: 27,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                                autofocus: true,
                                onChanged: (value) {
                                  searchController.searchKey.value = value;
                                  searchController.searchProduct(value);
                                },
                                controller: searchEditFieldController,
                                decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.search),
                                    hintText: "Search Products",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                    contentPadding: EdgeInsets.only(left: 10))),
                          )),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              dashboardController.goToTab(3);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Obx(
                                () => Badge(
                                  label: Text(
                                    cartController.totalQuantity.toString(),
                                    style: TextStyle(
                                        color: AppColor.backgroundColor),
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
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: GetBuilder<SearchControllerone>(builder: (controller) {
                return Obx(
                  () => Container(
                      child: searchController.isLoading.value
                          ? Center(
                              child: Text("Searching data"),
                            )
                          : searchController.choices.length > 0
                              ? Wrap(
                                  children: searchController.choices,
                                )
                              : Center(
                                  child: Text("No record found"),
                                )),
                );
              }),
            ),
          ],
        ),
      ),
    ));
  }
}
