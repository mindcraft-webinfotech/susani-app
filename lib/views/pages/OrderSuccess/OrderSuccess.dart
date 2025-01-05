import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/utils/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/models/Coupon.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/views/widgets/app_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../models/User.dart';
import '../WebView/MyWebView.dart';

class OrderSuccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderScuccessState();
}

class _OrderScuccessState extends State<OrderSuccess> {
  DashboardController dashboardController = Get.put(DashboardController());
  CartController cartController = Get.put(CartController());
  CheckoutController checkoutController = Get.put(CheckoutController());
  var signIn = Get.put(SignInController());
  var addC = Get.put(AddressController());

  Future<bool> _onWillPop() async {
    return false;
  }

  void clean() {
    // -----------------------------clearing checkout
    checkoutController.currentStep.value = 0;
    checkoutController.showNewAddressForm.value = false;
    checkoutController.selectedId.value = 0;

    checkoutController.paymentMethod.value = "";
    checkoutController.selectedAddress.value = new Address();
    checkoutController.status.value = "";
    checkoutController.order_id.value = "";
    // -------------------clearing cart
    cartController.subTotal.value = 0.0;
    cartController.subTotalWithShipping.value = 0.0;
    cartController.total.value = 0.0;
    cartController.totalTax.value = 0.0;
    cartController.promoCodeValue.value = 0.0;
    cartController.coupon.value = new Coupon();
    cartController.cartItems.clear();
    checkoutController.getAllLandMarks(
        int.parse(signIn.id.value), addC.addresses[0].pincode!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Order successful"),
          centerTitle: true,
          leading: Text(""),
          actions: [
            GestureDetector(
              onTap: () {
                clean();
                cartController
                    .daleteAllItem()
                    .then((value) => dashboardController.goToDashboard(0));
              },
              child: Icon(
                Icons.close,
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.checkCircle,
              color: Colors.blueGrey,
              size: 100,
            ),
            Container(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Html(
                            onAnchorTap: (url, attributes, element) {
                              clean();

                              Get.offNamed(MyPagesName.myOrders);
                            },
                            data: "You order <strong>" +
                                checkoutController.order_id.value.toString() +
                                "</strong> is completed. Please check the delivery status at <a  href="
                                    "><strong>Order History</strong></a> page",
                            style: {
                              "body": Style(
                                margin: Margins.only(top: 10),
                                padding: HtmlPaddings.zero,
                              ),
                              'a': Style(
                                  color: Colors.black,
                                  textDecoration: TextDecoration.none),
                              'html': Style(textAlign: TextAlign.center),
                            }),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // height: 250,
                // color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                clean();
                                cartController.daleteAllItem().then((value) =>
                                    dashboardController.goToDashboard(1));
                              },
                              child: AppButton(buttonTitle: "Continue Shopping")
                                  .myButton,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
