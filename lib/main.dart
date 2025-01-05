import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_theme.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/utils/routes_pages/routes_pages.dart';

Future<void> main() async {
  //XIcons.register("namespace", CustomIcons.mapping);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: AppColor.backgroundColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: "Susani",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        initialRoute: MyPagesName.splashFile,
        getPages: MyPages.list);
  }
}
