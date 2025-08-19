import 'dart:convert';

import 'package:Susani/consts/string_extension.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/login_controller/LoginPopupController.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/views/pages/ecom/screens/EcomCart.dart';
import 'package:Susani/views/pages/schoolshop/LoginPopup.dart';
import 'package:Susani/views/pages/schoolshop/schoolshop.dart';
import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';

import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/product_controller/product_categories_controller.dart';

import 'package:Susani/utils/routes_pages/pages_name.dart';

import 'package:Susani/views/widgets/product_categories.dart';
import 'package:Susani/views/widgets/product_design.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Susani/models/category.dart';
import '../../../contollers/dashboard_controller/dashboard_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/product_controller/product_categories_controller.dart';
import 'package:Susani/models/category.dart';
import 'package:http/http.dart' as http;

import '../news/prod_category/prod_category.dart';

class SearchSchool extends StatelessWidget {
  final SchoolCategoryController controllerCAT =
      Get.put(SchoolCategoryController());
  var loginPopupController = Get.put(LoginPopupController());
  var prod_ctrl = Get.put(ProductCategoriesController());

  var productController = Get.put(ProductController());
  var searchEditFieldController = TextEditingController();
  var cartController = Get.put(CartController());
  var dashboardController = Get.put(DashboardController());
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    controllerCAT.searchCategories("");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
                child: TextField(
                    controller: searchController,
                    focusNode: focusNode,
                    onChanged: (value) {
                      if (value.length >= 3) {
                        controllerCAT.searchCategories(value);
                      }
                    },
                    // onChanged: (value) {
                    // print("value ==" + value);
                    // productController.productList.clear();
                    // if (value != "")
                    //   productController.searchProductByKey(value);
                    // else
                    //   productController.fetchProduct();
                    // },
                    // controller: searchEditFieldController,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: "Search Schools",
                        hintStyle: TextStyle(color: Colors.grey),
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
                  () => Badge(
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
          Expanded(
            child: Obx(() {
              if (controllerCAT.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              }

              if (controllerCAT.schools.isEmpty) {
                return Center(child: Text('No results found.'));
              }

              return Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 10, right: 10, bottom: 15),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items in a row
                    mainAxisSpacing: 10.0, // Space between rows
                    crossAxisSpacing: 10.0, // Space between columns
                    childAspectRatio: 1, // Width to height ratio for grid items
                  ),
                  itemCount: controllerCAT.schools.length,
                  itemBuilder: (context, index) {
                    final school = controllerCAT.schools[index];
                    return InkWell(
                      onTap: () {
                        prod_ctrl.type.value = "school";
                        productController.type.value = "school";
                        productController.user_id.value =
                            controllerCAT.schools[index].id!;
                        prod_ctrl.loadCategories();
                        Get.find<ProductController>().fetchProduct();
                        ProductCategoriesController ctrll =
                            Get.find<ProductCategoriesController>();
                        ctrll.type.value = "school";
                        ctrll.selectedCategories(
                            prod_ctrl.categories[0].categoryname!);
                        prod_ctrl.getCategoryId(index);
                        // Get.to(() => ProductPage());

                        // Get.back();
                        // dashboardController.goToTab(1);
                        controllerCAT.schools[index].isSchoolAllowed ==
                                "not allowed"
                            ? showLoginPopup(controllerCAT.schools[index])
                            : Get.to(() => Schoolshop(school: school));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all()),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: AppConstraints.PROFILE_URL +
                                      school.aadharPhoto!,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  placeholder: (context, value) =>
                                      Shimmer.fromColors(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                    direction: ShimmerDirection.ltr,
                                    period: Duration(seconds: 1),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          color: Colors.grey[300],
                                          child: Image.asset(
                                              "assets/images/noImg.png")),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 45,
                                child: Center(
                                  child: Text(
                                    "${school.name} ${school.lastname} "
                                        .toTitleCase(),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is chunk size
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class SchoolCategoryController extends GetxController {
  var schools = <School>[].obs;
  var isLoading = true.obs;

  Future<void> searchCategories(String searchTerm) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://susani.in/API/V1/vendor-api.php'),
        body: {
          'flag': 'get_schools',
          'search': searchTerm,
        },
      );

      printFullText(response.body);
      print({
        'flag': 'get_schools',
        'search': searchTerm,
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['res'] == 'success') {
          // Parse the JSON response into a list of School objects
          schools.value = (jsonResponse['data'] as List)
              .map((schoolData) => School.fromJson(schoolData))
              .toList();
        } else {
          schools.clear();
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}

class School {
  final String id;
  final String name;
  final String lastname;
  final String email;
  final String mobile;
  final String gender;
  final String city;
  final String zip;
  final String aadharPhoto;
  final String panPhoto;
  final String gstPhoto;
  final String aadharNo;
  final String panNo;
  final String gstNo;
  final String locality;
  final String country;
  final String state;
  final String type;
  final String isSchoolAllowed;

  School(
      {required this.id,
      required this.name,
      required this.lastname,
      required this.email,
      required this.mobile,
      required this.gender,
      required this.city,
      required this.zip,
      required this.aadharPhoto,
      required this.panPhoto,
      required this.gstPhoto,
      required this.aadharNo,
      required this.panNo,
      required this.gstNo,
      required this.locality,
      required this.country,
      required this.state,
      required this.type,
      required this.isSchoolAllowed});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      email: json['email'],
      mobile: json['mobile'],
      gender: json['gender'],
      city: json['city'],
      zip: json['zip'],
      aadharPhoto: json['aadhar_photo'] ?? '',
      panPhoto: json['pan_photo'] ?? '',
      gstPhoto: json['gst_photo'] ?? '',
      aadharNo: json['aadhar_no'] ?? '',
      panNo: json['pan_no'] ?? '',
      gstNo: json['gst_no'] ?? '',
      locality: json['locality'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      type: json['type'] ?? '',
      isSchoolAllowed: json['is_school_allowed'] ?? '',
    );
  }
}
