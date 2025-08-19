// import 'dart:ffi'; // Removed to resolve 'Size' conflict

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
  var addressController = Get.find<AddressController>();
  var checkoutController = Get.find<CheckoutController>();
  var signinController = Get.find<SignInController>();
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
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    checkoutController.selectedAddress.refresh();
                    checkoutController.selectedAddress.value =
                        addressController.addresses[index];
                    checkoutController.selectedAddress.refresh();

                    checkoutController.dateTime.value = DateTime.utc(1970);

                    await checkoutController.getAllLandMarks(
                        int.parse(signinController.id.value),
                        addressController.addresses[index].pincode ?? '');
                    checkoutController.landmarkDropDownValue.value =
                        checkoutController.selectedAddress.value.landmark ?? '';
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name/Contact
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Name/Contact: ',
                                            style: TextStyle(
                                              color: AppColor.bottomitemColor1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: addressController
                                                    .addresses[index].name
                                                    .toString() +
                                                '/' +
                                                addressController
                                                    .addresses[index].contact
                                                    .toString(),
                                            style: TextStyle(
                                              color: AppColor.iconColor2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 4),
                                    // City/Address
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'City/Address: ',
                                            style: TextStyle(
                                              color: AppColor.bottomitemColor1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: addressController
                                                    .addresses[index].city
                                                    .toString() +
                                                "/" +
                                                addressController
                                                    .addresses[index].address
                                                    .toString(),
                                            style: TextStyle(
                                              color: AppColor.iconColor2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 4),
                                    // Pin
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Pin: ',
                                            style: TextStyle(
                                              color: AppColor.bottomitemColor1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: addressController
                                                .addresses[index].pincode
                                                .toString(),
                                            style: TextStyle(
                                              color: AppColor.iconColor2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 4),
                                    // Landmark
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Landmark: ',
                                            style: TextStyle(
                                              color: AppColor.bottomitemColor1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: addressController
                                                .addresses[index].landmark
                                                .toString(),
                                            style: TextStyle(
                                              color: AppColor.iconColor2,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Obx(
                                    () => Radio(
                                      value: checkoutController
                                          .selectedAddress.value.id
                                          .toString(),
                                      groupValue: checkoutController
                                          .selectedAddress.value.id,
                                      onChanged: (value) async {
                                        checkoutController.dateTime.value =
                                            DateTime.utc(1970);
                                        checkoutController
                                                .selectedAddress.value =
                                            addressController.addresses[index];
                                        await checkoutController
                                            .getAllLandMarks(
                                                int.parse(
                                                    signinController.id.value),
                                                addressController
                                                        .addresses[index]
                                                        .pincode ??
                                                    '')
                                            .then(
                                          (value) {
                                            addressController.loadAddress(
                                                signinController.user.value);
                                          },
                                        );
                                        checkoutController.landmarkDropDownValue
                                            .value = checkoutController
                                                .selectedAddress
                                                .value
                                                .landmark ??
                                            '';
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      callback(
                                          addressController.addresses[index]);
                                      await checkoutController.getAllLandMarks(
                                          int.parse(signinController
                                              .user.value.id
                                              .toString()),
                                          addressController
                                              .addresses[index].pincode
                                              .toString());
                                      checkoutController.landmarkDropDownValue
                                          .value = addressController
                                              .addresses[index].landmark ??
                                          '';
                                      print("On click of edit ");
                                      print(addressController.addresses);
                                    },
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            AppColor.bottomitemColor2,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        minimumSize: const Size(36, 24),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed:
                                          null, // Disabled to prevent double tap
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                                        .addresses[index].addressType
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
                            groupValue: checkoutController
                                .selectedAddress.value.id
                                .toString(),
                            onChanged: (value) {
                              addressController.selectedAddress.value =
                                  "${addressController.addresses[index].name} ,${addressController.addresses[index].city},${addressController.addresses[index].pincode}";
                              checkoutController.selectedAddress.value =
                                  addressController.addresses[index];
                              checkoutController.getAllLandMarks(
                                  int.parse(signinController.id.value),
                                  addressController.addresses[index].pincode
                                      .toString());
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
