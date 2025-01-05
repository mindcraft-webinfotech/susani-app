import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/models/product.dart';
import 'package:Susani/services/remote_servies.dart';

class WishlistController extends GetxController {
  SignInController signInController = Get.put(SignInController());
  var productList = <Product>[].obs;
  var isLoading = true.obs;
  var isError = false.obs;
  var status = "".obs;
  @override
  void onInit() {
    allWishlist(signInController.user.value);
    super.onInit();
  }

  void addWishlist(User user, Product product) {
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.addWishlist(user, product);
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          productList.add(product);
        } else {}
      } else {}
    });
  }

  void removeWishlist(User user, Product product) {
    // print("user:" + user.id.toString() + " product:" + product.id!);
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.removeWishlist(user, product);
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          removeDataFromList(product);
        } else {}
      } else {}
    });
  }

  void allWishlist(User user) {
    status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.allWishlist(user);

      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          status.value = "Done";
          isError.value = false;
          var re = data['data'] as List;
          isLoading.value = false;
          productList.value =
              re.map<Product>((e) => Product.fromJson(e)).toList();
        } else {
          status.value = msg;
          isError.value = true;
          throw Exception('Failed to load data ' + msg);
        }
      } else {
        status.value = "Record not found";
      }
    });
  }

  void removeDataFromList(Product pr) {
    int i = 0;
    for (var product in this.productList) {
      // print("comparison" + product.id.toString() + "==" + pr.id.toString());
      if (product.id == pr.id) {
        productList.removeAt(i);

        break;
      }
      i++;
    }
  }
}
