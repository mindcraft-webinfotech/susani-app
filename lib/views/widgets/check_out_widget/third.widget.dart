import 'dart:math';

import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/app_config/AppConfigController.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/coupon_controller/CouponController.dart';
import 'package:Susani/contollers/promocode_controller/PromoCodeController.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/models/Coupon.dart';
import 'package:Susani/views/widgets/app_button.dart';

class ThirdWidget {
  final BuildContext context;
  var appConfigController = Get.put(MyAppConfigController());
  var signInController = Get.put(SignInController());
  var controller = Get.put(CartController());
  var checkoutController = Get.put(CheckoutController());
  static var addressController = Get.put(AddressController());
  static var couponController = Get.put(CouponController());
  var address = Address().obs;
  final couponFieldController = TextEditingController();
  String couponCode = "";

  ThirdWidget({required this.context}) {
    couponController.status.value = "";
    checkoutController.selectedId.value.toString();

    for (var add in addressController.addresses) {
      if (add.id.toString() == checkoutController.selectedId.value.toString()) {
        address.value = add;
      }
    }
  }
  Container get thirdWidget => Container(
        child: Center(
            child: Obx(
          () => controller.cartItems.length > 0
              ? Column(
                  children: [
                    Card(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(address.value.name.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Text(
                                        '${checkoutController.dateTime.value.day}/${checkoutController.dateTime.value.month}/${checkoutController.dateTime.value.year}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Spacer(flex: 1),
                                      GestureDetector(
                                          onTap: () {
                                            Get.toNamed(
                                                MyPagesName.CalenderPage);
                                          },
                                          child: Icon(
                                              Icons.edit_calendar_outlined)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                address.value.address.toString() +
                                    "," +
                                    address.value.city.toString() +
                                    "," +
                                    address.value.pincode.toString() +
                                    "," +
                                    address.value.address_type.toString() +
                                    "\n" +
                                    address.value.contact.toString() +
                                    "\n" +
                                    checkoutController
                                        .landmarkDropDownValue.value,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: Get.size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(checkoutController.paymentMethod.value,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                "Payment will be done by " +
                                    checkoutController.paymentMethod.value,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(checkoutController.serviceType.value,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                AppConstraints.type[
                                    checkoutController.serviceType.value]!,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: Get.size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(MyPagesName.giftCards);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.black, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      elevation: 0,
                                      margin: EdgeInsets.all(0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5, left: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Promo codes",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            Icon(FontAwesomeIcons.chevronRight)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: couponFieldController,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Coupon Code",
                                      border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Coupon cpn = new Coupon();
                                        cpn.coupon_code =
                                            couponFieldController.text;
                                        if (couponFieldController.text != "" &&
                                            couponController.status.value !=
                                                "Loading") {
                                          couponController
                                              .getCouponByCoupon(cpn);
                                        } else {
                                          couponController.status.value =
                                              "Field is empty";
                                        }
                                      },
                                      child: AppButton(buttonTitle: "Apply")
                                          .myButton,
                                    ))
                              ],
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  Expanded(
                                      child:
                                          Text(couponController.status.value))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Image.asset(
                  "assets/images/empty_cart.png",
                  height: 140,
                  width: 140,
                ),
        )),
      );
}
