import 'package:Susani/contollers/otp_controller/OtpController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/signup/SignUpController.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUp();
  }
}

class _SignUp extends State<SignUp> {
  var controller = Get.put(SignUpController());
  var otpController = Get.put(OtpController());

  String name = "", email = "", password = "no_password", mobile = "";
  @override
  void initState() {
    super.initState();
  }

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
          ),
        ),
        centerTitle: true,
        title: const Text("Sign Up ", style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Container(
                    width: Get.size.width - 100,
                    child: Image.asset(
                      'assets/images/laundry_delivery.png',
                      height: 220,
                    )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                GestureDetector(
                  onTap: () {
                    Get.offNamed(MyPagesName.SignIn);
                  },
                  child: Text(' Sign In', style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (value) => {name = value.toString()},
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    labelText: 'Name',
                    hintText: 'Enter valid name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (value) => {mobile = value.toString()},
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    labelText: 'Mobile',
                    hintText: 'Enter valid mobile'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (value) => {email = value.toString()},
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) => {password = value.toString()},
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: controller.isChecked.value,
                      onChanged: (bool? value) {
                        setState(() {
                          controller.isChecked.value = value!;
                          // print(controller.isChecked.value);
                        });
                      },
                    ),
                    Flexible(child: Text("Please accept ")),
                    GestureDetector(
                      onTap: () async {
                        // print("tapped");
                        // print(AppConstraints.BASE_URL + "/downloadpdf.php");
                        _launchURL(AppConstraints.BASE_URL + "downloadpdf.php");
                      },
                      child: Text("Terms And Condition. ",
                          style: TextStyle(
                            color: Colors.blue,
                          )),
                    )
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.transparent))),
                  backgroundColor:
                      MaterialStateProperty.all(AppColor.bottomitemColor1),
                ),
                onPressed: () {
                  if (name == "" ||
                      email == "" ||
                      mobile == "" ||
                      password == "" ||
                      !controller.isChecked.value) {
                    CommonTool().showInSnackBar(
                      "Please fill all the fields",
                      context,
                    );
                  } else {
                    // CommonTool().showInSnackBar("Saving data", context);
                    User user = new User();
                    user.name = name;
                    user.email = email;
                    user.password = password;
                    user.contact = mobile;
                    user.terms_condition =
                        "" + controller.isChecked.value.toString();
                    controller
                        .verifyMobileOrEmail(mobile, email)
                        .then((value) => {
                              if (value)
                                {
                                  CommonTool().showInSnackBar(
                                      "This mobile or email is already exist!",
                                      context,
                                      bgcolor: Colors.black)
                                }
                              else
                                {
                                  otpController.sendOtp(
                                      mobile, "registration", user)
                                }
                            });
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Obx(() => controller.signupMessage.value == "running"
                    ? new CircularProgressIndicator()
                    : Text(
                        controller.signupMessage.value,
                        style: TextStyle(color: Colors.red),
                      )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(var _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.black;
    }
    return Colors.black;
  }
}
