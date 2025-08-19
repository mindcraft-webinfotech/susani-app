import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/views/widgets/addressForm.dart';
import 'package:Susani/views/widgets/address_card_design.dart';
import 'package:Susani/views/widgets/app_button.dart';

import '../../../contollers/cart_controller/cart_controller.dart';
import '../../../contollers/signin/SignInController.dart';
import '../../pages/WebView/MyWebView.dart';

class FirstWidget {
  static var pcontroller = Get.find<ProductController>();
  static var checkoutcontroller = Get.find<CheckoutController>();
  var addressController = Get.find<AddressController>();
  var signinController = Get.find<SignInController>();
  var cartController = Get.find<CartController>();
  BuildContext context;

  FirstWidget({required this.context});

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Container get firstWidget {
    return Container(
      child: Obx(
        () {
          return checkoutcontroller.showNewAddressForm.value
              ? AddressForm.FormContainer
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Address",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                AppColor.bottomitemColor2,
                              ),
                            ),
                            onPressed: () {
                              checkoutcontroller.showNewAddressForm.value =
                                  true;
                              addressController.addressForEdit.value =
                                  new Address();
                            },
                            child: Text(
                              "SHIPPING ADDRESS",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColor.backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () {
                        print(addressController.loadAddresStatus.value +
                            "??????" +
                            addressController.addresses.length.toString());

                        return addressController.loadAddresStatus.value !=
                                "done"
                            ? Container(
                                child: Center(
                                  child:
                                      Text(addressController.status.toString()),
                                ),
                              )
                            : ListView.builder(
                                itemCount: addressController.addresses.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    AddressCardDesign(
                                  context: context,
                                  index: index,
                                  callback: (address) {
                                    checkoutcontroller
                                        .showNewAddressForm.value = true;

                                    addressController.addressForEdit.value =
                                        address;
                                  },
                                ).addressCardDesign,
                              );
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        print(
                            "${checkoutcontroller.selectedAddress.value.id.toString()} >>>>>>>>>><");
                        if (checkoutcontroller.selectedAddress.value.id
                                    .toString() ==
                                "" ||
                            checkoutcontroller.selectedAddress.value.id
                                    .toString() ==
                                "null") {
                          Get.snackbar(
                            "Alert",
                            "Please select an address",
                            icon: Icon(Icons.person, color: Colors.white),
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white,
                            animationDuration: Duration(microseconds: 100),
                            backgroundColor: Colors.black,
                          );
                        } else {
                          addressController.availablePincodes();
                          addressController.checkpinAvailability(
                            checkoutcontroller.selectedAddress.value.pincode
                                .toString(),
                          );
                          Get.toNamed(MyPagesName.CalenderPage);
                        }
                      },
                      child: Card(
                        color: AppColor.bottomitemColor2.withOpacity(0.1),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined,
                                      color: AppColor.bottomitemColor2),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Select a delivery date",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: AppColor.bottomitemColor2,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Obx(() {
                                    final selectedDate =
                                        checkoutcontroller.dateTime.value;
                                    final now = DateTime.now();
                                    // Show blank if not selected or selected date is before today
                                    if (!checkoutcontroller
                                            .isDateSelected.value ||
                                        selectedDate == null ||
                                        selectedDate.isBefore(DateTime(
                                            now.year, now.month, now.day))) {
                                      return Text(
                                        "",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      );
                                    }
                                    return Text(
                                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    );
                                  }),
                                  const SizedBox(width: 10),
                                  Obx(() {
                                    final deliveryType =
                                        checkoutcontroller.serviceType.value;
                                    return deliveryType.isNotEmpty
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.bottomitemColor2,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            child: Text(
                                              deliveryType,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
