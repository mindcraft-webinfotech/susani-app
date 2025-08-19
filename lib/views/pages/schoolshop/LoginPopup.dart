import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/login_controller/LoginPopupController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoginPopup(var school) {
  var controller = Get.put(LoginPopupController());

  String username = "";
  String password = "";
  Get.defaultDialog(
    title: 'Login',
    content: Obx(() {
      return Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Username'),
            onChanged: (val) => username = val,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (val) => password = val,
          ),
          SizedBox(height: 20),
          controller.isLoading.value == "loading"
              ? CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.bottomitemColor1,
                      elevation: 8,
                      shadowColor: AppColor.bottomitemColor1.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  onPressed: () {
                    controller.login(username, password, school);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      );
    }),
    radius: 10,
  );
}
