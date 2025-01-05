import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/services/remote_servies.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';

class EditProfileController extends GetxController {
  var signInController = Get.put(SignInController());
  var message = "".obs;
  var status = false.obs;

  void editProfile(User user, {String oldPic = "", newpic = ""}) {
    message.value = "running";
    Future.delayed(Duration(seconds: 1), () async {
      StreamedResponse sresponse =
          await MyApi.editProfile(user, oldpic: oldPic, newpic: newpic);
      if (sresponse.statusCode == 200) {
        print(newpic);
        print(sresponse);
        var response = await http.Response.fromStream(sresponse);
        var data = jsonDecode(response.body);
        print(response.body);
        String res = data['res'];
        String msg = data['msg'];
        print(data);
        if (res == "success") {
          var jsondata = data['data'] as List;
          status.value = true;
          message.value = data['msg'];
          user = User.fromJson(jsondata[0]);
          user.image.value = user.image.value != ""
              ? user.image.value.contains(AppConstraints.PROFILE_URL)
                  ? user.image.value
                  : AppConstraints.PROFILE_URL + "" + user.image.value
              : AppConstraints.DEFAULIMAGE;
          CommonTool().save(user);
          signInController.user.value = user;
          Get.back();
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
}
