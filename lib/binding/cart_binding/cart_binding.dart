import 'package:get/get.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
  }
}
