import 'dart:convert';

import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/product_controller/product_categories_controller.dart';
import 'package:Susani/models/category.dart';
import 'package:get/get.dart';
import 'package:Susani/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/models/slider.dart';
import 'package:Susani/services/remote_servies.dart';

class NewsController extends GetxController {
  var type="laundry".obs;

  var newsList = <News>[].obs;
  dynamic currentIndex = 0.obs;
  var sliders = <Slider>[].obs;
  var isLoading = true.obs;

  var refreshStatus = false.obs;
  @override
  void onClose() {
    newsList.clear();
    super.onClose();
  }

  @override
  void onInit() {
    loadNews();
    loadSlider();
    loadCategories();

    super.onInit();
  }

  sliderIndex(int index) {
    currentIndex.value = index;
  }

  void loadNews() {
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getNewsFeed();
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          newsList.value = re.map<News>((e) => News.fromJson(e)).toList();
        } else {}
      } else {
        //throw Exception('Failed to load album');
      }
    });
  }

  void loadSlider() {
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getSlider();
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          isLoading.value = false;

          refreshStatus.value == true ? refreshStatus.value = false : "";

          sliders.value = re.map<Slider>((e) => Slider.fromJson(e)).toList();
        } else {}
      } else {
        //throw Exception('Failed to load album');
      }
    });
  }

  /* --------- load categories card ------- */
  var isLoadin = true.obs;
  var selectItem = "All".obs;
  var categoriesName = "".obs;

  List<Category> categories = <Category>[].obs;

  void loadCategories() {
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getCategory(type.value);
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          isLoadin.value = false;
          categories = re.map<Category>((e) => Category.fromJson(e)).toList();

          // Category cat = new Category();
          // cat.id = 0.toString();
          // cat.categoryname = "All";
          // cat.image = null;
          // categories.insert(0, cat);
        } else {}
      } else {
        //throw Exception('Failed to load album');
      }
    });
  }

  refershList() {
    loadNews();
    Get.lazyPut(() => CheckoutController());
    loadSlider();
  }
}
