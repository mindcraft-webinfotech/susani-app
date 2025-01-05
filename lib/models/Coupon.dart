import 'package:get/get.dart';

class Coupon {
  int? id;
  String? coupon_type;
  String? coupon_code;
  String? description;
  String? added_on;
  double? amount;
  double? min_purchase_amt;
  var copied = false.obs;

  Coupon({
    this.coupon_type,
    this.coupon_code,
    this.description,
    this.added_on,
    this.amount,
    this.min_purchase_amt,
  });
  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'] == "null" ? 0 : int.parse(json['id']);
    coupon_type = json['type'] == "null" ? "" : json['type'];
    coupon_code = json['coupon_code'] == "null" ? "" : json['coupon_code'];
    description = json['description'] == "null" ? "" : json['description'];
    amount = json['amount'] == "null" ? 0 : double.parse(json['amount']);
    min_purchase_amt = json.containsKey("min_purchase_amt")
        ? json['min_purchase_amt'] == "null"
            ? 0
            : double.parse(json['min_purchase_amt'])
        : json['purchage_amt'] == "null"
            ? 0
            : double.parse(json['purchage_amt']);
    added_on = json['added_on'] == "null" ? "" : json['added_on'];
  }
  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "coupon_type": coupon_type.toString(),
        "coupon_code": coupon_code.toString(),
        "description": description.toString(),
        "amount": amount.toString(),
        "min_purchase_amt": min_purchase_amt.toString(),
        "added_on": added_on.toString().toString(),
      };
}
