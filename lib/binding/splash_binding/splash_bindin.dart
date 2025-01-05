import 'package:get/get.dart';
import 'package:Susani/contollers/splash_controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
