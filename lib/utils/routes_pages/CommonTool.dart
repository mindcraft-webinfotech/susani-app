import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Susani/models/User.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../consts/app_color.dart';

class CommonTool {
  static Color fromHex(String hexString) {
    if (hexString.contains("#")) {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } else {
      return Colors.transparent;
    }
  }

  static void launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Future<User> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = new User();
    user.id = prefs.getString('id').toString();
    user.name = prefs.getString('name').toString();
    user.last_name = prefs.getString('last_name').toString();
    user.email = prefs.getString('email').toString();
    user.contact = prefs.getString('contact').toString();
    user.gender = prefs.getString('gender').toString();
    user.image.value = prefs.getString('image').toString();
    user.selected_address_id = prefs.containsKey("selected_address_id")
        ? int.parse(prefs.getString('selected_address_id').toString() == ""
            ? "0"
            : prefs.getString('selected_address_id').toString())
        : 0;

    // print("Shared pref=" +
    //     prefs.getString('contact').toString() +
    //     " --" +
    //     user.contact!);
    return user;
  }

  save(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("id", user.id.toString());
    prefs.setString("name", user.name.toString());
    prefs.setString("last_name", user.last_name.toString());
    prefs.setString("email", user.email.toString());
    prefs.setString("contact", user.contact.toString());
    prefs.setString("gender", user.gender.toString());
    prefs.setString("image", user.image.toString());
    prefs.setString("selected_address_id", user.selected_address_id.toString());
  }

  Future<String> removeFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("last_name");
    prefs.remove("gender");
    prefs.remove("email");
    prefs.remove("image");
    prefs.remove("selected_address_id");
    return "cleared";
  }

  void showInSnackBar(String value, BuildContext context,
      {Color bgcolor = Colors.black45}) {
    bgcolor = AppColor.bottomitemColor1;
    Get.snackbar("Message", value,
        colorText: Colors.white,
        backgroundColor: bgcolor,
        snackPosition: SnackPosition.BOTTOM);
  }
}
