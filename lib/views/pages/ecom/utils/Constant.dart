import 'package:flutter/material.dart';

import 'SizeConfig.dart';

class Constant {
  static String assetImagePath = "assets/images/";
  static String fontsFamily = "FontsFree-Net-SFCompactText";

  static double getPercentSize(double total, double percent) {
    return (percent * total) / 100;
  }

  static double getToolbarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top + kToolbarHeight;
  }

  static double getToolbarTopHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getHeightPercentSize(double percent) {
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    return (percent * screenHeight) / 100;
  }

  static double getWidthPercentSize(double percent) {
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    return (percent * screenWidth) / 100;
  }

  static sendToScreen(Widget widget, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => widget,
    ));
  }

  static backToFinish(BuildContext context) {
    Navigator.of(context).pop();
  }
}