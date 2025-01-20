import 'dart:convert';

import 'package:Susani/models/fast_available_pincodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/Address.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/models/User.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:intl/intl.dart';

class AddressController extends GetxController {
  var signinController = Get.put(SignInController());
  var checkoutController = Get.put(CheckoutController());

  var dateController = TextEditingController().obs;
  late DateTime _selectedDate;
  var available_Pincodes = <Pincode>[].obs;
  var addresses = <Address>[].obs;
  var status = "".obs;
  var pincode_status = "".obs;
  var addressForEdit = new Address().obs;
  var isPinAvailable = "no".obs;

  @override
  void onInit() {
    availablePincodes();
    signinController.user.value.id = signinController.id.value;
    loadAddress(signinController.user.value);
    super.onInit();
  }

  @override
  void onReady() {
    availablePincodes();
    signinController.user.value.id = signinController.id.value;
    loadAddress(signinController.user.value);
    super.onReady();
  }

  void loadAddress(User user) {
    if (user.id != "0" && user.id != "" && user.id != "null") {
      status.value = "loading";
      Future.delayed(Duration(seconds: 1), () async {
        http.Response response = await MyApi.loadAddress(user);
        print("===========>>>>>>>>>loadAddress");
        print(response.body);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          String res = data['res'];
          String msg = data['msg'];
          if (res == "success") {
            var re = data['data'] as List;
            addresses.value =
                re.map<Address>((e) => Address.fromJson(e)).toList();
            status.value = "done";
            if (addresses.length > 0) {
              status.value = "done";
            } else {
              checkoutController.showNewAddressForm.value = true;
              status.value = "No address found";
            }
          } else {
            status.value = "Something went wrong";
          }
        } else {
          status.value = "Something went wrong";

          //throw Exception('Failed to load album');
        }
      });
    } else {
      status.value = "Not loged in";
    }
  }

  var addressMessage = "".obs;
  var addressStatus = false.obs;

  void saveData(Address address) {
    if (address != "null") {
      addressMessage.value = "running";
      Future.delayed(Duration(seconds: 1), () async {
        http.Response response = await MyApi.saveAddress(address);
        // print(response.body);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          String res = data['res'];
          String msg = data['msg'];
          if (res == "success") {
            var re = data['data'] as List;
            addresses.value =
                re.map<Address>((e) => Address.fromJson(e)).toList();
            if (addresses.length > 0) {
              status.value = "done";
            } else {
              status.value = "No saved addresss found";
            }
            addressStatus.value = true;
            addressMessage.value = data['msg'];

            // Get.toNamed(MyPagesName.SignIn);
          } else {
            addressStatus.value = false;
            addressMessage.value = data['msg'];
          }
        } else {
          addressStatus.value = false;
          addressMessage.value = "server error";
        }
      });
    }
  }

  void updateData(Address address) {
    if (address != "null") {
      addressMessage.value = "running";
      Future.delayed(Duration(seconds: 1), () async {
        http.Response response = await MyApi.updateAddress(address);
        print(response.body);
        if (response.statusCode == 200 && response.body != '') {
          var data = jsonDecode(response.body);
          String res = data['res'];
          String msg = data['msg'];
          if (res == "success") {
            var re = data['data'] as List;
            addresses.value =
                re.map<Address>((e) => Address.fromJson(e)).toList();
            if (addresses.length > 0) {
              status.value = "done";
            } else {
              status.value = "No saved addresss found";
            }
            addressStatus.value = true;
            addressMessage.value = data['msg'];

            // Get.toNamed(MyPagesName.SignIn);
          } else {
            addressStatus.value = false;
            addressMessage.value = data['msg'];
          }
        } else {
          addressStatus.value = false;
          addressMessage.value = "server error";
        }
      });
    }
  }

  void availablePincodes() {
    pincode_status.value = "Loading";
    print("available Pincodes");
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getAvailablePincodes();

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          pincode_status.value = "Done";
          available_Pincodes.value =
              re.map<Pincode>((e) => Pincode.fromJson(e)).toList();
          print("---------- available Pincodes" + available_Pincodes.value.length.toString());
        } else {
          pincode_status.value = "Failed: " + msg;
        }
      } else {
        pincode_status.value = "Failed with exception";
      }
    });
  }

  void deleteAddress(Address address) {
    User user = new User();
    user.id = signinController.id.toString();

    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.deleteAddress(user, address);
      // print(
      //     "===>>deletion " + user.id.toString() + "-" + address.id.toString());
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];

        if (res == "success") {
          var re = data['data'] as List;
          addresses.value =
              re.map<Address>((e) => Address.fromJson(e)).toList();
        } else {}
      } else {
        //throw Exception('Failed to load album');
      }
    });
  }

  void checkpinAvailability(String pincode) {
    isPinAvailable.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.checkpinAvailability(pincode);
      print("----------÷------------------------checkpinAvailability");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data);

        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          if (data["is_available"] == "yes") {
            isPinAvailable.value = "yes";
          } else {
            isPinAvailable.value = "no";
          }
        } else {
          isPinAvailable.value = "Failed";
        }
      } else {
        isPinAvailable.value = "Failed";
      }
    });
  }

//show Date Dialog

  void showDatePickerDialog() {
    Get.dialog(
        Dialog(
          child: Container(
            height: 300,
            color: Colors.grey.shade900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: const Text(
                    "Pick Date",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 150,
                  child: DatePickerWidget(
                    looping: false, // default is not looping
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),

                    //    firstDate: DateTime.now(),
                    //lastDate: DateTime.now(),
                    //DateTime(1960),
                    //  lastDate: DateTime(2002, 1, 1),
//              initialDate: DateTime.now(),// DateTime(1994),
                    dateFormat: "dd-MMMM-yyyy",

                    //   "dd-MMMM-yyyy",
                    //     locale: DatePicker.localeFromString('he'),
                    onChange: (DateTime newDate, _) {
                      _selectedDate = newDate;

                      print(newDate.toString());
                      //print(_selectedDate);
                    },
                    pickerTheme: DateTimePickerTheme(
                      backgroundColor: Colors.grey.shade900,
                      itemTextStyle:
                          TextStyle(color: Colors.white, fontSize: 19),
                      dividerColor: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: 165,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.black),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                //fontFamily: fNSfUiSemiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_selectedDate != null) {
                            Get.back();
                            final DateFormat formatter =
                                DateFormat('dd-MMM-yyyy');
                            final String formatted =
                                formatter.format(_selectedDate);
                            dateController.value.text = formatted;
                          } else {
                            //           Get.snackbar(
                            //     'Error',
                            //     'Successfully created',
                            //     snackPosition: SnackPosition.BOTTOM
                            // );
                            // Get.showSnackbar();
                            // AppToast.myToast("Please Enter Date");
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 165,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.black),
                          child: Center(
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 16,
                                // fontFamily: fNSfUiSemiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
