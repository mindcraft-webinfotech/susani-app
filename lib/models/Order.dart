import 'dart:convert';

import 'package:Susani/models/Address.dart';
import 'package:Susani/models/CartItem.dart';
import 'package:Susani/models/Coupon.dart';
import 'package:Susani/models/product.dart';

class Order {
  int? id;
  int? user_id;
  String? order_id;
  Address? shipping_address;
  List? cartItems = <CartItem>[];
  int? quantity;
  double? total;
  String? payment_methods;
  Coupon? coupon;
  double? shipping_charge;
  String? order_status;
  String? transaction_id;
  String? date_time;
  String? cancellationRequest;
  String? picked_up;
  Order(
      {this.user_id,
      this.order_id,
      this.shipping_address,
      this.cartItems,
      this.quantity,
      this.total,
      this.payment_methods,
      this.coupon,
      this.shipping_charge,
      this.order_status,
      this.transaction_id,
      this.cancellationRequest,
      this.date_time,
      this.picked_up});
  Order.fromJson(Map<String, dynamic> json) {
    final shippingAddressJson = json['shipping_address'];
    jsonDecode(shippingAddressJson);
    print("${shippingAddressJson}==========");
    final address = shippingAddressJson != null && shippingAddressJson != "null"
        ? Address.fromJson(shippingAddressJson is String
            ? jsonDecode(shippingAddressJson)
            : shippingAddressJson)
        : null;
    var coupon = Coupon.fromJson(jsonDecode(json["coupon"]));
    var ls = jsonDecode(json['products']) as List;

    cartItems = ls.map<CartItem>((e) => CartItem.fromJson(e)).toList();
    id = int.parse(json['id']);
    user_id = int.parse(json['user_id']);
    order_id = json['order_id'];
    shipping_address = address;
    cartItems = cartItems;
    quantity = int.parse(json['quantity']);
    total = double.parse(json['total']);
    payment_methods = json['payment_methods'];
    cancellationRequest = json['cancellation_request'];
    coupon = coupon;
    shipping_charge = double.parse(json['shipping_charge']);
    order_status = json['order_status'];
    transaction_id = json['transaction_id'];
    date_time = json['dat_time'];
    picked_up = json['pickup_otp'];
  }
}
