import 'package:Susani/contollers/coupon_controller/CouponController.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/splash_controller/splash_controller.dart';

import '../../contollers/address_controller/address_controller.dart';
import '../../contollers/app_config/AppConfigController.dart';
import '../../contollers/cart_controller/cart_controller.dart';
import '../../contollers/checkout_controller/checkout_controller.dart';
import '../../contollers/product_controller/prodcut_controller.dart';
import '../../contollers/signin/SignInController.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<MyAppConfigController>(() => MyAppConfigController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CheckoutController>(() => CheckoutController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<CouponController>(() => CouponController());
  }
}
