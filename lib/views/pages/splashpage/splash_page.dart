import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_images.dart';
import 'package:Susani/contollers/splash_controller/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Get.find<SplashController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Image.asset(
      AppImages.APP_LOGO,
      width: 350,
      height: 200,
      alignment: Alignment.center,
    )));
  }
}
