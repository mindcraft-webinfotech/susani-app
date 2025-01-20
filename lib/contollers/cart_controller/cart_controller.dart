import 'dart:convert';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/app_config/AppConfigController.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/CartItem.dart';
import 'package:Susani/models/Coupon.dart';
import 'package:Susani/models/product.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../dashboard_controller/dashboard_controller.dart';

class CartController extends GetxController {

  var selectedtype='Na'.obs;
  var cartItems = <CartItem>[].obs;
  var subTotal = 0.0.obs;
  var subTotalDiscount = 0.0.obs;
  var totalQuantity = 0.obs;
  var subTotalWithShipping = 0.0.obs;
  var total = 0.0.obs;
  var totalTax = 0.0.obs;
  var tax = 0.0.obs;
  var promoCodeValue = 0.0.obs;
  var coupon = new Coupon().obs;
  var status = "".obs;
  var addQuantStatus = "".obs;
  var comeBack = false.obs;
  var cartIndex = 0.obs;
  var clickedIndex = 0.obs;
  MyAppConfigController appConfigController = Get.put(MyAppConfigController());
  CheckoutController checkoutController = Get.put(CheckoutController());
  SignInController signController = Get.put(SignInController());
  ProductController productController = Get.put(ProductController());

  @override
  void onInit() {
    CommonTool().getUserId().then((value) => {
          if (value != "") {getCartItems(signController.id.value)}
        });
    super.onInit();
  }

  void saveToCart(CartItem cartItem, String user_id, [BuildContext? context]) {
    status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.saveToCart(cartItem, user_id);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'];
          status.value = "Done";

          if (context != null) {
            CommonTool().showInSnackBar(
              cartItem.product!.name! + " added to the cart",
              context,
              bgcolor: Colors.green,
            );
          }
        } else {
          var dashboardController = Get.put(DashboardController());

          Get.defaultDialog(
                title: "CONFIRMATION",
                titleStyle: TextStyle(
                    fontSize: 16),
                middleText: msg,
                middleTextStyle:
                TextStyle(
                    fontSize: 12),
                cancel: ElevatedButton(
                    style: ElevatedButton
                        .styleFrom(
                        backgroundColor: Colors
                            .white),
                    onPressed: () {
                      // dashboardController.goToTab(3);
                      Get.back();
                    },
                    child: Text(
                        "Cancel",
                        style:
                        TextStyle(
                          color: Colors
                              .black,
                        ))),
                confirm: ElevatedButton(
                    style: ElevatedButton
                        .styleFrom(
                        backgroundColor: Color
                            .fromARGB(
                            255,
                            3,
                            33,
                            49),
                        elevation:
                        5),
                    onPressed: () {
                      daleteAllItem();
                      cartItem.clear_cart = true;
                      saveToCart(cartItem, user_id,context);
                      Get.back();
                      // dashboardController.goToTab(3);
                    },
                    child: Text(
                        "Clear",
                        style:
                        TextStyle(
                          color: Colors
                              .white,
                        ))),
                contentPadding:
                EdgeInsets.all(20));


          status.value = "Failed: " + msg;
        }
      } else {
        status.value = "Failed with exception";
      }
    });
  }

  void getCartItems(String user_id) {
    status.value = "Loading";
    cartItems.clear();
    // print("user id $user_id");
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getCartItems(user_id);
      print(" getCartItems " + user_id.toString());
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          status.value = "Done";
          cartItems.clear();
          var re = data['data'] as List;

          for (var item in re) {
            CartItem cartItem = new CartItem();
            var id = item["id"];
            Product product = Product.fromJson(item["product_id"]);
            var color = item["color"];
            var size = item["size"];
            var quantity = item["quantity"];
            var total = item["total"];
             var tax =  double.parse(item["tax"].toString());
             var type =  item["type"].toString();

            print(tax);

            cartItem.id = int.parse(id);
            cartItem.quantity.value = int.parse(quantity);
            cartItem.color = color;
            cartItem.size = size;
            cartItem.total = double.parse(total);
            cartItem.product = product;
            cartItem.tax = tax;
            cartItem.type = type.toString();
            status.value = "Done";
            addToCart(cartItem);
          }
        } else {
          status.value = "Failed: " + msg;
        }
      } else {
        status.value = "Failed with exception";
      }
    });
  }

  void daleteItem(CartItem cartItem) {
    status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.deleteCartItem(cartItem.id!);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'];
          status.value = "Done";
          removeFromCart(cartItem);
        } else {
          status.value = "Failed: " + msg;
        }
      } else {
        status.value = "Failed with exception";
      }
    });
  }

  Future<String> daleteAllItem() async {
    status.value = "Loading";
    http.Response response =
        await MyApi.deleteAllCartItem(signController.id.value);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String res = data['res'];
      String msg = data['msg'];
      if (res == "success") {
        var re = data['data'];
        status.value = "Done";
        return status.value;
      } else {
        return status.value = "Failed: " + msg;
      }
    } else {
      return status.value = "Failed with exception";
    }
  }

  void addToCart(CartItem cartItem) {
    promoCodeValue.value = 0.0;
    cartItems.add(cartItem);
    if (cartItems.length < 1) {
      subTotal.value = 0.0;
    }
    createSubtotal();
    createTotal();
  }

  void removeFromCart(CartItem cartItem) {
    promoCodeValue.value = 0.0;

    cartItems.remove(cartItem);
    // if (cartItems.length > 0) {
    //   subTotal.value = subTotal.value -
    //       double.parse(cartItem.product!.price.toString()) *
    //           cartItem.product!.quant.value;
    // } else {
    //   subTotal.value = 0.0;
    // }
    createSubtotal();
    createTotal();
  }

  void addQuantityToCartTable(CartItem cartItem, int quantity, String type) {
    addQuantStatus.value = "Loading";
    Future.delayed(Duration(microseconds: 500), () async {
      http.Response response = await MyApi.addQuantity(
          signController.id.toString(), cartItem.product!.id, quantity, type);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'];
          addQuantStatus.value = "Done";
          if (type == "minus") {
            minusQuantity(cartItem);
          } else {
            addQuantity(cartItem);
          }
          createSubtotal();
        } else {
          addQuantStatus.value = "Failed: " + msg;
        }
      } else {
        addQuantStatus.value = "Failed with exception";
      }
    });
  }

  void addQuantity(CartItem cartItem) {
    promoCodeValue.value = 0.0;
    createSubtotal();
    createTotal();
  }

  void minusQuantity(CartItem cartItem) {
    promoCodeValue.value = 0.0;
    createSubtotal();
    createTotal();
  }

  void createSubtotal() {
    double st = 0;
    double dst = 0;
    double sdtax = 0;
    totalQuantity.value = 0;
    for (var cartItem in cartItems) {
      totalQuantity.value += cartItem.quantity.value;
      if (checkoutController.serviceType.value == "Urgent Service" ||
          checkoutController.serviceType.value == "Semi Urgent Service") {

        var itmeTotalTax = cartItem.quantity *
            (double.parse(cartItem.tax.toString()));
        sdtax += itmeTotalTax;

        var itmeTotal = cartItem.quantity *
            (double.parse(cartItem.product!.mrp.toString()));

        var itmeTotalDiscount = cartItem.quantity *
            double.parse(cartItem.product!.discount.toString());

        st += itmeTotal;
      } else {
        // print("cartItem.tax :" +cartItem.tax.toString());
        var itmeTotalTax = cartItem.quantity *
            (double.parse(cartItem.tax.toString()));


        var itmeTotal = cartItem.quantity *
            (double.parse(cartItem.product!.mrp.toString()) -
                double.parse(cartItem.product!.discount.toString()));

        var itmeTotalDiscount = cartItem.quantity *
            double.parse(cartItem.product!.discount.toString());

        sdtax += itmeTotalTax;
        print("${sdtax} = ${cartItem.quantity} * ${cartItem.tax.toString()}");

        st += itmeTotal;
        dst += itmeTotalDiscount;
      }
    }
    tax.value = sdtax;
    subTotal.value = st;
    subTotalDiscount.value = dst;
  }

  void createTotal() {
    var newsub = double.parse(subTotal.value.toString());
    newsub = newsub - promoCodeValue.value;
    var shippingcharge = newsub >=
            num.parse(appConfigController.appConfig.no_shipping_charge_criteria_amount.toString())
        ? 0
        : num.parse(appConfigController.appConfig.shipping_fee.toString());
    newsub = newsub + shippingcharge;
    subTotalWithShipping.value = newsub;
    totalTax.value = tax.value;

    total.value = newsub + num.parse(totalTax.toString());
    if (checkoutController.serviceType.value ==
        AppConstraints.type.keys.first) {
      total.value = total.value + serviceCharge();
    }
  }

  serviceCharge() {
    var serviceCharge = (subTotal.value *
            double.parse(appConfigController
                .appConfig.urgent_service_charge_percent
                .toString())) /
        100;
    return serviceCharge;
  }

  changeIndex(index) {
    cartIndex.value = index;
  }

  CartItem isProductInCart(Product p) {
    CartItem item = new CartItem();
    cartItems.forEach((element) {
      if (p.id == element.product!.id) {
        item = element;
      }
    });

    return item;
  }

  Map<String, dynamic> toJson(var cartitems) => {
        "total": total.toString(),
        "subtotal": subTotal.toString(),
        "discount": subTotalDiscount.toString(),
        "user_id": signController.id.toString(),
        "shipping_charge": subTotal.value <
                double.parse(
                    appConfigController.appConfig.shipping_fee.toString())
            ? appConfigController.appConfig.shipping_fee.toString()
            : "0",
        "promoCodeValue": promoCodeValue.toString(),
        "totalTax": totalTax.toString(),
        "payment_methods": checkoutController.paymentMethod.toString(),
        "shipping_address": checkoutController.selectedAddress.toJson(),
        "coupon": coupon.toJson(),
        "landmark": checkoutController.landmarkDropDownValue.value.toString(),
        "pick_date_time": checkoutController.dateTime.value.toString(),
        "quantity": cartItems.length,
        "cart_items": cartitems,
        "serviceType": checkoutController.serviceType.value.toString(),
        "source": cartItems.first.type.toString(),
      };
}
