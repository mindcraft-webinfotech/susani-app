import 'dart:convert';

import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/models/Landmarks.dart';
import 'package:Susani/views/pages/WebView/MyWebView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/utils/routes_pages/pages_name.dart';
import '../../services/PayUMoney.dart';

class CheckoutController extends GetxController {
  var currentStep = 0.obs;
  var showNewAddressForm = false.obs;
  var selectedId = 0.obs;
  var paymentMethod = "".obs;
  var selectedAddress = new Address().obs;
  var status = "".obs;
  var order_id = "".obs;
  var orderProcessStarted = false.obs;
  var dateTime = new DateTime.now().obs;
  var serviceType = AppConstraints.type_for_pin_unavailable.keys.last.obs;
  var landMarksList = <Landmarks>[].obs;
  var landmarknames = <String>[].obs;
  var landmarkDropDownValue = "".obs;

  tapped(int step) {
    currentStep.value = step;
    // print(currentStep);
  }

  continued() {
    currentStep < 2 ? currentStep.value += 1 : null;
  }

  cancel() {
    currentStep.value > 0 ? currentStep.value -= 1 : null;
  }

  void checkoutOrder(Map<String, dynamic> data1, int i, BuildContext context,
      {String name = ""}) {
    //print(data);
    status.value = "Loading";
    print("Ordering");
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

  void getAllLandMarks(int userid, String zip) {
    status.value = "Loading";
    landmarknames.clear();
    landMarksList.clear();
    landmarkDropDownValue.value = "";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.allLandmarks(userid, zip);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          status.value = "Done";
          landMarksList.value =
              re.map<Landmarks>((e) => Landmarks.fromJson(e)).toList();
          landMarksList.forEach((element) {
            landmarknames.add(element.name!);
            print("testing1234.........>${element.name}");
          });
          if (landmarknames.length > 0) {
            landmarknames.add("Select a landmark");
            landmarkDropDownValue.value =
                landmarknames[landmarknames.length - 1];
            print("testing5678.........>");
          } else {
            print("Landmark not found Please select any other Area PIN");
          }
        } else {
          status.value = "Failed: " + msg;
        }
      } else {
        status.value = "Failed with exception";
      }
    });
  }
}
