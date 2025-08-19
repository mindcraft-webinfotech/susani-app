import 'package:Susani/contollers/app_config/AppConfigController.dart';
import 'package:Susani/contollers/otp_controller/OtpController.dart';
import 'package:Susani/views/pages/ecom/utils/color_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:upgrader/upgrader.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  var controller = Get.put(SignInController());
  var otpController = Get.put(OtpController());
  DashboardController dashboardController = Get.put(DashboardController());
  MyAppConfigController appConfigController = Get.put(MyAppConfigController());

  String email = "8976110254", password = "";
  _SignIn() {
    controller.forgot_message.value = "";
    controller.forgot_status.value = false;
  }
  String localemail = "";
  String localmobile = "";

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
            size: 25,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        title: const Text("Sign In ", style: TextStyle(fontSize: 16)),
      ),
      body: UpgradeAlert(
        upgrader: Upgrader(),
        showIgnore: false,
        showLater: false,
        barrierDismissible: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: Get.size.width - 100,
                      child: Image.asset(
                        'assets/images/laundry_delivery.png',
                        height: 200,
                      )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Obx(
                () => appConfigController.status.value != "done"
                    ? CircularProgressIndicator(
                        color: AppColor.bottomitemColor1,
                      )
                    : Padding(
                        // padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) => {email = value},
                          controller: TextEditingController(
                            text:
                                appConfigController.appConfig.value.autoLogin ==
                                        1
                                    ? '8976110254'
                                    : '', // Fallback default
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            labelText: 'Mobile',
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                  ),
                  onPressed: () {
                    print("You clicked me");
                    if (email == "") {
                      CommonTool().showInSnackBar(
                        "Please fill all the fields",
                        context,
                      );
                    } else {
                      CommonTool().showInSnackBar("OTP sent..", context);

                      User user = User();
                      user.email = email;
                      // user.password = password;
                      controller.message.value = "";
                      otpController.sendOtp(email, "login", user);
                      // controller.signIn(user);
                    }
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Obx(() => controller.message.value == "running"
                      ? new CircularProgressIndicator()
                      : Text(controller.message.value,
                          style: TextStyle(color: Colors.red))),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () => {
                  Get.defaultDialog(
                      title: "Enter mobile to reset passowrd",
                      titleStyle: TextStyle(fontSize: 16),
                      barrierDismissible: false,
                      middleTextStyle: TextStyle(fontSize: 12),
                      content: Column(
                        children: [
                          TextField(
                            onChanged: (value) => {localmobile = value},
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                labelText: 'Mobile',
                                hintText: ''),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(() => Center(
                                child: Text(
                                  controller.forgot_message.value,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ))
                        ],
                      ),
                      cancel: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                            if (controller.forgot_message != "Loading..") {
                              Get.back();
                            }
                          },
                          child: Text("Cancel",
                              style: TextStyle(
                                color: Colors.black,
                              ))),
                      confirm: Obx(
                        () => !controller.forgot_status.value
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    elevation: 5),
                                onPressed: () {
                                  if (controller.forgot_message !=
                                      "Loading..") {
                                    if (localmobile == "" ||
                                        localmobile == "null") {
                                      Get.snackbar(
                                        "Alert",
                                        "Please enter valid mobile!",
                                        backgroundColor: Colors.black,
                                        snackPosition: SnackPosition.BOTTOM,
                                        colorText: Colors.white,
                                      );
                                    } else {
                                      User user = new User();
                                      user.contact = localmobile;
                                      otpController.sendOtp(
                                          localmobile, "forgot-pass", user);
                                    }
                                  }
                                },
                                child: Text("Reset password",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )))
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    elevation: 5),
                                onPressed: () {
                                  controller.forgot_message.value = "";
                                  controller.forgot_status.value = false;
                                  Get.back();
                                },
                                child: Text("Ok",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))),
                      ),
                      contentPadding: EdgeInsets.all(20))
                },
                child: Visibility(
                  visible: false,
                  child: Text(
                    'Forgot Password',
                    style:
                        TextStyle(color: Colors.black, fontSize: 15, height: 5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    /* SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]); */
    super.dispose();
  }
}
