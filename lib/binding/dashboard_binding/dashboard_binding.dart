import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/app_config/AppConfigController.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/coupon_controller/CouponController.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/news_controller/news_controller.dart';
import 'package:Susani/contollers/search_controller/search_controller.dart';
import 'package:Susani/contollers/slider_controller/slider_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NewsController>(NewsController());
    Get.put<SliderController>(SliderController());
    Get.put<SearchControllerone>(SearchControllerone());
    Get.put<CartController>(CartController());
    Get.put<MyAppConfigController>(MyAppConfigController());
    Get.put<ProductController>(ProductController());
    Get.put<AddressController>(AddressController());
    Get.put<CheckoutController>(CheckoutController());
    Get.put<SignInController>(SignInController());
    Get.put<CouponController>(CouponController());
  }
}
