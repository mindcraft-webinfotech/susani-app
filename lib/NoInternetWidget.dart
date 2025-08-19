import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ConnectivityController.dart';


class NoInternetWidget extends StatelessWidget {
  final ConnectivityController connectivityController =
  Get.find<ConnectivityController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return connectivityController.isConnected.value
          ? SizedBox.shrink() // Hide if connected
          : Container(
        height: 50,
        color: Colors.red,
        child: Center(
          child: Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    });
  }
}