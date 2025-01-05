import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/views/widgets/address_card_design.dart';

class ShippingAddressPage extends StatelessWidget {
  ShippingAddressPage({Key? key}) : super(key: key);
  var addressController = Get.put(AddressController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              )),
          centerTitle: true,
          title: const Text(
            "My Shipping Address",
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Obx(
            () => ListView.builder(
                itemCount: addressController.addresses.length == 0
                    ? 1
                    : addressController.addresses.length,
                itemBuilder: (context, index) =>
                    addressController.addresses.length > 0
                        ? AddressCardDesign(
                                context: context,
                                index: index,
                                callback: (address) {})
                            .addressCardDesign2
                        : Container(
                            child: Center(
                              child: Text(addressController.status.value),
                            ),
                          )),
          ),
        ));
  }
}
