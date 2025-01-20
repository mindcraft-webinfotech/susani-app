import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/consts/app_theme.dart';
import 'package:Susani/contollers/order_history/OrderHistory.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';

import '../../../models/User.dart';
import '../../../utils/common_tools.dart';
import 'package:lottie/lottie.dart';

class MyOrdersPage extends StatelessWidget {
  var controller = Get.put(OrderHistoryController());
  var signInController = Get.put(SignInController());
  var productController = Get.find<ProductController>();

  MyOrdersPage() {
    CommonTool().getUserId().then((value) =>
        {controller.orderHistory(User(id: signInController.id.value))});
  }

  List<PopupMenuItem> getFilterItems() {
    var popItems = <PopupMenuItem>[];
    int i = 0;
    AppConstraints.filterList.forEach((element) {
      popItems.add(PopupMenuItem(
        child: Text(element),
        value: i,
      ));

      i++;
    });
    return popItems;
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
            title: const Text(
              "My Order History",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            actions: [
              Obx(() => PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black.withAlpha(50)),
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 1,
                  color: Colors.white.withAlpha(240),
                  offset: Offset(0, 40),
                  tooltip: "Filter",
                  initialValue: productController.sortIndex.value,
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        {
                          // productController.sortIndex.value = value as int;

                          // productController.sortProductByLatest(
                          //     productController.productList);
                          break;
                        }

                      case 1:
                        {
                          // productController
                          //     .sortProductByAtoZ(productController.productList);

                          // productController.sortIndex.value = value as int;
                          break;
                        }
                      case 2:
                        {
                          // productController
                          //     .sortProductByZtoA(productController.productList);
                          // productController.sortIndex.value = value as int;
                          break;
                        }
                      case 3:
                        {
                          // productController
                          //     .sortProductByASC(productController.productList);
                          // productController.sortIndex.value = value as int;
                          break;
                        }
                      case 4:
                        {
                          // productController
                          //     .sortProductByDESC(productController.productList);
                          // productController.sortIndex.value = value as int;
                          break;
                        }

                      default:
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  itemBuilder: (context) => getFilterItems()))
            ]),
        body: Obx(
          () => controller.status == "Loading"
              ? Center(
                  child: Text("Loading records.."),
                )
              : controller.orders.length < 1
                  ? Center(
                      child: Text("Order history is empty!"),
                    )
                  : ListView.builder(
                      itemCount: controller.orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            margin: EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order id: #" +
                                              controller
                                                  .orders[index].order_id!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          controller.orders[index].date_time
                                              .toString(),
                                          style: AppTheme.smallTextStyle,
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(MyPagesName.editProfile);
                                      },
                                      child: CircleAvatar(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                              imageUrl: signInController
                                                  .user.value.image.value),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  child: Column(
                                      children: itemList(
                                          controller.orders[index].cartItems!,
                                          index)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    controller.orders[index].payment_methods!
                                                    .toLowerCase() ==
                                                "online" &&
                                            controller
                                                .orders[index].transaction_id!
                                                .trim()
                                                .isEmpty
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 30),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Color.fromARGB(
                                                            255, 211, 10, 23)
                                                        .withAlpha(200))),
                                            child: Text("Payment failed"),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              controller.orderStatus(controller
                                                  .orders[index].order_id!);

                                              Get.defaultDialog(
                                                  title: 'Order Status',
                                                  content: Obx(
                                                    () =>
                                                        controller.order_status
                                                                    .value ==
                                                                "Loading"
                                                            ? Center(
                                                                child:
                                                                    Container(
                                                                  child: CircularProgressIndicator(
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              )
                                                            : Container(
                                                                height:
                                                                    Get.height /
                                                                        2,
                                                                width:
                                                                    Get.width -
                                                                        20,
                                                                child: ListView
                                                                    .builder(
                                                                  physics:
                                                                      AlwaysScrollableScrollPhysics(),
                                                                  itemCount:
                                                                      controller
                                                                          .orderStatusResponse
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                  child: controller.orderStatusResponse[index].profile.toString() == "null"
                                                                                      ? Image.network(AppConstraints.DEFAULIMAGE, height: 100, width: 100, errorBuilder: (context, error, stackTrace) {
                                                                                          return Icon(Icons.error);
                                                                                        })
                                                                                      : Image.network(
                                                                                          AppConstraints.PROFILE_URL + controller.orderStatusResponse[index].profile.toString(),
                                                                                          height: 100,
                                                                                          width: 100,
                                                                                          fit: BoxFit.fill,
                                                                                          errorBuilder: (context, error, stackTrace) {
                                                                                            return Icon(Icons.error);
                                                                                          },
                                                                                        ),
                                                                                ),
                                                                              ]),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(controller.orderStatusResponse[index].name.toString() + controller.orderStatusResponse[index].lastname.toString() + "(" + controller.orderStatusResponse[index].gender.toString() + ")", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                50,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text("Contact", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                                                                              Text(controller.orderStatusResponse[index].mobile.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text("Assigned For", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                                                                              Text(controller.orderStatusResponse[index].assigningFor.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Current Status",
                                                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                                              ),
                                                                              Text(
                                                                                controller.orderStatusResponse[index].factoryStatus.toString(),
                                                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                100,
                                                                          ),
                                                                          controller.orderStatusResponse[index].requestStatus.toString() == "deliver"
                                                                              ? Lottie.asset("assets/images/Done.json", height: 100, width: 100)
                                                                              : Container()
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                  ),
                                                  cancel: ElevatedButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      child: Text("Ok")));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 30),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.green
                                                          .withAlpha(200))),
                                              child: Text("Check Status"),
                                            ),
                                          ),

                                    // Container(
                                    //   padding: EdgeInsets.symmetric(
                                    //       vertical: 1, horizontal: 1),
                                    //   decoration: BoxDecoration(
                                    //     color: Color.fromARGB(255, 18, 116, 83),
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(5)),
                                    //       border: Border.all(
                                    //           width: 1,
                                    //           color:
                                    //               Colors.black.withAlpha(200)
                                    //               )),
                                    //   child: IconButton(onPressed: (){

                                    //   }, icon: Icon(Icons.map_outlined)
                                    //   ),
                                    // ),
                                    controller.orders[index].payment_methods!
                                                    .toLowerCase() ==
                                                "online" &&
                                            controller
                                                .orders[index].transaction_id!
                                                .trim()
                                                .isEmpty
                                        ? Container()
                                        : GestureDetector(
                                            onTap: () {
                                              Get.defaultDialog(
                                                  title: "CONFIRMATION",
                                                  titleStyle:
                                                      TextStyle(fontSize: 16),
                                                  middleText: controller
                                                              .orders[index]
                                                              .cancellationRequest ==
                                                          "yes"
                                                      ? "I want to cancel 'The Request' "
                                                      : "Are you sure you want to cancel this order?",
                                                  middleTextStyle:
                                                      TextStyle(fontSize: 12),
                                                  cancel: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.white),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text("Close",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ))),
                                                  confirm: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueGrey,
                                                              elevation: 5),
                                                      onPressed: () {
                                                        controller.cancelOrder(
                                                            controller
                                                                .orders[index]
                                                                .user_id
                                                                .toString(),
                                                            controller
                                                                .orders[index]
                                                                .id
                                                                .toString());
                                                        Get.back();
                                                      },
                                                      child: Text("Proceed",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ))),
                                                  contentPadding:
                                                      EdgeInsets.all(20));
                                            },
                                            child: controller
                                                        .orders[index].picked_up
                                                        .toString() ==
                                                    null
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.red
                                                                .withAlpha(
                                                                    200))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.cancel_outlined,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(
                                                          width: controller
                                                                      .orders[
                                                                          index]
                                                                      .cancellationRequest ==
                                                                  "yes"
                                                              ? 0
                                                              : 20,
                                                        ),
                                                        Text(
                                                          controller
                                                                      .orders[
                                                                          index]
                                                                      .cancellationRequest ==
                                                                  "yes"
                                                              ? 'Cancel Request Sent'
                                                              : controller
                                                                  .orders[index]
                                                                  .picked_up!,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                          ),

                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.orders[index].quantity
                                                  .toString() +
                                              " Items",
                                          style: AppTheme.smallTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "\₹" +
                                              controller.orders[index].total
                                                  .toString(),
                                          style: AppTheme.headingSmallTextStyle,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
        ));
  }

  List<Widget> itemList(List<dynamic> cartItems, int index) {
    List<Widget> itemlis = [];
    for (int subindex = 0; subindex < cartItems.length; subindex++) {
      itemlis.add(Card(
          elevation: 0,
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(MyPagesName.productFullView,
                          arguments: controller
                              .orders[index].cartItems![subindex].product.id);
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(AppConstraints.PRODUCT_URL +
                          "" +
                          controller.orders[index].cartItems![subindex].product
                              .img[0]),
                      radius: 25,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Colors.grey.withAlpha(50)))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.orders[index].cartItems![subindex]
                                .product.name,
                            style: AppTheme.headingSmallTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            controller.orders[index].cartItems![subindex]
                                .product.name,
                            style: AppTheme.smallTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\₹ " +
                                    controller.orders[index]
                                        .cartItems![subindex].product.mrp
                                        .toString(),
                                style: AppTheme.headingSmallTextStyle,
                              ),
                              Text(
                                "Qty: " +
                                    controller.orders[index]
                                        .cartItems![subindex].quantity
                                        .toString(),
                                style: AppTheme.headingSmallTextStyle,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )));
    }
    return itemlis;
  }
}
