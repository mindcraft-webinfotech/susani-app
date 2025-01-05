import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/news_controller/new_full_view_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  var args = Get.arguments;
  @override
  WebViewState createState() => WebViewState();
}

final controller = Get.put(NewsFullViewController());

class WebViewState extends State<MyWebView> {
  late WebViewController _controller;
  bool isLoading = true;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // print(Get.arguments.toString());
    // print(
    //     "https://kushgods.credofusion.com/newsDetails.php?news_id=${Get.arguments[0]}");
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              )),
          centerTitle: true,
          title: Text(
            Get.arguments[1],
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            WillPopScope(
              onWillPop: () => _goBack(context),
              child: Text("Webview upgrade required"),
              // child: WebView(
              //   initialUrl: widget.args[0],
              //   javascriptMode: JavascriptMode.unrestricted,
              //   onWebViewCreated: (WebViewController webViewController) {
              //     _controllerCompleter.future
              //         .then((value) => _controller = value);
              //     _controllerCompleter.complete(webViewController);
              //   },
              //   onPageFinished: (finish) {
              //     setState(() {
              //       isLoading = false;
              //     });
              //   },
              // ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Stack(),
          ]),
        ));
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      Get.back();
      return Future.value(true);
    }
  }
}
