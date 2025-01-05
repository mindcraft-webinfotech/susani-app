import 'dart:async';
import 'dart:convert';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

import '../contollers/checkout_controller/checkout_controller.dart';
import '../contollers/dashboard_controller/dashboard_controller.dart';
import '../utils/routes_pages/pages_name.dart';

// class PayUMoney extends StatefulWidget {
//   Map<String, dynamic> rawdata;
//
//   PayUMoney({required this.rawdata});
//
//   @override
//   _PayUMoneyState createState() => new _PayUMoneyState();
// }
//
// class _PayUMoneyState extends State<PayUMoney> {
//   final GlobalKey webViewKey = GlobalKey();
//
//   InAppWebViewController? webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
//         useShouldOverrideUrlLoading: true,
//         mediaPlaybackRequiresUserGesture: false,
//       ),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         allowsInlineMediaPlayback: true,
//       ));
//
//   late PullToRefreshController pullToRefreshController;
//   String url = "";
//   double progress = 0;
//   final urlController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             child: Column(children: <Widget>[
//       Expanded(
//         child: Stack(
//           children: [
//             InAppWebView(
//               key: webViewKey,
//               initialUrlRequest: URLRequest(
//                   url: Uri.parse(
//                       "https://susani.in/PayUMoney/PayUMoney_form.php"),
//                   method: 'POST',
//                   body: Uint8List.fromList(
//                       utf8.encode(jsonEncode(widget.rawdata)))),
//               initialOptions: options,
//               pullToRefreshController: pullToRefreshController,
//               onWebViewCreated: (controller) {
//                 webViewController = controller;
//               },
//               onLoadStart: (controller, url) {
//                 setState(() {
//                   this.url = url.toString();
//                   urlController.text = this.url;
//                 });
//               },
//               androidOnPermissionRequest:
//                   (controller, origin, resources) async {
//                 return PermissionRequestResponse(
//                     resources: resources,
//                     action: PermissionRequestResponseAction.GRANT);
//               },
//               shouldOverrideUrlLoading: (controller, navigationAction) async {
//                 var uri = navigationAction.request.url!;
//
//                 if (![
//                   "http",
//                   "https",
//                   "file",
//                   "chrome",
//                   "data",
//                   "javascript",
//                   "about"
//                 ].contains(uri.scheme)) {
//                   if (await canLaunch(url)) {
//                     // Launch the App
//                     await launch(
//                       url,
//                     );
//                     // and cancel the request
//                     return NavigationActionPolicy.CANCEL;
//                   }
//                 }
//                 return NavigationActionPolicy.ALLOW;
//               },
//               onLoadStop: (controller, url) async {
//                 pullToRefreshController.endRefreshing();
//                 print("-----------" + url.toString());
//                 setState(() {
//                   this.url = url.toString();
//                   print(url.toString());
//                   urlController.text = this.url;
//                 });
//                 if (url.toString().contains("success")) {
//                   var html = await controller.evaluateJavascript(
//                       source: "window.document.body.innerText;");
//                   print(html.toString());
//                   Get.offNamed(MyPagesName.OrderSuccess);
//                 } else if (url.toString().contains("failure")) {
//                   var html = await controller.evaluateJavascript(
//                       source: "window.document.body.innerText;");
//                   print("Printing html----------------");
//                   print(html);
//                   Get.snackbar("Error", "Transaction Failed Try again");
//                   Get.back();
//                 }
//               },
//               onLoadError: (controller, url, code, message) {
//                 pullToRefreshController.endRefreshing();
//               },
//               onProgressChanged: (controller, progress) {
//                 if (progress == 100) {
//                   pullToRefreshController.endRefreshing();
//                 }
//                 setState(() {
//                   this.progress = progress / 100;
//                   urlController.text = this.url;
//                 });
//               },
//               onUpdateVisitedHistory: (controller, url, androidIsReload) {
//                 setState(() {
//                   this.url = url.toString();
//                   urlController.text = this.url;
//                 });
//               },
//               onConsoleMessage: (controller, consoleMessage) {
//                 print(consoleMessage);
//               },
//             ),
//             progress < 1.0
//                 ? LinearProgressIndicator(value: progress)
//                 : Container(),
//           ],
//         ),
//       ),
//     ])));
//   }
// }

class RazorPayment extends StatefulWidget {
  Map<String, dynamic> rawdata;

  RazorPayment({required this.rawdata});

  @override
  State<RazorPayment> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RazorPayment> {
  CartController cartController = Get.put(CartController());

  DashboardController dashboardController = Get.put(DashboardController());
  final _razorpay = Razorpay();
  String apiKey = 'rzp_live_lWgae2niXTNDM5';
  String apiSecret = 'BJuFDadUj9tukV209ntb2eL5';
  var check = Get.put(CheckoutController());
  var cartC = Get.put(CartController());

  User user = User();

  Map<String, dynamic> paymentData = {
    'amount': 50000, // amount in paise (e.g., 1000 paise = Rs. 10)
    'currency': 'INR',
    'name': "susani"
    // 'receipt': 'order_receipt',
    // 'payment_capture': '1',
  };

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'RazorPay Payment Gateway',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListTile(
            title: const Text(
              "Are you sure?You want to Go Online mode!",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            subtitle: const Text('Susani order payment'),
            trailing: ElevatedButton(
              onPressed: () {
                // checkout to payment
                initiatePayment();
              },
              child: const Text("yes"),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // Here we get razorpay_payment_id razorpay_order_id razorpay_signature
    Future.delayed(
      Duration(seconds: 1),
      () async {
        http.Response datares =
            (await MyApi.paymentresponse(response.paymentId));
        if (datares.statusCode == 200) {
          print("response after success--->" + datares.body.toString());
        } else {
          print("failed transcation----->");
        }
      },
    );
    print("This is the payment id====>" + response.paymentId.toString());

    Get.toNamed(MyPagesName.OrderSuccess);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("payment failed response--->" + response.error.toString());
    var msg = response.message;
    print("paymentfailed msg----->" + msg.toString());
    if (msg == "Payment Error") {
      cartController
          .daleteAllItem()
          .then((value) => dashboardController.goToDashboard(1));
    }

    // Future.delayed(
    //   Duration(seconds: 1),
    //   () async {
    //     if (response.message ==
    //         "You may have cancelled the payment or there was a delay in response from the UPI app")
    //       Get.to(DashboardPage());
    //   },
    // );

    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response.walletName.toString());
    // Do something when an external wallet is selected
  }

  Future<void> initiatePayment() async {
    // String apiUrl = 'https://api.razorpay.com/v1/orders';
    User user = await CommonTool().getUserId();
    String apiUrl = 'https://susani.in/payment_susani.php';
    // Make the API request to create an order
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      // headers: {
      //   'Content-Type': 'application/json',
      //   'Authorization':
      //       'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
      // },
      body: {
        "name": user.name.toString(),
        "amount": cartC.total.toString(),
        "currency": "INR",
        "order_id": check.order_id.toString()
      },
    );

    print("this the recent name====>" + user.name.toString());
    print("this the recent amount====>" + cartC.total.toString());
    print("this the recent currency====>" + "INR");
    print("this the recent order_id====>" + check.order_id.toString());

    if (response.statusCode == 200) {
      // Parse the response to get the order ID
      var responseData = jsonDecode(response.body);
      print("this is response after hiting---->" + responseData.toString());
      String? orderId = responseData['id'];
      print("id :--->" + orderId.toString());

      // Set up the payment options
      var options = {
        'key': apiKey,
        "amount": (cartC.total).toString(),
        "amount_due": "0",
        "amount_paid": 0,
        "attempts": 0,
        "created_at": 1705314998,

        // "created_at": ,
        "currency": "INR",
        "entity": "order",
        "id": orderId,
        "notes": [],
        "offer_id": null,
        "receipt": "222",
        "status": "created",
        'order_id': orderId,
        'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
        'external': {
          'wallets': ['paytm'] // optional, for adding support for wallets
        }
      };

      // Open the Razorpay payment form
      _razorpay.open(options);
    } else {
      // Handle error response
      debugPrint('Error creating order: ${response.body}');
    }
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }
}
