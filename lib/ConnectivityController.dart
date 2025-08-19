import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var isConnected = true.obs; // Observable variable for connectivity status

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      isConnected.value = result != ConnectivityResult.none;
    });
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isConnected.value = connectivityResult != ConnectivityResult.none;
  }
}