import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:Susani/views/pages/WebView/MyWebView.dart';
import 'package:Susani/views/pages/ecom/screens/EcomCart.dart';
import 'package:Susani/views/pages/ecom/utils/color_data.dart';
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
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../contollers/product_controller/product_categories_controller.dart';
import '../../../models/size_model.dart';

class ProductFullViewPage extends StatefulWidget {
  @override
  State<ProductFullViewPage> createState() => _ProductFullViewPageState();
}

class _ProductFullViewPageState extends State<ProductFullViewPage> {
  // Product? product;
  var pid;
  final _controller = ScrollController();
  var wishlistController = Get.put(WishlistController());
  var signinController = Get.put(SignInController());
  var controller = Get.put(ProductController());
  var cartController = Get.put(CartController());
  var dashboardController = Get.put(DashboardController());
  var checkoutController = Get.find<CheckoutController>();
  var addressController = Get.find<AddressController>();
  var isLoading = false;
  MyAppConfigController appConfigController = Get.put(MyAppConfigController());

  var productCategoriescontroller = Get.put(ProductCategoriesController());

  @override
  void initState() {
    super.initState();

    addressController.loadAddress(signinController.user.value);
    pid = Get.arguments.toString();
    controller.loadProduct(Get.arguments.toString());

    print(controller.status.value);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
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
    CartItem cartItem =
        cartController.isProductInCart(controller.product.value);

    if (cartItem.product != null) {
      controller.product.value.isInCart.value = true;
      controller.product.value.quant.value = cartController.productidQty.value;

      print(controller.product.value.quant.value.toString() +
          "= cart= " +
          cartController.productidQty.value.toString());
      print("cartItem.quantity.value -> " + cartItem.quantity.value.toString());
    } else {}
    print(controller.product.value.isInCart.value.toString() +
        " ====== " +
        controller.product.value.id.toString());

    return SafeArea(
      // bottom: true,
      // top: false,
      // left: true,
      // right: true,
      child: Scaffold(
        body: Obx(
          () {
            return controller.status.value == "Loading"
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
                            children: [
                              Container(
                                child: Stack(
                                  children: [
                                    CarouselSlider(
                                      options: CarouselOptions(
                                        aspectRatio: 3 / 4,
                                        autoPlay: true,
                                        reverse: false,
                                        enableInfiniteScroll: false,
                                        autoPlayInterval:
                                            const Duration(seconds: 4),
                                        scrollDirection: Axis.horizontal,
                                        viewportFraction: 1,
                                        onPageChanged: (index, reason) {
                                          controller.updateSlider(index);
                                        },
                                      ),
                                      items: controller.product.value.img!
                                          .map((i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(ImagePreviewPage(
                                                  imageUrls: controller
                                                      .product.value.img!,
                                                  initialIndex: controller
                                                      .currentPos.value,
                                                ));
                                              },
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      const CircularProgressIndicator(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  color: Colors.grey[300],
                                                  child: Image.asset(
                                                    "assets/images/noImg.png",
                                                  ),
                                                ),
                                                imageUrl:
                                                    AppConstraints.PRODUCT_URL +
                                                        i,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
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
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                          return controller.product.value.img!
                                                      .length <
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
                                                                255,
                                                                255,
                                                                255,
                                                                1),
                                                      ),
                                                    ),
                                                  ));
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   height: 500.0,
                              //   child:
                              //   Stack(
                              //     children: [
                              //       CarouselSlider(
                              //         options: CarouselOptions(
                              //
                              //             aspectRatio: 1.0,
                              //             autoPlay: true,
                              //             reverse: false,
                              //             enableInfiniteScroll: false,
                              //             autoPlayInterval:
                              //             const Duration(seconds: 3),
                              //             scrollDirection: Axis.horizontal,
                              //             viewportFraction: 1,
                              //             onPageChanged: (index, reason) {
                              //               controller.updateSlider(index);
                              //             }),
                              //         items:
                              //         controller.product.value.img!.map((i) {
                              //           return Builder(
                              //             builder: (BuildContext context) {
                              //               return GestureDetector(
                              //                 onTap: () {},
                              //                 child: Container(
                              //                   width: MediaQuery
                              //                       .of(context)
                              //                       .size
                              //                       .width,
                              //                   /* decoration: BoxDecoration(
                              //                       borderRadius: BorderRadius.circular(10)), */
                              //                   child: CachedNetworkImage(
                              //                     placeholder: (context, url) =>
                              //                         Center(
                              //                             child:
                              //                             const CircularProgressIndicator(
                              //                               color: Colors.black,
                              //                             )),
                              //                     errorWidget: (context, url, error) => Container(
                              //                         width: double.infinity,
                              //                         height: double.infinity,
                              //                         color: Colors.grey[300],
                              //                         child:  Image.asset("assets/images/noImg.png",)
                              //                     ),
                              //                     imageUrl:
                              //                     AppConstraints.PRODUCT_URL +
                              //                         i,
                              //                     fit: BoxFit.contain,
                              //                   ),
                              //                 ),
                              //               );
                              //               // errorWidget: (context, url, error) => Icon(Icons.error),
                              //             },
                              //           );
                              //         }).toList(),
                              //       ),
                              //       Align(
                              //         alignment: Alignment.bottomCenter,
                              //         child: Row(
                              //           mainAxisAlignment:
                              //           MainAxisAlignment.center,
                              //           children: controller.product.value.img!
                              //               .map((url) {
                              //             int index = controller
                              //                 .product.value.img!
                              //                 .indexOf(url);
                              //             return controller
                              //                 .product.value.img!.length <
                              //                 2
                              //                 ? SizedBox(
                              //               width: 0,
                              //               height: 0,
                              //             )
                              //                 : Obx(() =>
                              //                 Card(
                              //                   elevation: 5,
                              //                   shadowColor: Colors.black,
                              //                   child: Container(
                              //                     width: 8.0,
                              //                     height: 8.0,
                              //                     decoration: BoxDecoration(
                              //                       shape: BoxShape.circle,
                              //                        color: controller
                              //                           .currentPos ==
                              //                           index
                              //                           ? Colors.grey
                              //                           : Color.fromRGBO(
                              //                           255, 255, 255, 1),
                              //                     ),
                              //                   ),
                              //                 ));
                              //           }).toList(),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.only(
                              //             top: 40, left: 20, right: 20),
                              //         child: Align(
                              //           alignment: Alignment.topCenter,
                              //           child: Row(
                              //             mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               GestureDetector(
                              //                 onTap: () {
                              //                   Get.back();
                              //                 },
                              //                 child: Icon(
                              //                   Icons.arrow_back_ios,
                              //                   size: 20,
                              //                   color: Colors.black,
                              //                 ),
                              //               ),
                              //               GestureDetector(
                              //                   onTap: () {
                              //                     if (signinController
                              //                         .user.value.id
                              //                         .toString() !=
                              //                         "null" &&
                              //                         signinController
                              //                             .user.value.id
                              //                             .toString() !=
                              //                             "" &&
                              //                         signinController
                              //                             .user.value.id
                              //                             .toString() !=
                              //                             "0") {
                              //                       bool isFavorite = controller
                              //                           .product
                              //                           .value
                              //                           .isFavoirite
                              //                           .value;
                              //                       if (isFavorite) {
                              //                         controller
                              //                             .product
                              //                             .value
                              //                             .isFavoirite
                              //                             .value = false;
                              //
                              //                         wishlistController
                              //                             .removeWishlist(
                              //                             signinController
                              //                                 .user.value,
                              //                             controller
                              //                                 .product.value);
                              //
                              //                         ScaffoldMessenger.of(
                              //                             context)
                              //                             .showSnackBar(SnackBar(
                              //                             content: Text(controller
                              //                                 .product
                              //                                 .value
                              //                                 .name! +
                              //                                 ' Removed from favorite list')));
                              //                       } else {
                              //                         controller
                              //                             .product
                              //                             .value
                              //                             .isFavoirite
                              //                             .value = true;
                              //                         wishlistController
                              //                             .addWishlist(
                              //                             signinController
                              //                                 .user.value,
                              //                             controller
                              //                                 .product.value);
                              //                         ScaffoldMessenger.of(
                              //                             context)
                              //                             .showSnackBar(SnackBar(
                              //                             content: Text(controller
                              //                                 .product
                              //                                 .value
                              //                                 .name! +
                              //                                 ' Added to favorite list')));
                              //                       }
                              //                     } else {
                              //                       Get.toNamed(
                              //                           MyPagesName.SignIn);
                              //                     }
                              //                   },
                              //                   child: Obx(() =>
                              //                       Icon(
                              //                         controller.product.value
                              //                             .isFavoirite.value
                              //                             ? Icons.favorite
                              //                             : Icons
                              //                             .favorite_outline,
                              //                         color: Colors.red,
                              //                         size: 30,
                              //                       ))),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.product.value.name
                                            .toString(),
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
                                                controller.product.value
                                                    .discounted_amount
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "  +  ${controller.product.value.gst.toString()} % GST",
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
                                      controller.type.value == "school"
                                          ? Text(
                                              "Available Size",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container(),
                                      controller.type.value == "school"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 8.0),
                                              child: Obx(() => Wrap(
                                                    spacing: 8.0,
                                                    children: controller.options
                                                        .map((sizeModel) {
                                                      // Determine if this chip is selected
                                                      bool isSelected =
                                                          controller.getSize ==
                                                              sizeModel.value;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          controller.setSize(
                                                              sizeModel.value);
                                                          cartController
                                                              .updateCart();
                                                          controller
                                                                  .product
                                                                  .value
                                                                  .quant
                                                                  .value =
                                                              cartController
                                                                  .productidQty
                                                                  .value;
                                                          cartController
                                                              .isProductInCartCheckSize(
                                                                  pid,
                                                                  controller
                                                                      .selectedSize
                                                                      .value
                                                                      .toString());
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: isSelected
                                                                ? AppColor
                                                                    .bottomitemColor2
                                                                : Colors.white,
                                                            // Selected color or white
                                                            border: Border.all(
                                                                color: isSelected
                                                                    ? Colors
                                                                        .transparent
                                                                    : AppColor
                                                                        .bottomitemColor2),
                                                            // Blue border when unselected
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                          child: Text(
                                                            sizeModel.value,
                                                            style: TextStyle(
                                                              color: isSelected
                                                                  ? Colors.white
                                                                  : AppColor
                                                                      .bottomitemColor2, // Text color based on selection
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  )),
                                            )
                                          : Container(),

                                      SizedBox(
                                        height: 5,
                                      ),
                                      const SizedBox(height: 10),

                                      // Obx(() {
                                      //   return cartController.productidSelected.value
                                      //       ?
                                      //   cartController.productidSizeSelected.value?
                                      //   Row(
                                      //     children: [
                                      //       Expanded(
                                      //         child: Container(
                                      //           margin: EdgeInsets.all(5),
                                      //           padding: EdgeInsets.all(1),
                                      //           decoration: BoxDecoration(
                                      //               color: AppColor.bottomitemColor1,
                                      //               borderRadius: BorderRadius
                                      //                   .circular(
                                      //                   10)),
                                      //           child: Row(
                                      //             mainAxisAlignment:
                                      //             MainAxisAlignment.spaceAround,
                                      //             children: [
                                      //               CircleAvatar(
                                      //                 backgroundColor: Colors.white,
                                      //                 radius: 10,
                                      //                 child: IconButton(
                                      //                     highlightColor: Colors
                                      //                         .black26,
                                      //                     padding: EdgeInsets.all(0),
                                      //                     onPressed: () {
                                      //                       CartItem cartItem = new CartItem();
                                      //                       cartItem.product =controller.product.value;
                                      //                       cartController
                                      //                           .addQuantityToCartTable(
                                      //                           cartItem, 1, "plus");
                                      //                       controller.product.value
                                      //                           .quant.value += 1;
                                      //                       // cartController.getCartItems(signinController.id.value.toString());
                                      //
                                      //                     },
                                      //                     icon: Icon(
                                      //                       FontAwesomeIcons.plus,
                                      //                       size: 15,
                                      //                       color: Colors.black,
                                      //                     )),
                                      //               ),
                                      //               Obx(
                                      //                     () =>
                                      //                     Container(
                                      //                       margin: EdgeInsets.all(2),
                                      //                       child: Text(
                                      //                         controller.product.value
                                      //                             .quant.value
                                      //                             .toString(),
                                      //                         style: TextStyle(
                                      //                             fontSize: 20,
                                      //                             color: Colors
                                      //                                 .white),
                                      //                       ),
                                      //                     ),
                                      //               ),
                                      //               CircleAvatar(
                                      //                 backgroundColor: Colors.white,
                                      //                 radius: 10,
                                      //                 child: IconButton(
                                      //                     highlightColor: Colors
                                      //                         .black26,
                                      //                     padding: EdgeInsets.all(0),
                                      //                     onPressed: () {
                                      //                       if (controller.product
                                      //                           .value
                                      //                           .quant.value > 1) {
                                      //                         CartItem cartItem = new CartItem();
                                      //                         cartItem.product =
                                      //                             controller.product
                                      //                                 .value;
                                      //                         cartController
                                      //                             .addQuantityToCartTable(
                                      //                             cartItem, 1,
                                      //                             "minus");
                                      //                         controller.product.value
                                      //                             .quant.value -= 1;
                                      //                         // cartController.getCartItems(signinController.id.value.toString());
                                      //                       }
                                      //                     },
                                      //                     icon: Icon(
                                      //                       FontAwesomeIcons.minus,
                                      //                       size: 15,
                                      //                       color: Colors.black,
                                      //                     )),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       Expanded(
                                      //         child: GestureDetector(
                                      //           onTap: () {
                                      //             CartController cartController = Get
                                      //                 .put(CartController());
                                      //             SignInController signInController = Get
                                      //                 .put(SignInController());
                                      //             cartController.clickedIndex.value =
                                      //                 int.parse(
                                      //                     controller.product.value.id
                                      //                         .toString());
                                      //             cartController.getCartItems(
                                      //                 signInController.user.value.id
                                      //                     .toString());
                                      //           },
                                      //           child: Container(
                                      //             padding: EdgeInsets.all(5),
                                      //             alignment: Alignment.center,
                                      //             child: Card(
                                      //               shape: RoundedRectangleBorder(
                                      //                   borderRadius: BorderRadius
                                      //                       .circular(10)),
                                      //               child: Container(
                                      //                 alignment: Alignment.center,
                                      //                 decoration: BoxDecoration(
                                      //                     color: AppColor
                                      //                         .bottomitemColor1,
                                      //                     borderRadius: BorderRadius
                                      //                         .circular(5)),
                                      //                 width: Get.size.width,
                                      //                 padding: EdgeInsets.all(5),
                                      //                 child: cartController.status ==
                                      //                     "Loading" &&
                                      //                     cartController.clickedIndex
                                      //                         .value ==
                                      //                         int.parse(
                                      //                             controller.product
                                      //                                 .value
                                      //                                 .id.toString())
                                      //                     ? LinearProgressIndicator(
                                      //                   color: AppColor
                                      //                       .backgroundColor,
                                      //                   valueColor: AlwaysStoppedAnimation<
                                      //                       Color>(
                                      //                       AppColor
                                      //                           .bottomitemColor1),
                                      //                 )
                                      //                     : Text("Add Variant",
                                      //                     style: TextStyle(
                                      //                         color: Colors.white,
                                      //                         fontWeight: FontWeight
                                      //                             .bold,
                                      //                         fontSize: 14)),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ): GestureDetector(
                                      //     onTap: () {
                                      //       var productCategoriescontroller = Get.put(
                                      //           ProductCategoriesController());
                                      //
                                      //       if (signinController.id.value.trim() !=
                                      //           "null" &&
                                      //           signinController.id.value.trim() !=
                                      //               "") {
                                      //         print("ontroller.selectedColor.value");
                                      //         print(controller.type.value);
                                      //         CartItem cartItem = new CartItem();
                                      //         cartItem.product =
                                      //             controller.product.value;
                                      //         cartItem.color =
                                      //             controller.selectedColor.value;
                                      //         cartItem.quantity.value =
                                      //             controller.product.value.quant
                                      //                 .value;
                                      //         print(controller.selectedSize.value);
                                      //         cartItem.size =
                                      //             controller.product.value.size
                                      //                 .toString();
                                      //         if (controller.selectedSize.value !=
                                      //             null) {
                                      //           cartItem.size =
                                      //               controller.selectedSize.value
                                      //                   .toString();
                                      //         }
                                      //         // else{
                                      //         //   cartItem.size = controller.options[0].toString();
                                      //         // }
                                      //
                                      //         cartItem.tax = double.parse(
                                      //             controller.product.value.tax
                                      //                 .toString());
                                      //         cartItem.type =
                                      //             productCategoriescontroller.type
                                      //                 .value;
                                      //         cartItem.clear_cart = false;
                                      //
                                      //         cartController.saveToCart(cartItem,
                                      //             signinController.id.value);
                                      //         cartController.addToCart(cartItem);
                                      //         controller.product.value.isInCart
                                      //             .value = true;
                                      //       } else {
                                      //         cartController.comeBack.value = true;
                                      //         Get.toNamed(MyPagesName.SignIn);
                                      //       }
                                      //     },
                                      //     child: Container(
                                      //       padding: EdgeInsets.all(5),
                                      //       width: Get.width,
                                      //       alignment: Alignment.center,
                                      //       child: Card(
                                      //         shape: RoundedRectangleBorder(
                                      //             borderRadius: BorderRadius.circular(
                                      //                 10)),
                                      //         child: Container(
                                      //           alignment: Alignment.center,
                                      //           decoration: BoxDecoration(
                                      //               color: AppColor.bottomitemColor1,
                                      //               borderRadius: BorderRadius
                                      //                   .circular(
                                      //                   5)),
                                      //           width: Get.size.width,
                                      //           padding: EdgeInsets.all(5),
                                      //           child: Text("Add To Cart",
                                      //               style: TextStyle(
                                      //                   color: Colors.white,
                                      //                   fontWeight: FontWeight.bold,
                                      //                   fontSize: 14)),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   )
                                      //       : GestureDetector(
                                      //     onTap: () {
                                      //       var productCategoriescontroller = Get.put(
                                      //           ProductCategoriesController());
                                      //
                                      //       if (signinController.id.value.trim() !=
                                      //           "null" &&
                                      //           signinController.id.value.trim() !=
                                      //               "") {
                                      //         print("ontroller.selectedColor.value");
                                      //         print(controller.type.value);
                                      //         CartItem cartItem = new CartItem();
                                      //         cartItem.product =
                                      //             controller.product.value;
                                      //         cartItem.color =
                                      //             controller.selectedColor.value;
                                      //         cartItem.quantity.value =
                                      //             controller.product.value.quant
                                      //                 .value;
                                      //         print(controller.selectedSize.value);
                                      //         cartItem.size =
                                      //             controller.product.value.size
                                      //                 .toString();
                                      //         if (controller.selectedSize.value !=
                                      //             null) {
                                      //           cartItem.size =
                                      //               controller.selectedSize.value
                                      //                   .toString();
                                      //         }
                                      //         // else{
                                      //         //   cartItem.size = controller.options[0].toString();
                                      //         // }
                                      //
                                      //         cartItem.tax = double.parse(
                                      //             controller.product.value.tax
                                      //                 .toString());
                                      //         cartItem.type =
                                      //             productCategoriescontroller.type
                                      //                 .value;
                                      //         cartItem.clear_cart = false;
                                      //
                                      //         cartController.saveToCart(cartItem,
                                      //             signinController.id.value);
                                      //         cartController.addToCart(cartItem);
                                      //         controller.product.value.isInCart
                                      //             .value = true;
                                      //       } else {
                                      //         cartController.comeBack.value = true;
                                      //         Get.toNamed(MyPagesName.SignIn);
                                      //       }
                                      //     },
                                      //     child: Container(
                                      //       padding: EdgeInsets.all(5),
                                      //       width: Get.width,
                                      //       alignment: Alignment.center,
                                      //       child: Card(
                                      //         shape: RoundedRectangleBorder(
                                      //             borderRadius: BorderRadius.circular(
                                      //                 10)),
                                      //         child: Container(
                                      //           alignment: Alignment.center,
                                      //           decoration: BoxDecoration(
                                      //               color: AppColor.bottomitemColor1,
                                      //               borderRadius: BorderRadius
                                      //                   .circular(
                                      //                   5)),
                                      //           width: Get.size.width,
                                      //           padding: EdgeInsets.all(5),
                                      //           child: Text("Buy Now",
                                      //               style: TextStyle(
                                      //                   color: Colors.white,
                                      //                   fontWeight: FontWeight.bold,
                                      //                   fontSize: 14)),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   );
                                      // },),

                                      Divider(
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
                                      cartController.isProductInCartCheckSize(
                                                  pid,
                                                  controller.selectedSize.value
                                                      .toString()) ==
                                              true
                                          ? Container()
                                          : Container(),

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
                                              "Size",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade600),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              controller.selectedSize.value
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
                              Expanded(
                                flex: 2,
                                child: Obx(
                                  () {
                                    if (cartController.addQuantStatus.value ==
                                        "Loading")
                                      return LinearProgressIndicator(
                                        color: AppColor.backgroundColor,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColor.bottomitemColor1),
                                      );

                                    return cartController
                                                .productidSelected.value &&
                                            cartController
                                                .productidSizeSelected.value
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(5),
                                                  padding: EdgeInsets.all(1),
                                                  decoration: BoxDecoration(
                                                      color: AppColor
                                                          .bottomitemColor1,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 10,
                                                        child: IconButton(
                                                            highlightColor:
                                                                Colors.black26,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed: () {
                                                              CartItem
                                                                  cartItem =
                                                                  new CartItem();
                                                              controller
                                                                      .product
                                                                      .value
                                                                      .size =
                                                                  controller
                                                                      .selectedSize
                                                                      .value;
                                                              if (productCategoriescontroller
                                                                      .type
                                                                      .value ==
                                                                  "laundry") {
                                                                cartItem.id = cartController
                                                                    .isProductInLaundryCart(
                                                                        controller
                                                                            .product
                                                                            .value)
                                                                    .id;
                                                              } else {
                                                                cartItem.id = cartController
                                                                    .isProductInCart(
                                                                        controller
                                                                            .product
                                                                            .value)
                                                                    .id;
                                                              }

                                                              print("cartItem.id plus" +
                                                                  cartItem.id
                                                                      .toString());

                                                              cartItem.product =
                                                                  controller
                                                                      .product
                                                                      .value;
                                                              cartController
                                                                  .addQuantityToCartTable(
                                                                      cartItem,
                                                                      1,
                                                                      "plus");
                                                              controller
                                                                  .product
                                                                  .value
                                                                  .quant
                                                                  .value += 1;
                                                              cartController
                                                                  .updateCart();
                                                              cartController.isProductInCartGetSize(
                                                                  controller
                                                                      .product
                                                                      .value
                                                                      .id
                                                                      .toString(),
                                                                  productCategoriescontroller
                                                                      .type
                                                                      .value);
                                                              // cartController.getCartItems(signinController.id.value.toString());
                                                            },
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .plus,
                                                              size: 15,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ),
                                                      Obx(
                                                        () => Container(
                                                          margin:
                                                              EdgeInsets.all(2),
                                                          child: Text(
                                                            cartController
                                                                .productidQty
                                                                .value
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 10,
                                                        child: IconButton(
                                                            highlightColor:
                                                                Colors.black26,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed: () {
                                                              if (controller
                                                                      .product
                                                                      .value
                                                                      .quant
                                                                      .value >
                                                                  1) {
                                                                CartItem
                                                                    cartItem =
                                                                    new CartItem();
                                                                print("controller.product.value" +
                                                                    controller
                                                                        .product
                                                                        .value
                                                                        .id
                                                                        .toString());
                                                                print("controller.product.value" +
                                                                    controller
                                                                        .selectedSize
                                                                        .value
                                                                        .toString());
                                                                controller
                                                                        .product
                                                                        .value
                                                                        .size =
                                                                    controller
                                                                        .selectedSize
                                                                        .value;
                                                                cartItem.id = cartController
                                                                    .isProductInCart(
                                                                        controller
                                                                            .product
                                                                            .value)
                                                                    .id;
                                                                print("cartItem.id plus" +
                                                                    cartItem.id
                                                                        .toString());
                                                                cartItem.product =
                                                                    controller
                                                                        .product
                                                                        .value;

                                                                cartController
                                                                    .addQuantityToCartTable(
                                                                        cartItem,
                                                                        1,
                                                                        "minus");
                                                                controller
                                                                    .product
                                                                    .value
                                                                    .quant
                                                                    .value -= 1;
                                                                cartController
                                                                    .updateCart();
                                                                // cartController.getCartItems(signinController.id.value.toString());
                                                              }
                                                            },
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .minus,
                                                              size: 15,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              var productCategoriescontroller =
                                                  Get.put(
                                                      ProductCategoriesController());

                                              if (signinController.id.value
                                                          .trim() !=
                                                      "null" &&
                                                  signinController.id.value
                                                          .trim() !=
                                                      "") {
                                                print(
                                                    "ontroller.selectedColor.value");
                                                print(controller.type.value);
                                                CartItem cartItem =
                                                    new CartItem();
                                                cartItem.product =
                                                    controller.product.value;
                                                cartItem.color = controller
                                                    .selectedColor.value;
                                                cartItem.quantity.value =
                                                    controller.product.value
                                                        .quant.value;
                                                print(controller
                                                    .selectedSize.value);
                                                cartItem.size = controller
                                                    .product.value.size
                                                    .toString();
                                                if (controller
                                                        .selectedSize.value !=
                                                    null) {
                                                  cartItem.size = controller
                                                      .selectedSize.value
                                                      .toString();
                                                }
                                                // else{
                                                //   cartItem.size = controller.options[0].toString();
                                                // }

                                                cartItem.tax = double.parse(
                                                    controller.product.value.tax
                                                        .toString());
                                                cartItem.type =
                                                    productCategoriescontroller
                                                        .type.value;

                                                if (cartController
                                                    .cartItems.isEmpty) {
                                                  cartController.saveToCart(
                                                      cartItem,
                                                      signinController
                                                          .id.value);
                                                  cartController
                                                      .addToCart(cartItem);
                                                  controller.product.value
                                                      .isInCart.value = true;
                                                  cartController.updateCart();
                                                } else if (cartController
                                                        .cartItems.first.type !=
                                                    productCategoriescontroller
                                                        .type.value) {
                                                  Get.defaultDialog(
                                                      title: "CONFIRMATION",
                                                      titleStyle: TextStyle(
                                                          fontSize: 16),
                                                      middleText:
                                                          "Your cart contains another type of product. Are you want to clear old cart?",
                                                      middleTextStyle:
                                                          TextStyle(
                                                              fontSize: 12),
                                                      cancel: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white),
                                                          onPressed: () {
                                                            // dashboardController.goToTab(3);
                                                            controller
                                                                .product
                                                                .value
                                                                .isInCart
                                                                .value = false;
                                                            cartController
                                                                .updateCart();
                                                            Get.back();
                                                          },
                                                          child: Text("Cancel",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ))),
                                                      confirm: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          3,
                                                                          33,
                                                                          49),
                                                              elevation: 5),
                                                          onPressed: () {
                                                            cartController
                                                                .daleteAllItem();
                                                            cartItem.clear_cart =
                                                                true;
                                                            cartController
                                                                .saveToCart(
                                                                    cartItem,
                                                                    signinController
                                                                        .id
                                                                        .value);
                                                            cartController
                                                                .addToCart(
                                                                    cartItem);
                                                            cartController
                                                                .updateCart();
                                                            controller
                                                                .product
                                                                .value
                                                                .isInCart
                                                                .value = true;
                                                            Get.back();
                                                            // dashboardController.goToTab(3);
                                                          },
                                                          child: Text("Clear",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ))),
                                                      contentPadding:
                                                          EdgeInsets.all(20));
                                                } else {
                                                  cartController.saveToCart(
                                                      cartItem,
                                                      signinController
                                                          .id.value);
                                                  cartController
                                                      .addToCart(cartItem);
                                                  cartController.updateCart();
                                                  controller.product.value
                                                      .isInCart.value = true;
                                                }
                                              } else {
                                                cartController.comeBack.value =
                                                    true;
                                                Get.toNamed(MyPagesName.SignIn);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              width: Get.width,
                                              alignment: Alignment.center,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: AppColor
                                                          .bottomitemColor1,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  width: Get.size.width,
                                                  padding: EdgeInsets.all(5),
                                                  child: Text("Add To Cart",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14)),
                                                ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),
                              cartController.cartItems.length > 0
                                  ? Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (controller.type.value ==
                                              "school") {
                                            Get.to(Ecomcart());
                                          } else {
                                            dashboardController.goToTab(3);
                                            Get.back();
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.black,
                                          child: Obx(
                                            () => Badge(
                                              label: Text(
                                                cartController.totalQuantity
                                                    .toString(),
                                                style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor),
                                              ),
                                              child: Icon(
                                                FontAwesomeIcons.cartArrowDown,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          // Icon(
                                          //   FontAwesomeIcons.cartArrowDown,
                                          //   color: Colors.white,
                                          // ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${controller.product.value.name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "\₹" +
                        controller.product.value.discounted_amount.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "  +  ${controller.product.value.gst.toString()} % GST",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Obx(() {
                    return Text(
                      'Selected Size: '
                      '${controller.selectedSize.value == null ? "Please Select Size" : controller.selectedSize.value.toString()}',
                      style: TextStyle(fontSize: 18),
                    );
                  }),
                  SizedBox(
                    width: 20,
                  ),
                  controller.options.isEmpty
                      ? CircularProgressIndicator()
                      : DropdownButton<String>(
                          hint: Text("Select Size"),
                          // value: controller.selectedSize
                          //     .value, // Bind the dropdown to the selectedSize
                          onChanged: (String? newValue) {
                            // Update the selected value when a new item is selected
                            controller.selectedSize.value = newValue!;
                          },
                          items: controller.options
                              .asMap()
                              .entries
                              .map<DropdownMenuItem<String>>((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.value.toString(),
                              child:
                                  Text(entry.value.toString()), // Custom label
                            );
                          }).toList(),
                        ),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (controller.selectedSize.value == null) {
                    Get.snackbar("Alert", "Please Select Size",
                        icon: Icon(Icons.person, color: Colors.white),
                        snackPosition: SnackPosition.TOP,
                        margin: EdgeInsets.all(20),
                        colorText: Colors.white,
                        animationDuration: Duration(microseconds: 100),
                        backgroundColor: Colors.red);
                  } else {
                    if (signinController.id.value.trim() != "null" &&
                        signinController.id.value.trim() != "") {
                      CartItem cartItem = new CartItem();
                      cartItem.product = controller.product.value;

                      print(controller.selectedSize.value);
                      if (controller.selectedSize.value != null) {
                        cartItem.size =
                            controller.selectedSize.value.toString();
                      }
                      print(controller.selectedSize.value);
                      print(controller.product.value.size);
                      cartItem.color = controller.selectedColor.value;
                      cartItem.tax =
                          double.parse(controller.product.value.tax.toString());
                      cartItem.quantity.value =
                          controller.product.value.quant.value;

                      cartController.saveToCart(
                          cartItem, signinController.id.value, context);

                      cartController.addToCart(cartItem);
                      Navigator.pop(context);
                    } else {
                      cartController.comeBack.value = true;
                      Get.toNamed(MyPagesName.SignIn);
                    }
                  }
                },
                child: AppButton(buttonTitle: "Add To Cart").myButton,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final List<dynamic> imageUrls;
  final int initialIndex;

  ImagePreviewPage({required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                NetworkImage(AppConstraints.PRODUCT_URL + imageUrls[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
