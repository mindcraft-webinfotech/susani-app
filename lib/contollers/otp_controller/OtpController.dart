import 'dart:convert';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/contollers/signup/SignUpController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/models/User.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';

class OtpController extends GetxController {
  var signupStatus = false.obs;
  var signupMessage = "".obs;
  var isChecked = false.obs;
  var userOtp = "".obs;
  var serverOtp = "".obs;
  var message = "".obs;
  var controller = Get.put(SignUpController());
  var signInController = Get.put(SignInController());
  void sendOtp(String mobile, String type, User user) {
    signupMessage.value = "running";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.sendOtp(mobile, type);
      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        String res = data['status'];
        String otp = data['otp'].toString();
        if (res == "success") {
          serverOtp.value = otp;
          otpPopUp(user, type);
        } else {
          signupStatus.value = false;
          signupMessage.value = "server error";
        }
      } else {
        signupStatus.value = false;
        signupMessage.value = "server error";
      }
    });
  }

  void otpPopUp(User user, String type) {
    Get.defaultDialog(
        title: "Enter OTP",
        titleStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        confirm: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, elevation: 5),
            onPressed: () {
              var newotp = int.parse(serverOtp.value) - 1915;
              // print(
              //     "new otp:======= ${userOtp.value} -- $newotp--${serverOtp.value}" +
              //         (userOtp.value == newotp.toString()).toString());
              if (userOtp.value == newotp.toString()) {
                message.value = "Otp verified";
                Get.back();
                if (type == "registration") {
                  controller.saveData(user);
                } else if (type == "login") {
                  signInController.signIn(user, signIntType: "otp");
                } else if (type == "forgot-pass") {
                  signInController.forgotByMobile(user.contact.toString());
                }
              } else {
                message.value = "Invalid OTP";
              }
            },
            child: Text(
              "Verify",
              style: TextStyle(color: AppColor.backgroundColor),
            )),
        cancel: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, elevation: 5),
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel",
                style: TextStyle(color: AppColor.backgroundColor))),
        cancelTextColor: Colors.black,
        confirmTextColor: Color.fromARGB(255, 215, 207, 207),
        buttonColor: Colors.black,
        barrierDismissible: false,
        radius: 10,
        content: Column(
          children: [
            Obx(() => Text(message.value)),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 15, bottom: 0),
                child: TextField(
                  onChanged: (value) => {userOtp.value = value.toString()},
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Enter OTP ',
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
