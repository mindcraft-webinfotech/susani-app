import 'package:Susani/views/widgets/check_out_widget/first_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/views/widgets/app_button.dart';

import '../../../contollers/address_controller/address_controller.dart';

class SecondWidget {
  final BuildContext context;
  var checkoutController = Get.find<CheckoutController>();
  var addressController = Get.find<AddressController>();

  SecondWidget({required this.context});

  Container get secondWidget {
    var first = FirstWidget(context: context);
    return addressController.pincodeStatus.value == false
        ? Container(
            child: Center(
            child: Text(
              "You Have not selected the Landmark.Please select Landmark",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ))
        : Container(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment Methods",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      color: Colors.transparent,
                      elevation: 0.1,
                      shadowColor: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.black.withAlpha(30),
                        onTap: () {
                          checkoutController.paymentMethod.value =
                              AppConstraints.paymentMethods[0];
                        },
                        child: SizedBox(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            width: 85,
                            decoration: BoxDecoration(
                                color: checkoutController.paymentMethod.value ==
                                        AppConstraints.paymentMethods[0]
                                    ? Colors.black
                                    : Colors.transparent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(
                                      AppConstraints.paymentMethodsImage[0]),
                                  height: 30,
                                  color:
                                      checkoutController.paymentMethod.value ==
                                              AppConstraints.paymentMethods[0]
                                          ? Colors.white
                                          : Colors.black,
                                ),
                                Text(
                                  AppConstraints.paymentMethods[0],
                                  style: TextStyle(
                                      color: checkoutController
                                                  .paymentMethod.value ==
                                              AppConstraints.paymentMethods[0]
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                  textScaleFactor: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Card(
                    //   clipBehavior: Clip.antiAlias,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5.0),
                    //     side: BorderSide(
                    //       color: Colors.grey,
                    //       width: 1.0,
                    //     ),
                    //   ),
                    //   color: Colors.transparent,
                    //   elevation: 0.1,
                    //   shadowColor: Colors.transparent,
                    //   child: InkWell(
                    //     splashColor: Colors.black.withAlpha(30),
                    //     onTap: () {
                    //       checkoutController.paymentMethod.value =
                    //           AppConstraints.paymentMethods[1];
                    //     },
                    //     child: SizedBox(
                    //       child: Container(
                    //         padding: EdgeInsets.all(5),
                    //         width: 85,
                    //         decoration: BoxDecoration(
                    //             color: checkoutController.paymentMethod.value ==
                    //                     AppConstraints.paymentMethods[1]
                    //                 ? Colors.black
                    //                 : Colors.transparent),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Image(
                    //               image: AssetImage(
                    //                   AppConstraints.paymentMethodsImage[1]),
                    //               height: 30,
                    //               color:
                    //                   checkoutController.paymentMethod.value ==
                    //                           AppConstraints.paymentMethods[1]
                    //                       ? Colors.white
                    //                       : Colors.black,
                    //             ),
                    //             Text(
                    //               AppConstraints.paymentMethods[1],
                    //               style: TextStyle(
                    //                   color: checkoutController
                    //                               .paymentMethod.value ==
                    //                           AppConstraints.paymentMethods[1]
                    //                       ? Colors.white
                    //                       : Colors.black,
                    //                   fontSize: 10,
                    //                   fontWeight: FontWeight.bold),
                    //               textScaleFactor: 1,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      color: Colors.transparent,
                      elevation: 0.1,
                      shadowColor: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.black.withAlpha(30),
                        onTap: () {
                          checkoutController.paymentMethod.value =
                              AppConstraints.paymentMethods[2];
                        },
                        child: SizedBox(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            width: 85,
                            decoration: BoxDecoration(
                                color: checkoutController.paymentMethod.value ==
                                        AppConstraints.paymentMethods[2]
                                    ? Colors.black
                                    : Colors.transparent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(
                                      AppConstraints.paymentMethodsImage[2]),
                                  height: 30,
                                  color:
                                      checkoutController.paymentMethod.value ==
                                              AppConstraints.paymentMethods[2]
                                          ? Colors.white
                                          : Colors.black,
                                ),
                                Text(
                                  AppConstraints.paymentMethods[2],
                                  style: TextStyle(
                                      color: checkoutController
                                                  .paymentMethod.value ==
                                              AppConstraints.paymentMethods[2]
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                  textScaleFactor: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
  }
}
