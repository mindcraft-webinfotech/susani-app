import 'dart:convert';

import 'package:get/get.dart';
import 'package:Susani/models/slider.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/services/remote_servies.dart';

class SliderController extends GetxController {
  var sliders = <Slider>[].obs;
  @override
  void onInit() {
    loadSlider();
    super.onInit();
  }

  void loadSlider() {
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getNewsFeed();
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;

          sliders.value = re.map<Slider>((e) => Slider.fromJson(e)).toList();
        } else {}
      } else {
        //throw Exception('Failed to load album');
      }
    });
  }
}
