import 'dart:convert';

import 'package:Susani/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CartItem {
  int? id;
  Product? product;
  var quantity = 0.obs;
  String? color;
  String? size;
  double? total;
  double? tax;

  CartItem({
    this.id,
    this.product,
    this.color,
    this.size,
    this.total,
    this.tax,
  });
  CartItem.fromJson(Map<String, dynamic> json) {
    quantity.value = json['quantity'] == "null"
        ? 0
        : int.parse(json['quantity'].toString().trim());
    color = json['color'] == "null" ? "" : json['color'];
    size = json['size'] == "null" ? "" : json['size'];
    tax = json['tax'] == "null" ? "" : json['tax'];
    product = json['product'] == "null"
        ? new Product()
        : Product.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() => {
        "quantity": quantity.value,
        "color": color,
        "size": size,
        "product": product,
        "tax": tax,
      };
}
