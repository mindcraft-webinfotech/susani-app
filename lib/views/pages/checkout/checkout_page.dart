import 'dart:convert';

import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/models/Landmarks.dart';
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

class CheckoutPage extends StatelessWidget {
  var controller = Get.put(CheckoutController());
  var signInController = Get.put(SignInController());
  var cartController = Get.put(CartController());
  var appConfigController = Get.put(MyAppConfigController());
  var addressController = Get.put(AddressController());

  CheckoutPage() {
    addressController.loadAddress(signInController.user.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
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
              print(step);
              if (step == 1) {
                print(
                    "${controller.landmarkDropDownValue.value} ----- ${controller.selectedId.value}---");
                if (controller.selectedId.value != "" ||
                    controller.landmarkDropDownValue.value ==
                        "Select a landmark" ||
                    controller.landmarkDropDownValue.value == "") {
                  Get.snackbar("Alert", "Please select an address and landmark",
                      icon: Icon(Icons.person, color: Colors.white),
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      animationDuration: Duration(microseconds: 100),
                      backgroundColor: Colors.black);
                } else {
                  controller.tapped(step);
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
            // currentStep: controller.currentStep.value,
            // onStepContinue: controller.continued(),
            steps: [
              Step(
                  isActive: controller.currentStep == 0 ? true : false,
                  title: Text(
                    "Personal Info",
                    style: TextStyle(fontSize: 12),
                  ),
                  // subtitle: Text(
                  //   "Perisonal Info",
                  //   style: TextStyle(fontSize: 10),
                  // ),

                  content:
                      // new Container(child: Text("hello"))),
                      new FirstWidget(context: context).firstWidget),
              Step(
                  isActive: controller.currentStep == 1 ? true : false,
                  title: Text(
                    'Payment',
                    style: TextStyle(fontSize: 12),
                  ),
                  // subtitle: Text(
                  //   "Payment",
                  //   style: TextStyle(fontSize: 10),
                  // ),
                  content: SecondWidget(context: context).secondWidget),
              Step(
                  isActive: controller.currentStep == 2 ? true : false,
                  title: Text(
                    "Confirmation",
                    style: TextStyle(fontSize: 12),
                  ),
                  // subtitle: Text(
                  //   "Confirmation",
                  //   style: TextStyle(fontSize: 10),
                  // ),
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
                                                        double.parse(
                                                            appConfigController
                                                                .appConfig
                                                                .no_shipping_charge_criteria_amount
                                                                .toString())
                                                    ? appConfigController
                                                        .appConfig.shipping_fee!
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
                                      print("testing----->1");
                                      if (signInController.id.value.trim() !=
                                              "null" &&
                                          signInController.id.value.trim() !=
                                              "") {
                                        print("testing----->2");
                                        var jsonarr = [];

                                        cartController.cartItems
                                            .forEach((element) {
                                          jsonarr.add(element);
                                        });
                                        if (controller.status.value ==
                                            "Loading") {
                                          print("testing----->3");
                                          CommonTool().showInSnackBar(
                                            "Order is processing",
                                            context,
                                            bgcolor: Colors.black87,
                                          );
                                        } else {
                                          print("testing----->4");
                                          Map<String, dynamic> rawdata =
                                              cartController.toJson(jsonarr);
                                          controller.checkoutOrder(
                                              rawdata, 2, context);
                                        }
                                      } else {
                                        print("testing----->5");
                                        Get.toNamed(MyPagesName.SignIn);
                                      }
                                    } else {
                                      print("testing----->6");
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
