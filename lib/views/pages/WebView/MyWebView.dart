import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:Susani/contollers/news_controller/new_full_view_controller.dart';

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

final controller = Get.put(NewsFullViewController());

class _MyWebViewState extends State<MyWebView> {
  late InAppWebViewController _webViewController;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          args[1], // Assuming args[1] is the title
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(args[0])), // Assuming args[0] is the URL
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Add back navigation
  Future<bool> _goBack(BuildContext context) async {
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
      return false; // Prevent the default back action
    } else {
      Get.back();
      return true; // Allow the back action in the navigator
    }
  }
}