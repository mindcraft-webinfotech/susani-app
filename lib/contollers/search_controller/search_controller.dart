import 'dart:convert';
import 'package:Susani/contollers/search_controller/search_controller.dart';
import 'package:Susani/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/models/category.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/views/widgets/search_item.dart';

class SearchControllerone extends GetxController {
  var categories = <Category>[].obs;
  var Products = <Product>[].obs;
  var choices = <Widget>[].obs;
  var isLoading = false.obs;
  var searchKey = "".obs;
  @override
  void onInit() {
    Products.clear();
    super.onInit();
  }

  void searchCategory(String categoryname) {
    choices.clear();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.searchCategory(categoryname);
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          isLoading.value = false;
          categories.value =
              re.map<Category>((e) => Category.fromJson(e)).toList();
          SearchItemDesign();
        } else {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    });
  }

  void searchProduct(String keyword) {
    choices.clear();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.searchProduct(keyword);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          isLoading.value = false;
          Products.value = re.map<Product>((e) => Product.fromJson(e)).toList();

          SearchItemDesign();
        } else {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    });
  }
}
