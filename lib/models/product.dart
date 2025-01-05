import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:Susani/consts/app_constraints.dart';

class Product {
  String? id;
  String? categoryId;
  String? name;
  String? mrp;
  String? gst;
  String? tax;
  double? discount;
  double? discounted_amount;
  String? discount_type;
  String? price;
  String? size;
  String? unit;
  String? color;
  String? quality;
  String? quantity;
  String? delStatus;
  String? date;
  String? images;
  String? tags;
  String? other_info;
  String? description;
  var isFavoirite = false.obs;
  var isInCart = false.obs;
  List<dynamic>? img;
  var quant = 1.obs;

  Product(
      {this.id,
      this.categoryId,
      this.name,
      this.mrp,
      this.discount,
      this.discounted_amount,
      this.discount_type,
      this.price,
      this.size,
      this.unit,
      this.color,
      this.quality,
      this.quantity,
      this.delStatus,
      this.date,
      this.images,
      this.tags,
      this.description,
      this.other_info,
      this.img,this.tax
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = !json.containsKey("id")
        ? "0"
        : json['id'] == "null"
            ? ""
            : json["id"];
    categoryId = !json.containsKey("category_id") ? "0" : json['category_id'];
    name = AppConstraints.capitalize(!json.containsKey("name")
        ? ""
        : json['name'] == "null"
            ? ""
            : json['name']);

    mrp = !json.containsKey("mrp")
        ? "0"
        : json['mrp'] == "null"
            ? ""
            : json['mrp'];

    gst = !json.containsKey("gst")
        ? "0"
        : json['gst'] == "null"
            ? ""
            : json['gst'];
    discount = double.parse(!json.containsKey("discount")
        ? "0"
        : json['discount'].toString() == "null" ||
                json['discount'].toString() == ""
            ? "0"
            : json['discount'].toString());

    discounted_amount = double.parse(!json.containsKey("discounted_amount")
        ? "0"
        : json['discounted_amount'] == "null"
            ? "0"
            : json['discounted_amount'].toString());

    discount_type = !json.containsKey("discount_type")
        ? ""
        : json['price'] == "null"
            ? ""
            : json['discount_type'];

    price = !json.containsKey("price")
        ? "0"
        : json['price'] == "null"
            ? ""
            : json['price'];

    size = !json.containsKey("size")
        ? "0"
        : json['size'] == "null"
            ? ""
            : json['size'];
    unit = !json.containsKey("unit")
        ? "0"
        : json['unit'] == "null"
            ? ""
            : json['unit'];
    color = !json.containsKey("color")
        ? "0"
        : json['color'] == "null"
            ? ""
            : json['color'];
    quality = !json.containsKey("quality")
        ? "0"
        : json['quality'] == "null"
            ? ""
            : json['quality'];
    quantity = !json.containsKey("quantity")
        ? "0"
        : json['quantity'] == "null"
            ? ""
            : json['quantity'];
    delStatus = !json.containsKey("del_status")
        ? "0"
        : json['del_status'] == "null"
            ? ""
            : json['del_status'];
    date = !json.containsKey("date")
        ? "0"
        : json['date'] == "null"
            ? ""
            : json['date'];
    images = !json.containsKey("images")
        ? "0"
        : json['images'] == "null"
            ? ""
            : json['images'];
    tags = !json.containsKey("tags")
        ? "0"
        : json['tags'] == "null"
            ? ""
            : json['tags'];
    description = !json.containsKey("description")
        ? "0"
        : json['description'] == "null"
            ? ""
            : json['description'];
    other_info = !json.containsKey("other_info")
        ? "0"
        : json['other_info'] == "null"
            ? ""
            : json['other_info'];
    tax = !json.containsKey("tax")
        ? "0"
        : json['tax'] == "null"
            ? ""
            : json['tax'];
    img = !json.containsKey("img")
        ? List.empty()
        : json['img'] == "null"
            ? List.empty()
            : json['img'] as List<dynamic>;
  }

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "categoryId": categoryId.toString(),
        "name": name.toString(),
        "mrp": mrp.toString(),
        "gst": gst.toString(),
        "discount": discount.toString(),
        "price": price.toString(),
        "size": size.toString().toString(),
        "unit": unit.toString(),
        "quant": quant.toString(),
        "img": img!,
        "tax": tax!,
      };
}
