import 'dart:convert';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/contollers/signup/SignUpController.dart';
import 'package:Susani/views/pages/ecom/screens/EcomCart.dart';
import 'package:Susani/views/pages/schoolshop/schoolshop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/models/User.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';

class LoginPopupController extends GetxController {
  var isLoading = "".obs;
  var signInController = Get.put(SignInController());
  void login(String username, String password, var school) {
    print("function called");
    isLoading.value = "loading";
    print(signInController.id.value);
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.popupLogin(
          username, password, signInController.id.value, school.id);
      if (response.statusCode == 200) {
        isLoading.value = "done";
        print(response.body);
        var data = jsonDecode(response.body);
        String res = data['res'];
        if (res == "success") {
          Get.back();
          Get.to(() => Schoolshop(school: school));
        } else {
          showHighZindexSnackBar('Error', 'Invalid credentials');
          isLoading.value = "Invalid credentials";
        }
      } else {
        isLoading.value = "server error";
      }
    });
  }

  showHighZindexSnackBar(title, message) {
    Get.rawSnackbar(
      title: title,
      message: message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black.withOpacity(0.8),
      margin: EdgeInsets.all(16),
      borderRadius: 10,
      duration: Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
