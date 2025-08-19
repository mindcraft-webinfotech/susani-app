import 'dart:convert';

import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/models/Landmarks.dart';
import 'package:Susani/models/product.dart';
import 'package:Susani/views/pages/WebView/MyWebView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/app_config/AppConfigController.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/views/widgets/app_button.dart';
import 'package:Susani/views/widgets/check_out_widget/first_widget.dart';
import 'package:Susani/views/widgets/check_out_widget/second_widget.dart';
import 'package:Susani/views/widgets/check_out_widget/third.widget.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  var controller = Get.find<CheckoutController>();

  var signInController = Get.put(SignInController());

  var cartController = Get.put(CartController());

  var appConfigController = Get.put(MyAppConfigController());

  var addressController = Get.find<AddressController>();

  @override
  void initState() {
    super.initState();
    controller.isDateSelected.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(children: [
        Expanded(
            child: Obx(
          () => Stepper(
            currentStep: controller.currentStep.value,
            type: StepperType.horizontal,
            onStepTapped: (step) {
              FocusScope.of(context).unfocus();
              if (step == 1) {
                final startOfToday = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                );
                var isPast = controller.dateTime.value.isBefore(startOfToday);
                if (controller.selectedAddress.value.id == "") {
                  Get.snackbar("Alert", "Please select an address and landmark",
                      icon: Icon(Icons.person, color: Colors.white),
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      animationDuration: Duration(microseconds: 100),
                      backgroundColor: Colors.black);
                } else {
                  if (isPast) {
                    Get.snackbar("Alert", "Please select a delivery date",
                        icon: Icon(Icons.person, color: Colors.white),
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Colors.white,
                        animationDuration: Duration(microseconds: 100),
                        backgroundColor: Colors.black);
                  } else {
                    controller.tapped(step);
                  }
                }
              } else if (step == 2) {
                if (controller.paymentMethod.value == "") {
                  Get.snackbar("Alert", "Please select any payment method",
                      icon: Icon(Icons.person, color: Colors.white),
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      animationDuration: Duration(microseconds: 100),
                      backgroundColor: Colors.black);
                } else {
                  controller.tapped(step);
                }
              } else {
                controller.tapped(step);
              }
            },

            steps: [
              Step(
                  isActive: controller.currentStep == 0 ? true : false,
                  title: Text(
                    "Personal Info",
                    style: TextStyle(fontSize: 12),
                  ),
                  content: new FirstWidget(context: context).firstWidget),
              Step(
                  isActive: controller.currentStep == 1 ? true : false,
                  title: Text(
                    'Payment',
                    style: TextStyle(fontSize: 12),
                  ),
                  content: SecondWidget(context: context).secondWidget),
              Step(
                  isActive: controller.currentStep == 2 ? true : false,
                  title: Text(
                    "Confirmation",
                    style: TextStyle(fontSize: 12),
                  ),
                  content: ThirdWidget(context: context).thirdWidget)
            ],
            controlsBuilder: (context, details) {
              return Padding(padding: EdgeInsets.all(0));
            },
            // (BuildContext context,
            //     {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
            //   return Padding(padding: EdgeInsets.all(0));
            // }
          ),
        )),
        Obx(
          () => controller.currentStep == 2
              ? Container()
              : controller.showNewAddressForm.value
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        if (controller.currentStep == 1) {
                          if (controller.paymentMethod.value == "") {
                            Get.snackbar(
                                "Alert", "Please select any payment method",
                                icon: Icon(Icons.person, color: Colors.white),
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.white,
                                animationDuration: Duration(microseconds: 100),
                                backgroundColor: Colors.black);
                          } else {
                            controller.continued();
                          }
                        } else if (controller.currentStep == 0) {
                          final startOfToday = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          );
                          var isPast =
                              controller.dateTime.value.isBefore(startOfToday);
                          if (controller.selectedAddress.value.id.toString() ==
                                  "" ||
                              controller.selectedAddress.value.id.toString() ==
                                  "null" ||
                              controller.landmarkDropDownValue.value
                                      .toString() ==
                                  "Select a landmark") {
                            Get.snackbar("Alert",
                                " Please select an address and landmark in edit address",
                                icon: Icon(Icons.person, color: Colors.white),
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.white,
                                animationDuration: Duration(microseconds: 100),
                                backgroundColor: Colors.black);
                          } else {
                            if (isPast) {
                              Get.snackbar(
                                  "Alert", "Please select a delivery date",
                                  icon: Icon(Icons.person, color: Colors.white),
                                  snackPosition: SnackPosition.BOTTOM,
                                  colorText: Colors.white,
                                  animationDuration:
                                      Duration(microseconds: 100),
                                  backgroundColor: Colors.black);
                            } else {
                              controller.continued();
                            }
                          }
                        }
                      },
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AppButton(buttonTitle: "Continue").myButton),
                    ),
        ),
        Obx(
          () => controller.currentStep != 2
              ? Container()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // height: 250,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        cartController.subTotalDiscount > 0
                            ? Container(
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
                                            child: Text(
                                              "You Saved",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(":"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Obx(() => Text(
                                                  "\₹" +
                                                      cartController
                                                          .subTotalDiscount
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))))
                                  ],
                                ),
                              )
                            : SizedBox(),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                cartController.subTotal
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ))))
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "+ \₹" +
                                            (cartController.subTotal.value <
                                                        double.parse(appConfigController
                                                                    .appConfig
                                                                    .value
                                                                    .no_shipping_charge_criteria_amount ==
                                                                null
                                                            ? "0"
                                                            : appConfigController
                                                                .appConfig
                                                                .value
                                                                .no_shipping_charge_criteria_amount
                                                                .toString())
                                                    ? appConfigController
                                                        .appConfig
                                                        .value
                                                        .shipping_fee!
                                                        .toStringAsFixed(1)
                                                    : "0")
                                                .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Promo Code"))),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(":"))),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "- " +
                                            "\₹" +
                                            cartController.promoCodeValue
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        "+ \₹" +
                                            cartController.totalTax
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )))
                            ],
                          ),
                        ),
                        controller.serviceType.value !=
                                AppConstraints.type.keys.first
                            ? SizedBox()
                            : Container(
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
                                            child:
                                                Text("Urgent Service Charge"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(":"))),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "+ " +
                                                  "\₹" +
                                                  cartController
                                                      .serviceCharge()
                                                      .toString(),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              cartController.total
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                    if (!controller.orderProcessStarted.value) {
                                      if (signInController.id.value.trim() !=
                                              "null" &&
                                          signInController.id.value.trim() !=
                                              "") {
                                        var jsonarr = [];

                                        cartController.cartItems
                                            .forEach((element) {
                                          Product product = element.product!;
                                          product.size = '';
                                          element.product = product;
                                          jsonarr.add(element);
                                        });
                                        if (controller.status.value ==
                                            "Loading") {
                                          CommonTool().showInSnackBar(
                                            "Order is processing",
                                            context,
                                            bgcolor: Colors.black87,
                                          );
                                        } else {
                                          Map<String, dynamic> rawdata =
                                              cartController.toJson(jsonarr);
                                          controller.checkoutOrder(
                                              rawdata, 2, context);
                                        }
                                      } else {
                                        Get.toNamed(MyPagesName.SignIn);
                                      }
                                    } else {
                                      CommonTool().showInSnackBar(
                                        "Order is processing",
                                        context,
                                        bgcolor: Colors.black87,
                                      );
                                    }
                                  },
                                  child: controller.status.value == "Loading"
                                      ? AppButton(buttonTitle: "Checkout")
                                          .myCustomButton(
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Processing ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                  width: 15,
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : AppButton(buttonTitle: "Place Order")
                                          .myButton,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        )
      ]),
    );
  }
}
