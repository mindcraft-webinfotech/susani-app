import 'dart:convert';
import 'package:get/get.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/models/Coupon.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:http/http.dart' as http;

class CouponController extends GetxController {
  Coupon myCoupon = Coupon();
  var myCouponList = <Coupon>[].obs;
  CartController cartController = Get.put(CartController());
  var status = "".obs;
  @override
  void onInit() {
    status.value = "";
    getAllCoupon();
    super.onInit();
  }

  void getCouponByCoupon(Coupon coupon) {
    status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getCouponByCoupon(coupon);
      // print("===========>>>>>>>>>");
      print(response.body);
      if (response.statusCode == 200) {
        status.value = "Applied";
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          myCoupon = Coupon.fromJson((data['data'] as List)[0]);

          if (myCoupon.min_purchase_amt! <=
              cartController.subTotalWithShipping.value) {
            if (myCoupon.coupon_type!.toLowerCase() == "amount") {
              cartController.promoCodeValue.value = myCoupon.amount!;
            } else if (myCoupon.coupon_type!.toLowerCase() == "percent") {
              cartController.promoCodeValue.value =
                  cartController.subTotal.value * myCoupon.amount! / 100;
            }
            cartController.coupon.value = myCoupon;
            cartController.createTotal();
          } else {
            status.value = "Minimum cart amount required: " +
                myCoupon.min_purchase_amt.toString();
          }
          // print("Promocode in cart" +
          //     cartController.promoCodeValue.value.toString());
        } else {
          status.value = "" + msg;
        }
      } else {
        status.value = "Failed to apply coupon";

        //throw Exception('Failed to load album');
      }
    });
  }

  void getAllCoupon() {
    status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.AllCoupon();
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          status.value = "Done";
          myCouponList.value =
              re.map<Coupon>((e) => Coupon.fromJson(e)).toList();
        } else {
          status.value = "Failed: " + msg;
        }
      } else {
        status.value = "Failed with exception";
      }
    });
  }
}
