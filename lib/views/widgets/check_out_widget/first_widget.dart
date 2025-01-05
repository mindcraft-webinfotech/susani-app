import 'package:Susani/consts/app_color.dart';
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

import '../../../contollers/signin/SignInController.dart';
import '../../pages/WebView/MyWebView.dart';

class FirstWidget {
  static var controller = Get.put(CheckoutController());
  static var addressController = Get.put(AddressController());
  var signinController = Get.put(SignInController());
  BuildContext context;

  FirstWidget({required this.context});

  var addressindex = "".obs;

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
            ));
  }

  @override
  void initState() {
    controller.landmarkDropDownValue.value = "";
  }

  @override
  Container get firstWidget => Container(

          // height: Get.size.height + 100,
          child: Obx(
        () => controller.showNewAddressForm.value
            ? AddressForm.FormContainer
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Address",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColor.bottomitemColor2)),
                          onPressed: () {
                            print("please add address...........>");
                            controller.showNewAddressForm.value = true;
                            addressController.addressForEdit.value =
                                new Address();
                          },
                          child: Text("SHIPPING ADDRESS",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.backgroundColor)),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => addressController.status.value != "done"
                        ? Container(
                            child: Center(
                              // child: Text("Address not found "),
                              child: Text(addressController.status.toString()),
                            ),
                          )
                        : ListView.builder(
                            itemCount: addressController.addresses.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => AddressCardDesign(
                                context: context,
                                index: index,
                                callback: (address) {
                                  addressindex.value = addressController
                                      .addresses[index].landmark
                                      .toString();
                                  addressController.addressForEdit.value =
                                      address;
                                  print(
                                      "test address name" + addressindex.value);
                                  controller.showNewAddressForm.value = true;
                                  controller.getAllLandMarks(
                                      int.parse(signinController.id.value),
                                      addressController
                                          .addressForEdit.value.pincode!);
                                }).addressCardDesign),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Select Landmark",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(15),
                            child: controller.landmarknames.length > 0
                                ?
                                // Text("helo")
                                DropdownButton<String>(
                                    value:
                                        controller.landmarkDropDownValue.value,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    onChanged: (String? newValue) {
                                      controller.landmarkDropDownValue.value =
                                          newValue!;
                                    },
                                    items: controller.landmarknames.value
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onTap: () {
                                      print("dropdown pressed");
                                    },
                                  )
                                : Container(
                                    child: Text("Select Landmark"),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print(
                          ">>>>>>>?????${controller.selectedId.value} ---${controller.landmarkDropDownValue.value}");
                      if (controller.selectedId.value < 0 ||
                          (controller.landmarkDropDownValue.value ==
                                  "Select a landmark" ||
                              controller.landmarkDropDownValue.value == "")) {
                        Get.snackbar(
                            "Alert", " Please select an address and landmark",
                            icon: Icon(Icons.person, color: Colors.white),
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white,
                            animationDuration: Duration(microseconds: 100),
                            backgroundColor: Colors.black);
                      } else {
                        print("Addresss------------->" +
                            controller.selectedAddress.value.id.toString());

                        print("landmark-------------->" +
                            controller.landmarkDropDownValue.value.toString());

                        addressController.availablePincodes();
                        addressController.checkpinAvailability(controller
                            .selectedAddress.value.pincode
                            .toString());
                        Get.toNamed(MyPagesName.CalenderPage);
                      }
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AppButton(buttonTitle: "Continue").myButton),
                  )
                ],
              ),
      ));
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
