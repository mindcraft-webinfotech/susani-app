import 'package:flutter/material.dart';

class TabItem {
  String imageLink;
  String title;
  Color circleColor;
  TextStyle labelStyle;

  TabItem(this.imageLink, this.title, this.circleColor,
      {this.labelStyle = const TextStyle(fontWeight: FontWeight.bold)});
}
