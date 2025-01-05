//import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/views/widgets/bottom_navigation/circular_bottom_navigation.dart';

class DashboardController extends GetxController {
  late PageController pageController;
  late MyCircularBottomNavigationController navigationController;
  var currentIndex = 0.obs;
  GlobalKey bottomNavigatioKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();

    navigationController =
        MyCircularBottomNavigationController(currentIndex.value);
    pageController = PageController();
    _determinePosition();
  }

  void goToTab(int position) {
    currentIndex.value = position;
    navigationController.value = position;
    //changed...position 4 to 0
    if (position == 0) {
      Get.find<CartController>().changeIndex(0);
    }
    pageController.jumpToPage(position);
  }

  void goToDashboard(int position) {
    currentIndex.value = position;
    navigationController.value = position;
    if (position == 4) {
      Get.find<CartController>().changeIndex(0);
    }
    pageController = PageController(initialPage: position);

    Get.offAllNamed(MyPagesName.dashBoard);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // pageController.dispose();
    // navigationController.dispose();
  }
}
