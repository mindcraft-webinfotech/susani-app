import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/views/widgets/check_out_widget/AddressFormFields.dart';

class AddressForm {
  static var controller = Get.find<CheckoutController>();
  static var addressController = Get.find<AddressController>();

  static Container get FormContainer => Container(
          child: GestureDetector(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  addressController.addressForEdit.value.id == null
                      ? "New Shipping Address"
                      : "Update Shipping Address",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                GestureDetector(
                    onTap: () {
                      controller.showNewAddressForm.value = false;
                      controller.showNewAddressForm.refresh();
                      print(" controller.showNewAddressForm address form");
                      print(controller.showNewAddressForm.value);
                    },
                    child: CircleAvatar(radius: 15, child: Icon(Icons.close)))
              ],
            ),
            AddressFormField()
          ],
        ),
      ));
}
