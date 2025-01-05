import 'dart:convert';

import 'package:Susani/models/OrderStatusResponse.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:get/get.dart';
import 'package:Susani/models/Order.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:http/http.dart' as http;

import '../signin/SignInController.dart';

class OrderHistoryController extends GetxController {
  var status = "".obs;
  var order_status = "".obs;
  var orders = <Order>[].obs;
  var orderStatusResponse = <OrderStatusResponse>[].obs;
  var signInController = Get.put(SignInController());
  @override
  void onInit() {
    super.onInit();
  }

  RxList<Order> orderHistory(User user) {
    status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      print("Fetch Orders api-----------");
      http.Response response = await MyApi.orderHistory(user);
      print("Fetch Orders api-----------");

      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          status.value = "Done";
          orders.value = re.map<Order>((e) => Order.fromJson(e)).toList();
        } else {
          status.value = msg;
          print('Failed to load data ' + msg);
        }
      } else {
        status.value = "Failed to load data";
        throw Exception('Failed to load data');
      }
    });
    return orders;
  }

  RxList<Order> orderStatus(String orderid) {
    order_status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.orderStatus(orderid);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          order_status.value = "Done";
          orderStatusResponse.value = re
              .map<OrderStatusResponse>((e) => OrderStatusResponse.fromJson(e))
              .toList();
        } else {
          order_status.value = msg;
          print('Failed to load data ' + msg);
        }
      } else {
        order_status.value = "Failed to load data";
        throw Exception('Failed to load data');
      }
    });
    return orders;
  }

  void cancelOrder(String userid, String orderid) {
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.cancelOrder(userid, orderid);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          User user = await CommonTool().getUserId();
          orderHistory(user);
        } else {}
      } else {}
    });
  }

  void fetchOrders() async {
    User user = await CommonTool().getUserId();
    orderHistory(user);
  }
}
