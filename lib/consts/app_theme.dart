import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Susani/consts/app_color.dart';

class AppTheme {
  static ThemeData get appTheme => ThemeData(
      scaffoldBackgroundColor: AppColor.backgroundColor,
      primaryColor: AppColor.backgroundColor,

      //appbar Theme
      appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          systemOverlayStyle: SystemUiOverlayStyle(),
          backgroundColor: Color.fromARGB(255, 242, 246, 249)),

      //texttheme
      textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)),

      //divider color theme
      dividerColor: AppColor.dividerColor);
  static TextStyle smallTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static TextStyle smallTextStyl = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.red,
  );

  static TextStyle headingSmallTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
}
