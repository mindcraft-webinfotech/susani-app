import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/app_config/AppConfigController.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/contollers/wishlist/WishlistController.dart';
import 'package:Susani/models/CartItem.dart';
import 'package:Susani/models/product.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/views/widgets/app_button.dart';
import 'package:Susani/views/widgets/product_design.dart';

class ProductFullViewPage extends StatefulWidget {
  @override
  State<ProductFullViewPage> createState() => _ProductFullViewPageState();
}

class _ProductFullViewPageState extends State<ProductFullViewPage> {
  Product? product;
  var pid;
  final _controller = ScrollController();
  var wishlistController = Get.put(WishlistController());
  var signinController = Get.put(SignInController());
  var controller = Get.put(ProductController());
  var cartController = Get.put(CartController());
  var dashboardController = Get.put(DashboardController());
  var checkoutController = Get.put(CheckoutController());
  var addressController = Get.put(AddressController());
  var isLoading = false;
  MyAppConfigController appConfigController = Get.put(MyAppConfigController());

  @override
  void initState() {
    addressController.loadAddress(signinController.user.value);
    pid = Get.arguments.toString();
    controller.loadProduct(Get.arguments.toString());
    print(controller.status.value);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColor.backgroundColor,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // bottom: true,
      // top: false,
      // left: true,
      // right: true,
      child: Scaffold(
        body: Obx(
          () => controller.status.value == "Loading"
              ? Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                      child: new CircularProgressIndicator(
                    color: Colors.black,
                  )))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _controller,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 65),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 320.0,
                              child: Stack(
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                        height: 320.0,
                                        aspectRatio: 1.0,
                                        autoPlay: true,
                                        reverse: false,
                                        enableInfiniteScroll: false,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        scrollDirection: Axis.horizontal,
                                        viewportFraction: 1,
                                        onPageChanged: (index, reason) {
                                          controller.updateSlider(index);
                                        }),
                                    items:
                                        controller.product.value.img!.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              /* decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)), */
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            const CircularProgressIndicator(
                                                  color: Colors.black,
                                                )),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                imageUrl:
                                                    AppConstraints.PRODUCT_URL +
                                                        i,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                          // errorWidget: (context, url, error) => Icon(Icons.error),
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: controller.product.value.img!
                                          .map((url) {
                                        int index = controller
                                            .product.value.img!
                                            .indexOf(url);
                                        return controller
                                                    .product.value.img!.length <
                                                2
                                            ? SizedBox(
                                                width: 0,
                                                height: 0,
                                              )
                                            : Obx(() => Card(
                                                  elevation: 5,
                                                  shadowColor: Colors.black,
                                                  child: Container(
                                                    width: 8.0,
                                                    height: 8.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: controller
                                                                  .currentPos ==
                                                              index
                                                          ? Colors.grey
                                                          : Color.fromRGBO(
                                                              255, 255, 255, 1),
                                                    ),
                                                  ),
                                                ));
                                      }).toList(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40, left: 20, right: 20),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                if (signinController
                                                            .user.value.id
                                                            .toString() !=
                                                        "null" &&
                                                    signinController
                                                            .user.value.id
                                                            .toString() !=
                                                        "" &&
                                                    signinController
                                                            .user.value.id
                                                            .toString() !=
                                                        "0") {
                                                  bool isFavorite = controller
                                                      .product
                                                      .value
                                                      .isFavoirite
                                                      .value;
                                                  if (isFavorite) {
                                                    controller
                                                        .product
                                                        .value
                                                        .isFavoirite
                                                        .value = false;

                                                    wishlistController
                                                        .removeWishlist(
                                                            signinController
                                                                .user.value,
                                                            controller
                                                                .product.value);

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(controller
                                                                    .product
                                                                    .value
                                                                    .name! +
                                                                ' Removed from favorite list')));
                                                  } else {
                                                    controller
                                                        .product
                                                        .value
                                                        .isFavoirite
                                                        .value = true;
                                                    wishlistController
                                                        .addWishlist(
                                                            signinController
                                                                .user.value,
                                                            controller
                                                                .product.value);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(controller
                                                                    .product
                                                                    .value
                                                                    .name! +
                                                                ' Added to favorite list')));
                                                  }
                                                } else {
                                                  Get.toNamed(
                                                      MyPagesName.SignIn);
                                                }
                                              },
                                              child: Obx(() => Icon(
                                                    controller.product.value
                                                            .isFavoirite.value
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline,
                                                    color: Colors.red,
                                                    size: 30,
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.product.value.name.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "\₹" +
                                              controller.product.value.discounted_amount
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "  +  ${controller.product.value.gst
                                              .toString()} % GST"
                                              ,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        ),

                                        //   RatingBar.builder(
                                        //     initialRating: 3,
                                        //     minRating: 1,
                                        //     direction: Axis.horizontal,
                                        //     allowHalfRating: true,
                                        //     itemCount: 5,
                                        //     itemSize: 25,
                                        //     itemPadding: EdgeInsets.symmetric(
                                        //         horizontal: 4.0),
                                        //     itemBuilder: (context, _) => Icon(
                                        //       Icons.star,
                                        //       size: 15,
                                        //       color: Colors.amber,
                                        //     ),
                                        //     onRatingUpdate: (rating) {
                                        //       print(rating);
                                        //     },
                                        //   )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Text(
                                    //   "Colors",
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 17,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // SizedBox(
                                    //   height: 40,
                                    //   child: ListView.builder(
                                    //       scrollDirection: Axis.horizontal,
                                    //       itemCount: controller.colors.length,
                                    //       itemBuilder: (context, index) =>
                                    //           GestureDetector(
                                    //             onTap: () {
                                    //               controller.selectedColor.value =
                                    //                   controller.colors[index];
                                    //             },
                                    //             child: Obx(
                                    //               () => Container(
                                    //                 decoration: controller
                                    //                             .selectedColor
                                    //                             .value ==
                                    //                         controller
                                    //                             .colors[index]
                                    //                     ? BoxDecoration(
                                    //                         borderRadius:
                                    //                             BorderRadius.all(
                                    //                           Radius.circular(
                                    //                               100),
                                    //                         ),
                                    //                         border: Border.all(
                                    //                             width: 3,
                                    //                             color: Colors
                                    //                                 .blueAccent))
                                    //                     : BoxDecoration(
                                    //                         borderRadius:
                                    //                             BorderRadius.all(
                                    //                           Radius.circular(
                                    //                               100),
                                    //                         ),
                                    //                         border: Border.all(
                                    //                             width: 3,
                                    //                             color: Colors
                                    //                                 .transparent)),
                                    //                 child: Card(
                                    //                     color: CommonTool.fromHex(
                                    //                         controller
                                    //                             .colors[index]),
                                    //                     shape:
                                    //                         RoundedRectangleBorder(
                                    //                             borderRadius:
                                    //                                 BorderRadius
                                    //                                     .circular(
                                    //                                         17)),
                                    //                     child: Container(
                                    //                       height: 27,
                                    //                       width: 27,
                                    //                     )),
                                    //               ),
                                    //             ),
                                    //           )),
                                    // ),
                                    // const SizedBox(
                                    //   height: 5,
                                    // ),
                                    // const Divider(
                                    //   thickness: 1,
                                    // ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Description",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Html(
                                        style: {
                                          "body": Style(
                                            margin: Margins.zero,
                                            padding: HtmlPaddings.zero,
                                          )
                                        },
                                        data: controller
                                                    .product.value.description
                                                    .toString() ==
                                                "null"
                                            ? ""
                                            : controller
                                                .product.value.description
                                                .toString(),
                                        onLinkTap: (String? url,
                                            Map<String, String> attributes,
                                            var element) {
                                          CommonTool.launchURL(url);
                                        }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Categories",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade600),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            controller.category_name.value
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Tags",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade600),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            controller.product.value.tags
                                                        .toString() !=
                                                    "null"
                                                ? controller.product.value.tags
                                                    .toString()
                                                : "",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Html(
                                        data: controller
                                                    .product.value.other_info
                                                    .toString() !=
                                                "null"
                                            ? controller
                                                .product.value.other_info
                                                .toString()
                                            : "",
                                        onLinkTap: (String? url,
                                            Map<String, String> attributes,
                                            var element) {
                                          CommonTool.launchURL(url);
                                        }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // const Divider(
                                    //   thickness: 1,
                                    // ),
                                    // const SizedBox(height: 5),
                                    // Text("Reviews",
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.bold,
                                    //     )),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Expanded(
                                    //       flex: 1,
                                    //       child: Text(
                                    //         "366 Reviews",
                                    //         style: TextStyle(
                                    //             fontSize: 14,
                                    //             fontWeight: FontWeight.w500,
                                    //             color: Colors.grey.shade600),
                                    //       ),
                                    //     ),
                                    //     Text.rich(TextSpan(
                                    //         style: TextStyle(
                                    //             fontSize: 17,
                                    //             fontWeight: FontWeight.bold),
                                    //         text: "4.9",
                                    //         children: [
                                    //           TextSpan(
                                    //             text: " out of 5.0",
                                    //             style: TextStyle(
                                    //                 fontSize: 14,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: Colors.grey.shade600),
                                    //           )
                                    //         ]))
                                    //   ],
                                    // ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SelectableText("Similar Products",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            controller.productList.length,
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                          onTap: () {
                                            pid = controller
                                                .productList[index].id
                                                .toString();
                                            controller.loadProduct(pid);
                                            _controller.animateTo(0.0,
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                curve: Curves.ease);
                                          },
                                          child: ProductDesign(
                                                  context: context,
                                                  product: controller
                                                      .productList[index])
                                              .productSmallDesign,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 55,
                        color: Colors.white,
                        child: Row(
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Container(
                            //     width: 50,
                            //     height: 45,
                            //     margin: EdgeInsets.all(3),
                            //     decoration: BoxDecoration(
                            //         border: Border.all(color: Colors.black),
                            //         borderRadius: BorderRadius.circular(10)),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         Expanded(
                            //             child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             Obx(() => Text(
                            //                 "${controller.product.value.quant.value}")),
                            //           ],
                            //         )),
                            //         Expanded(
                            //           child: Column(
                            //             children: [
                            //               GestureDetector(
                            //                 onTap: () {
                            //                   controller.increment(
                            //                       controller.product.value);
                            //                 },
                            //                 child: CircleAvatar(
                            //                   radius: 10,
                            //                   backgroundColor: Colors.black,
                            //                   child: Icon(
                            //                     Icons.arrow_drop_up_sharp,
                            //                     size: 20,
                            //                   ),
                            //                 ),
                            //               ),
                            //               SizedBox(
                            //                 height: 2,
                            //               ),
                            //               GestureDetector(
                            //                 onTap: () {
                            //                   controller.decrement(
                            //                       controller.product.value);
                            //                 },
                            //                 child: CircleAvatar(
                            //                   radius: 10,
                            //                   backgroundColor: Colors.black,
                            //                   child: Icon(
                            //                     Icons.arrow_drop_down_sharp,
                            //                     size: 20,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              flex: 2,
                              child: cartController.status == "Loading"
                                  ? Center(
                                      child: new CircularProgressIndicator(
                                      color: Colors.black,
                                    ))
                                  : GestureDetector(
                                      onTap: () {
                                        if (signinController.id.value.trim() !=
                                                "null" &&
                                            signinController.id.value.trim() !=
                                                "") {
                                          CartItem cartItem = new CartItem();
                                          cartItem.product =
                                              controller.product.value;
                                          cartItem.color =
                                              controller.selectedColor.value;

                                          cartItem.tax =  double.parse(controller.product.value.tax.toString());
                                          cartItem.quantity.value = controller
                                              .product.value.quant.value;

                                          cartController.saveToCart(
                                              cartItem,
                                              signinController.id.value,
                                              context);

                                          cartController.addToCart(cartItem);
                                        } else {
                                          cartController.comeBack.value = true;
                                          Get.toNamed(MyPagesName.SignIn);
                                        }
                                      },
                                      child:
                                          AppButton(buttonTitle: "Add To Cart")
                                              .myButton,
                                    ),
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: GestureDetector(
                            //       onTap: () {
                            //         if (signinController.id.value.trim() !=
                            //                 "null" &&
                            //             signinController.id.value.trim() !=
                            //                 "") {
                            //           if (addressController
                            //               .addresses.value.isEmpty) {
                            //             Get.snackbar(
                            //                 "Alert", "Please Add an address",
                            //                 icon: Icon(Icons.person,
                            //                     color: Colors.white),
                            //                 snackPosition: SnackPosition.BOTTOM,
                            //                 colorText: Colors.white,
                            //                 animationDuration:
                            //                     Duration(microseconds: 100),
                            //                 backgroundColor: Colors.black);
                            //           } else {
                            //             // checkoutController.selectedId.value = 1;

                            //             donationProduct();
                            //           }
                            //         } else {
                            //           Get.toNamed(MyPagesName.SignIn);
                            //         }
                            //       },
                            //       child: isLoading
                            //           ? Center(
                            //               child: new CircularProgressIndicator(
                            //               color: Colors.black,
                            //             ))
                            //           : AppButton(buttonTitle: "Donate ")
                            //               .myButton),
                            // ),
                            cartController.cartItems.length > 0
                                ? Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if(controller.type.value == "school"){
                                          Get.back(); Get.back();
                                          dashboardController.goToTab(3);
                                          Get.back();
                                        }else{
                                          dashboardController.goToTab(3);
                                          Get.back();
                                        }


                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.black,
                                        child: Icon(
                                          FontAwesomeIcons.cartArrowDown,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}