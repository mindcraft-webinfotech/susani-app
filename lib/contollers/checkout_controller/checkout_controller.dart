import 'dart:convert';

import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/Landmarks.dart';
import 'package:Susani/views/pages/WebView/MyWebView.dart';
import 'package:Susani/views/pages/ecom/utils/color_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/utils/routes_pages/pages_name.dart';
import '../../services/PayUMoney.dart';

class CheckoutController extends GetxController {
  var currentStep = 0.obs;
  var showNewAddressForm = false.obs;
  var paymentMethod = "".obs;
  var selectedAddress = new Address().obs;
  var status = "".obs;
  var order_id = "".obs;
  var orderProcessStarted = false.obs;
  var dateTime = new DateTime.utc(1970).obs;
  var serviceType = AppConstraints.type_for_pin_unavailable.keys.last.obs;
  var landMarksList = <Landmarks>[].obs;
  var landmarknames = <String>[].obs;
  var landmarkDropDownValue = "".obs;
  var signinController = Get.put(SignInController());

  RxBool isDateSelected = false.obs;

  var pincodeVerified = false.obs;

  tapped(int step) {
    currentStep.value = step;
  }

  continued() {
    currentStep.value = currentStep.value < 2 ? currentStep.value += 1 : 0;
  }

  cancel() {
    currentStep.value > 0 ? currentStep.value -= 1 : null;
  }

  void checkoutOrder(Map<String, dynamic> data1, int i, BuildContext context,
      {String name = ""}) {
    //print(data);
    status.value = "Loading";
    print("Ordering makeOrder");
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.makeOrder(data1);
      print("Printing data: ------------------------------------- response");
      print(response.body.toString());
      print(response.body);
      if (response.statusCode == 200) {
        status.value = "done";

        print(response.body);
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          order_id.value = data['order_id'];

          status.value = "success";
          orderProcessStarted.value = true;
          if (paymentMethod.value == AppConstraints.paymentMethods[2]) {
            var rawdata = data1;
            rawdata["order_id"] = order_id.value;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    RazorPayment(rawdata: rawdata),
              ),
            );
            orderProcessStarted.value = false;
          } else {
            Get.offNamed(MyPagesName.OrderSuccess);
          }
        } else {
          status.value = "" + msg;
        }
      } else {
        status.value = "failed";
        //throw Exception('Failed to load album');
      }
    });
  }

  Future<void> getAllLandMarks(int userid, String zip) async {
    status.value = "Loading";
    landmarknames.clear();
    landMarksList.clear();
    landmarkDropDownValue.value = "";

    try {
      // Remove the Future.delayed as it's not needed for async operations
      final response =
          await MyApi.allLandmarks(userid, zip, selectedAddress.value.id ?? '');
      print("get all landmarks");
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final res = data['res'] as String;
        final msg = data['msg'] as String;

        if (res == "success") {
          final re = data['data'] as List;
          status.value = "Done";
          landMarksList.value =
              re.map<Landmarks>((e) => Landmarks.fromJson(e)).toList();

          // Process landmarks
          for (final element in landMarksList) {
            if (element.name != null &&
                element.name!.isNotEmpty &&
                element.name != "  " &&
                element.name != "null") {
              landmarknames.add(
                  '${element.name ?? "not available"}  ( ${element.id.toString()} )');
            }
          }

          if (landmarknames.isNotEmpty) {
            landmarknames.add("Select a landmark");
            landmarkDropDownValue.value = landmarknames.last;
            pincodeVerified.value = true;

            Get.snackbar(
              "Success",
              "Pincode is deliverable.",
              colorText: Colors.white,
              duration: Duration(seconds: 1),
              backgroundColor: primaryColor,
              margin: EdgeInsets.all(20),
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            _showPincodeError();
          }
        } else {
          pincodeVerified.value = false;
          status.value = "Failed: $msg";
        }
      } else {
        pincodeVerified.value = false;
        status.value = "Failed with status code: ${response.statusCode}";
      }
    } catch (e) {
      pincodeVerified.value = false;
      status.value = "Failed with exception: ${e.toString()}";
      print("Error in getAllLandMarks: $e");
    }
  }

  void _showPincodeError() {
    Get.snackbar(
      "Oops..",
      "Pincode not deliverable. Please Change your Shipping Address PIN",
      colorText: Colors.white,
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(20),
      snackPosition: SnackPosition.BOTTOM,
    );
    print("Landmark not found. Please select any other Area PIN");
  }
}
