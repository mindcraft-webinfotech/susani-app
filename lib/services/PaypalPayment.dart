import 'dart:convert';
import 'dart:core';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/app_config/AppConfigController.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'PaypalServices.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  Map<String, dynamic> rawdata;

  PaypalPayment({required this.rawdata, required this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();
  var checkoutController = Get.put(CheckoutController());
  var cartController = Get.put(CartController());
  var appConfig = Get.put(MyAppConfigController());
  var signInController = Get.put(SignInController());
  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    print(widget.rawdata);
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        // _scaffoldKey.currentState!.showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'iPhone X';
  String itemPrice = '10.0';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List cartItems = [];
    double total = 0;
    for (var i = 0; i < cartController.cartItems.length; i++) {
      // print("Multiplying ===" + i.toString());
      // print(total);
      // print("mrp:" + cartController.cartItems[i].product!.mrp!);
      // print("price:" + cartController.cartItems[i].product!.price!);
      // total = double.parse(cartController.cartItems[i].product!.mrp!) *
      //     cartController.cartItems[i].quantity!;
      cartItems.add({
        "name": cartController.cartItems[i].product!.name.toString(),
        "quantity": cartController.cartItems[i].quantity.toString(),
        "price":
            double.parse(cartController.cartItems[i].product!.mrp!).toString(),
        "currency": defaultCurrency["currency"].toString()
      });
    }
    // print("==================");
    // print(jsonEncode(cartItems));
    // List items = [
    //   {
    //     "name": itemName,
    //     "quantity": quantity,
    //     "price": itemPrice,
    //     "currency": defaultCurrency["currency"]
    //   },
    //   {
    //     "name": itemName,
    //     "quantity": quantity,
    //     "price": itemPrice,
    //     "currency": defaultCurrency["currency"]
    //   }
    // ];

    // checkout invoice details
    // String totalAmount = total.toString();
    // String subTotalAmount = total.toString();
    // String shippingCost = '0';
    // int shippingDiscountCost = 0;
    // String userFirstName = 'Gulshan';
    // String userLastName = 'Yadav';
    // String addressCity = 'Delhi';
    // String addressStreet = 'Mathura Road';
    // String addressZipCode = '110014';
    // String addressCountry = 'India';
    // String addressState = 'Delhi';
    // String addressPhoneNumber = '+919990119091';

    // total = cartController.subTotal.value +
    //     appConfig.appConfig.shipping_fee! +
    //     cartController.totalTax.value;

    // print(total.toString() +
    //     "---" +
    //     cartController.subTotal.value.toString() +
    //     "--------" +
    //     cartController.total.value.toString());

    String totalAmount = cartController.total.value.toString();
    String subTotalAmount = cartController.subTotal.value.toString();
    String shippingCost = appConfig.appConfig.shipping_fee.toString();
    int shippingDiscountCost = 0;
    String userFirstName = signInController.user.value.name.toString();
    String userLastName = signInController.user.value.last_name.toString();
    String addressCity =
        checkoutController.selectedAddress.value.city.toString();
    String addressStreet =
        checkoutController.selectedAddress.value.address.toString();
    String addressZipCode =
        checkoutController.selectedAddress.value.pincode.toString();
    String addressCountry = 'USA';
    String addressState =
        checkoutController.selectedAddress.value.city.toString();
    String addressPhoneNumber = signInController.user.value.contact.toString();

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "tax": cartController.totalTax.value.toString(),
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": cartItems,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // print(checkoutUrl);
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          // onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }

            final uri = Uri.parse(request.url);
            final payerID = uri.queryParameters['PayerID'];
            if (payerID != null) {
              services
                  .executePayment(Uri.parse(executeUrl!), payerID, accessToken)
                  .then((id) {
                // widget.onFinish(id);
                // checkoutController.checkoutOrder(widget.rawdata);
                // Navigator.of(context).pop();
              });
            } else {
              // checkoutController.checkoutOrder(widget.rawdata);
              // Navigator.of(context).pop();
            }

            // Navigator.of(context).pop();

            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));

    if (checkoutUrl != null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios),
              onTap: () => Navigator.pop(context),
            ),
          ),
          body: WebViewWidget(controller: controller)

          //  WebView(
          //   initialUrl: checkoutUrl,
          //   navigationDelegate: (NavigationRequest request) {
          //     if (request.url.contains(returnURL)) {
          //       final uri = Uri.parse(request.url);
          //       final payerID = uri.queryParameters['PayerID'];
          //       if (payerID != null) {
          //         services
          //             .executePayment(
          //                 Uri.parse(executeUrl!), payerID, accessToken)
          //             .then((id) {
          //           // widget.onFinish(id);
          //           // checkoutController.checkoutOrder(widget.rawdata);
          //           // Navigator.of(context).pop();
          //         });
          //       } else {
          //         // checkoutController.checkoutOrder(widget.rawdata);
          //         // Navigator.of(context).pop();
          //       }

          //       // Navigator.of(context).pop();
          //     }
          //     if (request.url.contains(cancelURL)) {
          //       Navigator.of(context).pop();
          //     }
          //     return NavigationDecision.navigate;
          //   },
          // ),
          );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
