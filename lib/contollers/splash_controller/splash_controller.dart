import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/User.dart';
import 'package:get/get.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';

import '../../utils/common_tools.dart';
import '../cart_controller/cart_controller.dart';

class SplashController extends GetxController {
  var seconds = 3.obs;
  var user = User().obs;
  // DashboardController dashboardController = Get.put(DashboardController());
  // SignInController signInController = Get.put(SignInController());

  @override
  void onInit() {
    CommonTool().getUserId().then((value) => {
          if (value != "") {user.value.id = value.id}
        });
    print("erere");
    _startTimer();
  }

  _startTimer() {
    Future.delayed(Duration(seconds: seconds.value), () {
      Get.offNamed(MyPagesName.dashBoard);
      // if (signInController.id.value == "" ||
      //     signInController.id.value == "null") {
      // } else {
      //   Get.offNamed(MyPagesName.dashBoard);

      // }
    });
  }
}
