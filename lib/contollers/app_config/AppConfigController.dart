import 'dart:convert';

import 'package:get/get.dart';
import 'package:Susani/models/AppConfig.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:http/http.dart' as http;

class MyAppConfigController extends GetxController {
  var appConfig = AppConfig().obs;
  var status = "".obs;
  @override
  void onInit() {
    loadConfig();
    super.onInit();
  }

  void loadConfig() {
    Future.delayed(Duration(seconds: 1), () async {
      status.value = "loading";
      http.Response response = await MyApi.getAppConfig();
      print("===========>>>>>>>>>");
      print(response.body);
      if (response.statusCode == 200) {
        status.value = "done";
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          appConfig.value = AppConfig.fromJson((data['data'] as List)[0]);
        } else {
          status.value = "failled";
        }
      } else {
        status.value = "failled";
        //throw Exception('Failed to load album');
      }
    });
  }
}
