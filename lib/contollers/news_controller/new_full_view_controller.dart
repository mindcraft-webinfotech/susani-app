import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsFullViewController extends GetxController {
  var isLoading = true.obs;
  late WebViewController _controller;
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  get landmarkDropDownValue => null;

  @override
  void onInit() {
    super.onInit();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void loadNews(bool status) {
    isLoading.value = status;
  }
}
