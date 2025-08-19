import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/views/pages/ecom/utils/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/product_controller/product_categories_controller.dart';
import 'package:Susani/contollers/search_controller/search_controller.dart';
import 'package:Susani/models/category.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/utils/routes_pages/routes_pages.dart';

import '../../contollers/cart_controller/cart_controller.dart';
import '../../contollers/signin/SignInController.dart';
import '../../models/CartItem.dart';

class SearchItemDesign {
  static var sItem = "".obs;
  static var selectItem = "".obs;

  var searchController = Get.put(SearchControllerone());
  var productCatController = Get.put(ProductCategoriesController());
  var signinController = Get.put(SignInController());
  var cartController = Get.put(CartController());
  var controller = Get.put(ProductController());
  SearchItemDesign() {
    searchController.Products.forEach((item) {
      {
        CartItem cartItem =cartController.isProductInLaundryCart(item);
        if (cartItem.id == null) {} else {
          item.isInCart.value = true;
          item.quant.value = cartItem.quantity.value;
          print(cartItem.id.toString()+ " ======= "+ item.id.toString());
        }
      }

      searchController.choices.add(
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  width: Get.width - 50,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 0, 0, 0),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(MyPagesName.productFullView,
                              arguments: item.id);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            AppConstraints.PRODUCT_URL + item.img![0],
                            height: 80,
                            width: 80,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(MyPagesName.productFullView,
                                arguments: item.id);
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    item.name!,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "\₹" +
                                          (double.parse(item.mrp.toString()) -
                                                  item.discount!)
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    item.discount == 0
                                        ? Container()
                                        : Text(
                                            "\₹" +
                                                (double.parse(
                                                        item.mrp.toString()))
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      Expanded(
                        child: Obx(
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

                            return
                              item.isInCart.value
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
                                                    cartItem.id = cartController
                                                        .isProductInLaundryCart(item)
                                                        .id;
                                                    cartItem.product = item;
                                                    if (cartItem.id != null) {
                                                      if (item.quant.value > 0) {
                                                        cartController
                                                            .addQuantityToCartTable(
                                                            cartItem, 1, "plus");
                                                        item.quant.value += 1;
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
                                                item.quant.value.toString(),
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
                                                    CartItem cartItem = new CartItem();
                                                    cartItem.id = cartController
                                                        .isProductInLaundryCart(item)
                                                        .id;
                                                    cartItem.product = item;
                                                    if (item.quant.value > 1) {
                                                      if (cartItem.id != null) {
                                                        cartController
                                                            .addQuantityToCartTable(
                                                            cartItem, 1, "minus");
                                                        item.quant.value -= 1;
                                                      } else {
                                                        cartController.updateCart();
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
                                  var productCategoriescontroller = Get.put(
                                      ProductCategoriesController());

                                  if (signinController.id.value.trim() != "null" &&
                                      signinController.id.value.trim() != "") {
                                    print("ontroller.selectedColor.value");
                                    print(controller.type.value);

                                    CartItem cartItem = new CartItem();
                                    cartItem.product = item;
                                    cartItem.color = controller.selectedColor.value;
                                    cartItem.quantity.value = item.quant.value;
                                    controller.setOptions(item.size);
                                    controller.options.isNotEmpty
                                        ?
                                    cartItem.size = controller.options[0].value.toString()
                                        : cartItem.size = item.size.toString();
                                    cartItem.tax = double.parse(item.tax ?? "0");
                                    cartItem.type =
                                        productCategoriescontroller.type.value;
                                    cartItem.clear_cart = false;

                                    if (cartController.cartItems.isEmpty) {
                                      cartController.saveToCart(
                                          cartItem, signinController.id.value);
                                      cartController.addToCart(cartItem);
                                      cartController.updateCart();
                                      item.isInCart.value = true;
                                    } else if (cartController.cartItems.first.type !=
                                        productCategoriescontroller.type.value) {
                                      Get.defaultDialog(
                                          title: "CONFIRMATION",
                                          titleStyle: TextStyle(
                                              fontSize: 16),
                                          middleText: "Your cart contains another type of product. Are you want to clear old cart?",
                                          middleTextStyle:
                                          TextStyle(
                                              fontSize: 12),
                                          cancel: ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                  backgroundColor: Colors
                                                      .white),
                                              onPressed: () {
                                                // dashboardController.goToTab(3);
                                                item.isInCart.value = false;
                                                cartController.updateCart();
                                                Get.back();
                                              },
                                              child: Text(
                                                  "Cancel",
                                                  style:
                                                  TextStyle(
                                                    color: Colors
                                                        .black,
                                                  ))),
                                          confirm: ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                  backgroundColor: Color
                                                      .fromARGB(
                                                      255,
                                                      3,
                                                      33,
                                                      49),
                                                  elevation:
                                                  5),
                                              onPressed: () {
                                                cartController.daleteAllItem();
                                                cartItem.clear_cart = true;
                                                cartController.saveToCart(
                                                    cartItem, signinController.id.value);
                                                cartController.addToCart(cartItem);
                                                item.isInCart.value = true;
                                                cartController.updateCart();

                                                Get.back();
                                                // dashboardController.goToTab(3);
                                              },
                                              child: Text(
                                                  "Clear",
                                                  style:
                                                  TextStyle(
                                                    color: Colors
                                                        .white,
                                                  ))),
                                          contentPadding:
                                          EdgeInsets.all(20));
                                    } else {
                                      item.isInCart.value = true;
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
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
