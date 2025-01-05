import 'package:Susani/consts/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/models/Address.dart';

import '../../contollers/signin/SignInController.dart';

class AddressCardDesign {
  final BuildContext context;
  final int index;
  var addressController = Get.put(AddressController());
  var checkoutController = Get.put(CheckoutController());
  var signinController = Get.put(SignInController());
  final void Function(Address) callback;

  AddressCardDesign(
      {required this.context, required this.index, required this.callback}) {
    print("index--" + index.toString());
    print("list address--" + addressController.addresses.length.toString());
  }

  Widget get addressCardDesign => Obx(
        () => addressController.addresses.length <= 0
            ? Container()
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    callback(
                                        addressController.addresses[index]);
                                    // print("Passing data" +
                                    //     addressController.addresses[index]
                                    //         .toString());
                                  },
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.edit,
                                          size: 20,
                                          color: AppColor.bottomitemColor2),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          addressController
                                              .addresses[index].name
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name',
                                          style: TextStyle(
                                              color: AppColor.bottomitemColor1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'City',
                                          style: TextStyle(
                                              color: AppColor.bottomitemColor1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Pin',
                                          style: TextStyle(
                                              color: AppColor.bottomitemColor1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Contact',
                                          style: TextStyle(
                                              color: AppColor.bottomitemColor1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addressController
                                              .addresses[index].address
                                              .toString(),
                                          style: TextStyle(
                                              color: AppColor.iconColor2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          addressController
                                              .addresses[index].city
                                              .toString(),
                                          style: TextStyle(
                                              color: AppColor.iconColor2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          addressController
                                              .addresses[index].pincode
                                              .toString(),
                                          style: TextStyle(
                                              color: AppColor.iconColor2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          addressController
                                              .addresses[index].contact
                                              .toString(),
                                          style: TextStyle(
                                              color: AppColor.iconColor2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Obx(
                              () => Radio(
                                  value: addressController.addresses[index].id
                                      .toString(),
                                  groupValue: checkoutController
                                      .selectedId.value
                                      .toString(),
                                  onChanged: (value) {
                                    print(
                                        "----------------------??????${value}");
                                    checkoutController.selectedId.value =
                                        int.parse(value.toString());
                                    // print("radio tapped Id--->" +
                                    //     checkoutController.selectedId.value
                                    //         .toString());
                                    checkoutController.selectedAddress.value =
                                        addressController.addresses[index];
                                    // print("radio tapped Address--->" +
                                    //     checkoutController.selectedAddress.value
                                    //         .toString());
                                    checkoutController.getAllLandMarks(
                                        int.parse(signinController.id.value),
                                        addressController
                                            .addresses[index].pincode!);
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );

  Widget get addressCardDesign2 => Obx(
        () => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                addressController.addresses[index].name
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                addressController.addresses[index].address
                                        .toString() +
                                    "," +
                                    addressController.addresses[index].city
                                        .toString() +
                                    "," +
                                    addressController.addresses[index].pincode
                                        .toString() +
                                    "," +
                                    addressController
                                        .addresses[index].address_type
                                        .toString() +
                                    "\n" +
                                    addressController.addresses[index].contact
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w300)),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Obx(
                        () => Radio(
                            value: addressController.addresses[index].id
                                .toString(),
                            groupValue:
                                checkoutController.selectedId.value.toString(),
                            onChanged: (value) {
                              // print(value);
                              checkoutController.selectedId.value =
                                  int.parse(value.toString());
                              checkoutController.selectedAddress.value =
                                  addressController.addresses[index];
                            }),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
}
