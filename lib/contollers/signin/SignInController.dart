import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';

import '../../utils/routes_pages/pages_name.dart';

class SignInController extends GetxController {
  var status = false.obs;
  var message = "".obs;
  var forgot_status = false.obs;
  var forgot_message = "".obs;

  var user = User().obs;
  var isSignin = false.obs;
  var id = "".obs;
  DashboardController dashboardController = Get.put(DashboardController());

  @override
  void onInit() {
    CommonTool().getUserId().then((value) => {
          id.value = value.id.toString(),
          user.value = value,
          if (id.value == "" || id.value == "null")
            {Get.offNamed(MyPagesName.SignIn)}
          else
            {Get.offNamed(MyPagesName.dashBoard)}
        });
    returnItems();
    super.onInit();
  }

  void signIn(User user, {String signIntType = "password"}) {
    message.value = "running";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.signIn(user, signIntType);
      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        var jsondata = data['data'];
        if (res == "success") {
          status.value = true;

          message.value = "";
          // print(user);
          user = User.fromJson(jsondata);
          user.image.value = user.image.value != ""
              ? user.image.value.contains(AppConstraints.PROFILE_URL)
                  ? user.image.value
                  : AppConstraints.PROFILE_URL + "" + user.image.value
              : AppConstraints.DEFAULIMAGE;

          this.user.value = user;
          CommonTool().save(user);
          id.value = user.id!;
          // print("In sign in controller " + id.value);
          CartController cc = Get.put(CartController());
          cc.getCartItems(id.value);
          if (cc.comeBack.value) {
            cc.comeBack.value = false;
            Get.back();
          } else {
            dashboardController.goToDashboard(0);
          }
        } else {
          status.value = false;
          message.value = data['msg'];
        }
      } else {
        status.value = false;
        message.value = "server error";
      }
    });
  }

  void forgot(String email) {
    forgot_message.value = "Loading..";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.forgotPassword(email);
      if (response.statusCode == 200) {
        // print(response.body);
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        var jsondata = data['data'];
        if (res == "success") {
          forgot_message.value = msg;
          forgot_status.value = true;
        } else {
          forgot_message.value = data['msg'];
        }
      } else {
        forgot_message.value = "server error";
      }
    });
  }

  void forgotByMobile(String mobile) {
    forgot_message.value = "Loading..";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.update_password_by_mobile(mobile);
      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        var jsondata = data['data'];
        if (res == "success") {
          forgot_message.value = msg;
          forgot_status.value = true;
        } else {
          forgot_message.value = data['msg'];
        }
      } else {
        forgot_message.value = "server error";
      }
    });
  }

  List<PopupMenuEntry> returnItems() {
    List<PopupMenuEntry> list = <PopupMenuEntry>[];

    list.clear();
    // print("=============");
    // print(id);
    if (id.value != "" && id.value != "null") {
      list.add(PopupMenuItem(
        child: Text("My Orders"),
        value: 0,
      ));
      list.add(PopupMenuItem(
        child: Text("My Favorites"),
        value: 1,
      ));
      list.add(PopupMenuItem(
        child: Text("Shipping Address"),
        value: 2,
      ));
      list.add(PopupMenuItem(
        child: Text("Gift Cards & Promo codes"),
        value: 3,
      ));
      list.add(PopupMenuItem(
        child: Text("Logout"),
        value: 4,
      ));
    } else {
      list.add(PopupMenuItem(
        child: Text("Login"),
        value: 4,
      ));
    }

    return list;
  }
}
