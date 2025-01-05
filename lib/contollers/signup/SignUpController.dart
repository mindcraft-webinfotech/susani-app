import 'dart:convert';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/models/User.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';

import '../../consts/app_constraints.dart';
import '../../utils/common_tools.dart';
import '../cart_controller/cart_controller.dart';

class SignUpController extends GetxController {
  var signupStatus = false.obs;
  var signupMessage = "".obs;
  var isChecked = false.obs;
  var dashboardController = Get.put(DashboardController());
  var signInController = Get.put(SignInController());
  @override
  void onInit() {
    signupMessage.value = "";
    super.onInit();
  }

  void saveData(User user) {
    signupMessage.value = "running";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.signup(user);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        if (res == "success") {
          signupStatus.value = true;
          signupMessage.value = data['msg'];

          user = User.fromJson(data["data"]);
          user.image.value = user.image.value != ""
              ? user.image.value.contains(AppConstraints.PROFILE_URL)
                  ? user.image.value
                  : AppConstraints.PROFILE_URL + "" + user.image.value
              : AppConstraints.DEFAULIMAGE;

          signInController.user.value = user;
          CommonTool().save(user);
          signInController.id.value = user.id!;
          CartController cc = Get.put(CartController());
          cc.getCartItems(signInController.id.value);
          if (cc.comeBack.value) {
            cc.comeBack.value = false;
            Get.back();
          } else {
            dashboardController.goToDashboard(0);
          }
          // Get.offAllNamed(MyPagesName.SignIn);
        } else {
          signupStatus.value = false;
          signupMessage.value = data['msg'];
        }
      } else {
        signupStatus.value = false;
        signupMessage.value = "server error";
      }
    });
  }

  Future<bool> verifyMobileOrEmail(String mobile, String email) async {
    signupMessage.value = "running";
    http.Response response = await MyApi.mobileOrEmailExist(mobile, email);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      if (res == "success") {
        signupMessage.value = "This mobile or email is already exist";
        return true;
      } else {
        return false;
      }
    } else {
      signupMessage.value = "Server error";
    }
    return false;
  }
}
