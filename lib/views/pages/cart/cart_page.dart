import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:badges/badges.dart' as badge;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/app_config/AppConfigController.dart';

import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/views/widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../../consts/app_color.dart';

class CartPage extends StatelessWidget {

  var appConfigController = Get.put(MyAppConfigController());
  var signInController = Get.put(SignInController());
  var controller = Get.put(CartController());
  var dashboardController = Get.put(DashboardController());
  var check = Get.put(CheckoutController());

  static var addressController = Get.put(AddressController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            Text(
              "Cart",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                dashboardController.goToTab(3);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Obx(
                  () => Badge(
                    label: Text(
                      controller.totalQuantity.toString(),
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
      body: Obx(
        () => controller.status.value == "Loading"
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            : controller.cartItems.length > 0
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: controller.cartItems.length,
                            // itemExtent: 100,
                            padding: EdgeInsets.all(0),
                            itemBuilder: (BuildContext context, int index) {
                              var color = controller.cartItems[index].color!;
                              return Container(
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Color.fromARGB(255, 49, 3, 3),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        // dense: true,
                                        contentPadding: EdgeInsets.only(
                                            left: 1,
                                            right: 15,
                                            top: 0,
                                            bottom: 0),
                                        trailing: Container(
                                          width: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipOval(
                                                child: InkWell(
                                                  splashColor: Colors
                                                      .grey, // Splash color
                                                  onTap: () {
                                                    Get.defaultDialog(
                                                        title: "CONFIRMATION",
                                                        titleStyle: TextStyle(
                                                            fontSize: 16),
                                                        middleText: "Are you sure you want to remove " +
                                                            controller
                                                                .cartItems[
                                                                    index]
                                                                .product!
                                                                .name! +
                                                            "?",
                                                        middleTextStyle:
                                                            TextStyle(
                                                                fontSize: 12),
                                                        cancel: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor: Colors
                                                                        .white),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                                "Cancel",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ))),
                                                        confirm: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            3,
                                                                            33,
                                                                            49),
                                                                    elevation:
                                                                        5),
                                                            onPressed: () {
                                                              controller.daleteItem(
                                                                  controller
                                                                          .cartItems[
                                                                      index]);
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                                "Remove",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ))),
                                                        contentPadding:
                                                            EdgeInsets.all(20));
                                                  },
                                                  child: SizedBox(
                                                      // width: 30,
                                                      // height: 30,
                                                      child: Icon(
                                                    FontAwesomeIcons.trash,
                                                    color: Colors.red,
                                                    size: 25,
                                                  )),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                    // color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                padding: EdgeInsets.all(0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .cartItems[index]
                                                              .quantity += 1;
                                                          controller
                                                              .addQuantityToCartTable(
                                                                  controller
                                                                          .cartItems[
                                                                      index],
                                                                  1,
                                                                  "plus");
                                                        },
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .plusCircle,
                                                          size: 30,
                                                        )),
                                                    Obx(
                                                      () => Container(
                                                        margin:
                                                            EdgeInsets.all(2),
                                                        child: controller
                                                                    .addQuantStatus
                                                                    .value ==
                                                                "Loading"
                                                            ? SizedBox(
                                                                width: 10,
                                                                height: 10,
                                                                child:
                                                                    CircularProgressIndicator())
                                                            : Text(controller
                                                                .cartItems[
                                                                    index]
                                                                .quantity
                                                                .toString()),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          if (controller
                                                                  .cartItems[
                                                                      index]
                                                                  .quantity >
                                                              1) {
                                                            if (controller
                                                                    .cartItems[
                                                                        index]
                                                                    .quantity >
                                                                1) {
                                                              controller
                                                                  .cartItems[
                                                                      index]
                                                                  .quantity -= 1;
                                                              controller
                                                                  .addQuantityToCartTable(
                                                                      controller
                                                                              .cartItems[
                                                                          index],
                                                                      1,
                                                                      "minus");
                                                            }
                                                          }
                                                        },
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .minusCircle,
                                                          size: 30,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        leading: Container(
                                            child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            AppConstraints.PRODUCT_URL +
                                                controller.cartItems[index]
                                                    .product!.img![0],
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                        title: Wrap(
                                          children:[
                                            Text(controller
                                                .cartItems[index].product!.name!),
                                            Text(" (${controller
                                                .cartItems[index].size!})"),

                                          ] ),
                                        subtitle: Row(
                                          children: [
                                            // Text(controller
                                            //     .cartItems[index]
                                            //     .product!.type ??" ad"),
                                            Text(
                                              "\₹" +
                                                  (double.parse(controller
                                                              .cartItems[index]
                                                              .product!
                                                              .mrp
                                                              .toString()) -
                                                          controller
                                                              .cartItems[index]
                                                              .product!
                                                              .discount!)
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              " + " +
                                                  (double.parse(controller
                                                      .cartItems[index]
                                                      .product!
                                                      .gst
                                                      .toString()))
                                                      .toString() +"% GST",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w100),
                                            ),

                                            SizedBox(
                                              width: 20,
                                            ),
                                            controller.cartItems[index].product!
                                                        .discount ==
                                                    0
                                                ? Container()
                                                : Text(
                                                    "\₹" +
                                                        (double.parse(controller
                                                                .cartItems[
                                                                    index]
                                                                .product!
                                                                .mrp
                                                                .toString()))
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),

                                            // Container(
                                            //   child: Card(
                                            //       color: CommonTool.fromHex(color),
                                            //       shape: RoundedRectangleBorder(
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   17)),
                                            //       child: Container(
                                            //         height: 20,
                                            //       )),
                                            // ),

                                            // Expanded(child: Text(color)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          // height: 250,
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              controller.subTotalDiscount > 0
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "You Saved",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))),
                                          Expanded(
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(":"))),
                                          Expanded(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Obx(() => Text(
                                                        "\₹" +
                                                            controller
                                                                .subTotalDiscount
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))))
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Sub Total"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(":"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Obx(() => Text(
                                                  "\₹" +
                                                      controller.subTotal
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))))
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Shipping Fee"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(":"))),
                                    //changes made by kamlesh
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: controller.subTotal
                                                        .toInt() <=
                                                    150
                                                ? Text(
                                                    "\₹" +
                                                        appConfigController
                                                            .appConfig
                                                            .shipping_fee!
                                                            .toStringAsFixed(1),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text("0")))
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Estimating Tax"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(":"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "\₹" +
                                                  controller.totalTax
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )))
                                  ],
                                ),
                              ),
                              Divider(
                                indent: 30,
                                endIndent: 30,
                                thickness: 2,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Total"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(""))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Obx(
                                              () => Text(
                                                "\₹" +
                                                    controller.total
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // print("Address length: " +
                                          //     addressController.addresses.length
                                          //         .toString());

                                          if (signInController.id.value
                                                      .trim() !=
                                                  "null" &&
                                              signInController.id.value
                                                      .trim() !=
                                                  "") {
                                            Get.toNamed(
                                                MyPagesName.checkoutPage);
                                          } else {
                                            Get.toNamed(MyPagesName.SignIn);
                                          }
                                        },
                                        child:
                                            AppButton(buttonTitle: "Checkout")
                                                .myButton,
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
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Image.asset(
                            'assets/images/empty_cart.png',
                            width: 100,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Your Cart is empty. ",
                            style: TextStyle(fontSize: 20)),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            DashboardController dashboardController =
                                Get.put(DashboardController());
                            dashboardController.goToTab(1);
                            Get.back();
                          },
                          child: Container(
                              width: 150,
                              child:
                                  AppButton(buttonTitle: "Shop Now").myButton),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
