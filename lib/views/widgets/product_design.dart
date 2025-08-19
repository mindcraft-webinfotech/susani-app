import 'package:Susani/consts/app_color.dart';
import 'package:Susani/views/pages/ecom/utils/widget_utils.dart';
import 'package:Susani/views/widgets/app_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/contollers/wishlist/WishlistController.dart';
import 'package:Susani/models/product.dart';
import 'package:shimmer/shimmer.dart';

import '../../contollers/cart_controller/cart_controller.dart';
import '../../contollers/product_controller/product_categories_controller.dart';
import '../../models/CartItem.dart';
import '../../utils/routes_pages/pages_name.dart';

class ProductDesign {
  BuildContext context;
  Product product;
  var controller = Get.put(ProductController());
  var wishlistController = Get.put(WishlistController());
  var signinController = Get.put(SignInController());
  var cartController = Get.put(CartController());

  ProductDesign({required this.context, required this.product}) {
    print("ProductDesign Called");

    CartItem cartItem = cartController.isProductInLaundryCart(product);
    if (cartItem.id == null) {
    } else {
      product.isInCart.value = true;
      product.quant.value = cartItem.quantity.value;
      print(cartItem.id.toString() + " ======= " + product.id.toString());
    }
  }

  Widget get productDesign => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
          // color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: AppConstraints.PRODUCT_URL + product.img![0].toString(),
              fit: BoxFit.contain,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                ),
              ),
              errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.grey[300],
                  child: Image.asset("assets/images/noImg.png")),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: Center(
                child: Text(
                  "${product.name}",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: product.discount != 0
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                Text(
                  "\₹" +
                      (double.parse(product.mrp.toString()) - product.discount!)
                          .toString(),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                product.discount == 0
                    ? Container()
                    : Text(
                        "\₹" +
                            (double.parse(product.mrp.toString())).toString(),
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 3),
            // Obx(() {
            //   return Text(product.isInCart.value.toString()
            //       + " " +product.id.toString()
            //       + " " +product.quant.toString());
            // }),
            controller.type.value == "laundry"
                ? Obx(
                    () {
                      // if (cartController.status == "Loading")
                      //   return LinearProgressIndicator(
                      //     color: AppColor
                      //         .backgroundColor,
                      //     valueColor: AlwaysStoppedAnimation<
                      //         Color>(
                      //         AppColor
                      //             .bottomitemColor1),
                      //   );

                      return product.isInCart.value
                          ? Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: AppColor.bottomitemColor1,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 10,
                                            child: IconButton(
                                                highlightColor: Colors.black26,
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  CartItem cartItem =
                                                      new CartItem();
                                                  cartItem.id = cartController
                                                      .isProductInLaundryCart(
                                                          product)
                                                      .id;
                                                  cartItem.product = product;
                                                  if (cartItem.id != null) {
                                                    if (product.quant.value >
                                                        0) {
                                                      cartController
                                                          .addQuantityToCartTable(
                                                              cartItem,
                                                              1,
                                                              "plus");
                                                      product.quant.value += 1;
                                                    }
                                                  } else {
                                                    cartController.updateCart();
                                                    // Get.snackbar("Error", "cartItem.id is null",backgroundColor: Colors.red, colorText: Colors.white);
                                                  }
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.plus,
                                                  size: 15,
                                                  color: Colors.black,
                                                )),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Text(
                                              product.quant.value.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 10,
                                            child: IconButton(
                                                highlightColor: Colors.black26,
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  CartItem cartItem =
                                                      new CartItem();
                                                  cartItem.id = cartController
                                                      .isProductInLaundryCart(
                                                          product)
                                                      .id;
                                                  cartItem.product = product;
                                                  if (product.quant.value > 1) {
                                                    if (cartItem.id != null) {
                                                      cartController
                                                          .addQuantityToCartTable(
                                                              cartItem,
                                                              1,
                                                              "minus");
                                                      product.quant.value -= 1;
                                                    } else {
                                                      cartController
                                                          .updateCart();
                                                      //   Get.snackbar("Error", "cartItem.id is null",backgroundColor: Colors.red, colorText: Colors.white);
                                                    }
                                                  }
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.minus,
                                                  size: 15,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       CartController cartController =
                                //       Get.put(CartController());
                                //       SignInController signInController =
                                //       Get.put(SignInController());
                                //       cartController.clickedIndex.value =
                                //           int.parse(product.id.toString());
                                //       cartController.getCartItems(
                                //           signInController.user.value.id.toString());
                                //     },
                                //     child: Container(
                                //       padding: EdgeInsets.all(5),
                                //       alignment: Alignment.center,
                                //       child: Card(
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(10)),
                                //         child: Container(
                                //           alignment: Alignment.center,
                                //           decoration: BoxDecoration(
                                //               color: AppColor.bottomitemColor1,
                                //               borderRadius: BorderRadius.circular(5)),
                                //           width: Get.size.width,
                                //           padding: EdgeInsets.all(5),
                                //           child: cartController.status == "Loading" &&
                                //               cartController.clickedIndex.value ==
                                //                   int.parse(product.id.toString())
                                //               ? LinearProgressIndicator(
                                //             color: AppColor.backgroundColor,
                                //             valueColor: AlwaysStoppedAnimation<Color>(
                                //                 AppColor.bottomitemColor1),
                                //           )
                                //               : Text("Add",
                                //               style: TextStyle(
                                //                   color: Colors.white,
                                //                   fontWeight: FontWeight.bold,
                                //                   fontSize: 14)),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                var productCategoriescontroller =
                                    Get.put(ProductCategoriesController());

                                if (signinController.id.value.trim() !=
                                        "null" &&
                                    signinController.id.value.trim() != "") {
                                  print("ontroller.selectedColor.value");
                                  print(controller.type.value);

                                  CartItem cartItem = new CartItem();
                                  cartItem.product = product;
                                  cartItem.color =
                                      controller.selectedColor.value;
                                  cartItem.quantity.value = product.quant.value;
                                  controller.setOptions(product.size);
                                  controller.options.isNotEmpty
                                      ? cartItem.size =
                                          controller.options[0].value.toString()
                                      : cartItem.size = product.size.toString();
                                  cartItem.tax =
                                      double.parse(product.tax.toString());
                                  cartItem.type =
                                      productCategoriescontroller.type.value;
                                  cartItem.clear_cart = false;

                                  if (cartController.cartItems.isEmpty) {
                                    cartController.saveToCart(
                                        cartItem, signinController.id.value);
                                    cartController.addToCart(cartItem);
                                    cartController.updateCart();
                                    product.isInCart.value = true;
                                  } else if (cartController
                                          .cartItems.first.type !=
                                      productCategoriescontroller.type.value) {
                                    Get.defaultDialog(
                                        title: "CONFIRMATION",
                                        titleStyle: TextStyle(fontSize: 16),
                                        middleText:
                                            "Your cart contains another type of product. Are you want to clear old cart?",
                                        middleTextStyle:
                                            TextStyle(fontSize: 12),
                                        cancel: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white),
                                            onPressed: () {
                                              // dashboardController.goToTab(3);
                                              product.isInCart.value = false;
                                              cartController.updateCart();
                                              Get.back();
                                            },
                                            child: Text("Cancel",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ))),
                                        confirm: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 3, 33, 49),
                                                elevation: 5),
                                            onPressed: () {
                                              cartController.daleteAllItem();
                                              cartItem.clear_cart = true;
                                              cartController.saveToCart(
                                                  cartItem,
                                                  signinController.id.value);
                                              cartController
                                                  .addToCart(cartItem);
                                              product.isInCart.value = true;
                                              cartController.updateCart();

                                              Get.back();
                                              // dashboardController.goToTab(3);
                                            },
                                            child: Text("Clear",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))),
                                        contentPadding: EdgeInsets.all(20));
                                  } else {
                                    product.isInCart.value = true;
                                    cartController.saveToCart(
                                        cartItem, signinController.id.value);
                                    cartController.addToCart(cartItem);

                                    cartController.updateCart();
                                  }

                                  // cartController.updateCart();
                                } else {
                                  cartController.comeBack.value = true;
                                  Get.toNamed(MyPagesName.SignIn);
                                }
                                cartController.updateCart();
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: Get.width,
                                alignment: Alignment.center,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColor.bottomitemColor1,
                                        borderRadius: BorderRadius.circular(5)),
                                    width: Get.size.width,
                                    padding: EdgeInsets.all(5),
                                    child: Text("Add to Cart",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ),
                                ),
                              ),
                            );
                    },
                  )
                : Container()
          ],
        ),
      );

  Widget get productDesignschool => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
          // color: Colors.black,
        ),
        child: Column(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0)),
                child: CachedNetworkImage(
                  imageUrl:
                      AppConstraints.PRODUCT_URL + product.img![0].toString(),
                  fit: BoxFit.fitHeight,
                  errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Image.asset("assets/images/noImg.png")),
                  placeholder: (context, value) => Shimmer.fromColors(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)))),
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    direction: ShimmerDirection.rtl,
                    period: Duration(seconds: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: Text(
                "${product.name}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: product.discount != 0
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                Text(
                  "\₹" +
                      (double.parse(product.mrp.toString()) - product.discount!)
                          .toString(),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                product.discount == 0
                    ? Container()
                    : Text(
                        "\₹" +
                            (double.parse(product.mrp.toString())).toString(),
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 3),
            /*    Obx(
              () => product.isInCart.value
                  ?
             Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  color: AppColor.bottomitemColor1,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 10,
                                    child: IconButton(
                                        highlightColor: Colors.black26,
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                            CartItem cartItem = new CartItem();
                                            cartItem.product = product;
                                            cartController
                                                .addQuantityToCartTable(
                                                    cartItem, 1, "plus");
                                            product.quant.value += 1;
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.plus,
                                          size: 15,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Obx(
                                    () => Container(
                                      margin: EdgeInsets.all(2),
                                      child: Text(
                                        product.quant.value.toString(),
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 10,
                                    child: IconButton(
                                        highlightColor: Colors.black26,
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          if (product.quant.value > 1) {
                                            CartItem cartItem = new CartItem();
                                            cartItem.product = product;
                                            cartController
                                                .addQuantityToCartTable(
                                                    cartItem, 1, "minus");
                                            product.quant.value -= 1;
                                          }
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.minus,
                                          size: 15,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              CartController cartController =
                                  Get.put(CartController());
                              SignInController signInController =
                                  Get.put(SignInController());
                              cartController.clickedIndex.value =
                                  int.parse(product.id.toString());
                              cartController.getCartItems(
                                  signInController.user.value.id.toString());
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColor.bottomitemColor1,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: Get.size.width,
                                  padding: EdgeInsets.all(5),
                                  child: cartController.status == "Loading" &&
                                          cartController.clickedIndex.value ==
                                              int.parse(product.id.toString())
                                      ? LinearProgressIndicator(
                                          color: AppColor.backgroundColor,
                                          valueColor:AlwaysStoppedAnimation<Color>(AppColor.bottomitemColor1),
                                        )
                                      : Text("Add",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        var productCategoriescontroller = Get.put(ProductCategoriesController());
        
                        if (signinController.id.value.trim() != "null" && signinController.id.value.trim() != "") {
                          print("ontroller.selectedColor.value");
                          print(controller.type.value) ;
                          CartItem cartItem = new CartItem();
                          cartItem.product = product;
                          cartItem.color = controller.selectedColor.value;
                          cartItem.quantity.value = product.quant.value;
                          print(controller.selectedSize.value);
        
        
                          print(product.size);
                          controller.setOptions(product.size);
                          print(controller.options[0].value.toString());
        
                          controller.options.isNotEmpty
                              ? cartItem.size = controller.options[0].value.toString()
                              : cartItem.size = product.size.toString();
                          // if(options/)
        
                          // else{
                          //   cartItem.size = controller.options[0].toString();
                          // }
        
                          cartItem.tax = double.parse(product.tax.toString());
                          cartItem.type = productCategoriescontroller.type.value;
                          cartItem.clear_cart =false ;
        
                          cartController.saveToCart(
                              cartItem, signinController.id.value);
        
                          cartController.addToCart(cartItem);
                          product.isInCart.value = true;
        
        
        
                        } else {
                          cartController.comeBack.value = true;
                          Get.toNamed(MyPagesName.SignIn);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: Get.width,
                        alignment: Alignment.center,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColor.bottomitemColor1,
                                borderRadius: BorderRadius.circular(5)),
                            width: Get.size.width,
                            padding: EdgeInsets.all(5),
                            child: Text("Buy Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ),
                        ),
                      ),
                    ),
            )*/
          ],
        ),
      );

  Widget get productSmallDesign => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
            // color: Colors.black,
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(0)),
                        image: DecorationImage(
                            repeat: ImageRepeat.noRepeat,
                            fit: BoxFit.cover,
                            image: NetworkImage(AppConstraints.PRODUCT_URL +
                                product.img![0].toString()))),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          product.isFavoirite.value
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: Colors.red,
                          size: 30,
                        ),
                      ))
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${product.name}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: product.discount != 0
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: [
                  Text(
                    "\₹" +
                        (double.parse(product.mrp.toString()) -
                                product.discount!)
                            .toString(),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  product.discount == 0
                      ? Container()
                      : Text(
                          "\₹" +
                              (double.parse(product.mrp.toString())).toString(),
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      );
}
