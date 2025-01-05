import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/coupon_controller/CouponController.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

class GiftCardPage extends StatelessWidget {
  CouponController couponController = Get.put(CouponController());
  GiftCardPage({Key? key}) : super(key: key) {}

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
        title: const Text(
          "Promo Codes",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Obx(
        () => Container(
          child: couponController.myCouponList.length > 0
              ? ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: couponController.myCouponList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Card(
                          margin: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      couponController
                                          .myCouponList[index].coupon_code
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        couponController.myCouponList[index]
                                            .copied.value = true;
                                        Clipboard.setData(ClipboardData(
                                            text: couponController
                                                .myCouponList[index].coupon_code
                                                .toString()));
                                      },
                                      child: CircleAvatar(
                                        child: Obx(
                                          () => Icon(couponController
                                                  .myCouponList[index]
                                                  .copied
                                                  .value
                                              ? FontAwesomeIcons.check
                                              : Icons.copy),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        couponController
                                            .myCouponList[index].description
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    );
                  })
              : Container(
                  child: Center(
                      child: Text(couponController.status.value.toString())),
                ),
        ),
      ),
    );
  }
}
