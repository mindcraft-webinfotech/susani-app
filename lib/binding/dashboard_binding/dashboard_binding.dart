import 'package:get/get.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/news_controller/news_controller.dart';
import 'package:Susani/contollers/search_controller/search_controller.dart';
import 'package:Susani/contollers/slider_controller/slider_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    //hide the following line by kamlesh

    // Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<NewsController>(() => NewsController());
    Get.lazyPut<SliderController>(() => SliderController());
    Get.lazyPut<SearchControllerone>(() => SearchControllerone());
    // Get.put<SearchController>(SearchController());
    Get.put<CartController>(CartController());
  }
}
