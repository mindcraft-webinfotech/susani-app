import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/Address.dart';
import '../app_button.dart';

class AddressFormField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressFormField();
  }
}

enum RadioFieldData { House_apartment, Agency_Company }

class _AddressFormField extends State<AddressFormField> {
  var addressController = Get.put(AddressController());
  var signinController = Get.put(SignInController());
  var checkoutController = Get.put(CheckoutController());
  static final _formKey = GlobalKey<FormState>();
  RadioFieldData _site = RadioFieldData.House_apartment;
  String name = "",
      contact = "",
      address = "",
      city = "",
      zip = "",
      landmark = "",
      state = "",
      address_type = "";

  @override
  Widget build(BuildContext context) {
    return addressController.addressForEdit.value.id == null
        ? Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text("Name",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      TextFormField(
                        // The validator receives the text that the user has entered.
                        onChanged: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Phone number",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          contact = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("City / District",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            TextFormField(
                              onChanged: (value) {
                                city = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PIN Code",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                zip = value;
                                checkoutController.getAllLandMarks(
                                    int.parse(signinController.id.value), zip);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("State",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            TextFormField(
                              onChanged: (value) {
                                state = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter State';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Landmark",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            Container(
                              child: Obx(
                                () => checkoutController.landmarknames.length >
                                        0
                                    ? DropdownButton<String>(
                                        value: checkoutController
                                            .landmarkDropDownValue.value,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        onChanged: (String? newValue) {
                                          checkoutController
                                              .landmarkDropDownValue
                                              .value = newValue!;
                                          landmark = newValue;
                                        },
                                        items: checkoutController.landmarknames
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )
                                    : Container(),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      TextFormField(
                        onChanged: (value) {
                          address = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                // Container(
                //   alignment: Alignment.topLeft,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       ListTile(
                //         title: const Text('House / Apartment',
                //             style: TextStyle(fontWeight: FontWeight.w700)),
                //         leading: Radio(
                //           value: RadioFieldData.House_apartment,
                //           groupValue: _site,
                //           onChanged: (value) {
                //             setState(() {
                //               _site = value as RadioFieldData;
                //               address_type = _site.toString().split(".")[1];
                //             });
                //           },
                //         ),
                //       ),
                //       ListTile(
                //         title: const Text('Agency / Company',
                //             style: TextStyle(fontWeight: FontWeight.w700)),
                //         leading: Radio(
                //           value: RadioFieldData.Agency_Company,
                //           groupValue: _site,
                //           onChanged: (value) {
                //             setState(() {
                //               _site = value as RadioFieldData;
                //               address_type = _site.toString().split(".")[1];
                //             });
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // // -------------------------submit button
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Seving Data..')));
                      Address address = new Address();
                      address.name = name;
                      address.contact = contact;
                      address.landmark = landmark;
                      address.state = state;
                      address.city = city;
                      address.pincode = zip;
                      address.address = this.address;
                      address.address_type = address_type;
                      address.user_id = signinController.id.toString();
                      addressController.saveData(address);
                      checkoutController.showNewAddressForm.value = false;
                      Get.defaultDialog(
                          title: "CONFIRMATION",
                          titleStyle: TextStyle(fontSize: 16),
                          middleText: "New address added.",
                          middleTextStyle: TextStyle(fontSize: 12),
                          confirm: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, elevation: 5),
                              onPressed: () {
                                Get.back();
                                if (Get.currentRoute != "/checkoutPage") {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Ok",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))),
                          contentPadding: EdgeInsets.all(20));
                    }
                  },
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AppButton(buttonTitle: "Save").myButton),
                )
              ],
            ))
        // --------------------------------- update popup----------------------------------------------------
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text("Name",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      TextFormField(
                        initialValue:
                            addressController.addressForEdit.value.name,
                        // The validator receives the text that the user has entered.
                        onChanged: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Phone number",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      TextFormField(
                        initialValue:
                            addressController.addressForEdit.value.contact,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          contact = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("City / District",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            TextFormField(
                              initialValue:
                                  addressController.addressForEdit.value.city,
                              onChanged: (value) {
                                city = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ZIP",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            TextFormField(
                              initialValue: addressController
                                  .addressForEdit.value.pincode,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                zip = value;
                                checkoutController.getAllLandMarks(
                                    int.parse(signinController.id.value), zip);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("State",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            TextFormField(
                              initialValue:
                                  addressController.addressForEdit.value.state,
                              onChanged: (value) {
                                state = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter State';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Landmark",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            Container(
                                child: DropdownButton<String>(
                              value: checkoutController
                                  .landmarkDropDownValue.value,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              onChanged: (String? newValue) {
                                landmark = newValue!;
                                checkoutController.landmarkDropDownValue.value =
                                    newValue;
                              },
                              items: checkoutController.landmarknames
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      TextFormField(
                        initialValue:
                            addressController.addressForEdit.value.address,
                        onChanged: (value) {
                          address = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                // Container(
                //   alignment: Alignment.topLeft,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       ListTile(
                //         title: const Text('House / Apartment',
                //             style: TextStyle(fontWeight: FontWeight.w700)),
                //         leading: Radio(
                //           value: RadioFieldData.House_apartment,
                //           groupValue: _site,
                //           onChanged: (value) {
                //             setState(() {
                //               _site = value as RadioFieldData;
                //               address_type = _site.toString().split(".")[1];
                //             });
                //           },
                //         ),
                //       ),
                //       ListTile(
                //         title: const Text('Agency / Company',
                //             style: TextStyle(fontWeight: FontWeight.w700)),
                //         leading: Radio(
                //           value: RadioFieldData.Agency_Company,
                //           groupValue: _site,
                //           onChanged: (value) {
                //             setState(() {
                //               _site = value as RadioFieldData;
                //               address_type = _site.toString().split(".")[1];
                //             });
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // // -------------------------submit button
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Seving Data..')));
                            Address address = new Address();
                            address.id =
                                addressController.addressForEdit.value.id;
                            address.name = name == ""
                                ? addressController.addressForEdit.value.name
                                : name;
                            address.contact = contact == ""
                                ? addressController.addressForEdit.value.contact
                                : contact;
                            address.city = city == ""
                                ? addressController.addressForEdit.value.city
                                : city;
                            address.pincode = zip == ""
                                ? addressController.addressForEdit.value.pincode
                                : zip;

                            address.landmark = landmark == ""
                                ? addressController
                                    .addressForEdit.value.landmark
                                : landmark;
                            address.state = state == ""
                                ? addressController.addressForEdit.value.state
                                : state;

                            address.address = this.address == ""
                                ? addressController.addressForEdit.value.address
                                : this.address;
                            address.address_type = address_type == ""
                                ? addressController
                                    .addressForEdit.value.address_type
                                : address_type;
                            address.user_id = signinController.id.toString();
                            addressController.updateData(address);
                            checkoutController.showNewAddressForm.value = false;
                            checkoutController.selectedAddress.value = address;
                            Get.defaultDialog(
                                title: "CONFIRMATION",
                                titleStyle: TextStyle(fontSize: 16),
                                middleText: "Address updated.",
                                middleTextStyle: TextStyle(fontSize: 12),
                                confirm: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        elevation: 5),
                                    onPressed: () {
                                      Get.back();
                                      if (Get.currentRoute != "/checkoutPage") {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text("Ok",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ))),
                                contentPadding: EdgeInsets.all(20));
                          }
                        },
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AppButton(buttonTitle: "Update").myButton),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        checkoutController.selectedAddress.value =
                            new Address();
                        addressController.deleteAddress(
                            addressController.addressForEdit.value);
                        addressController.addresses
                            .remove(addressController.addressForEdit.value);
                        checkoutController.showNewAddressForm.value = false;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(addressController
                                    .addressForEdit.value.name
                                    .toString() +
                                ' Deleted')));
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.red.shade100,
                          radius: 25,
                          child:
                              Icon(FontAwesomeIcons.trash, color: Colors.red)),
                    )
                  ],
                )
              ],
            ));
  }
}
