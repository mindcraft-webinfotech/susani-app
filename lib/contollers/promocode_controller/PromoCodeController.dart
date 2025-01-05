import 'dart:convert';

import 'package:get/get.dart';
import 'package:Susani/models/AppConfig.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:http/http.dart' as http;

class PromoCodeController extends GetxController {
  AppConfig appConfig = AppConfig();
  @override
  void onInit() {
    loadConfig();
    super.onInit();
  }

  void loadConfig() {
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getAppConfig();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          appConfig = AppConfig.fromJson((data['data'] as List)[0]);
        } else {}
      } else {
        //throw Exception('Failed to load album');
      }
    });
  }
}
