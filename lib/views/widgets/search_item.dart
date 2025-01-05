import 'package:Susani/consts/app_constraints.dart';
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
        CartItem cartItem = cartController.isProductInCart(item);
        if (cartItem.id == null) {
        } else {
          item.isInCart.value = true;
          item.quant.value = cartItem.quantity.value;
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
                                        color: Colors.black, fontSize: 20),
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
                          () => item.isInCart.value
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 13,
                                          child: IconButton(
                                              highlightColor: Colors.black26,
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                CartItem cartItem =
                                                    new CartItem();
                                                cartItem.product = item;
                                                cartController
                                                    .addQuantityToCartTable(
                                                        cartItem, 1, "plus");
                                                item.quant.value += 1;
                                              },
                                              icon: Icon(
                                                FontAwesomeIcons.plus,
                                                size: 20,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Obx(
                                          () => Container(
                                            margin: EdgeInsets.all(2),
                                            child: Text(
                                              item.quant.value.toString(),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 13,
                                          child: IconButton(
                                              highlightColor: Colors.black26,
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                if (item.quant.value > 1) {
                                                  CartItem cartItem =
                                                      new CartItem();
                                                  cartItem.product = item;
                                                  cartController
                                                      .addQuantityToCartTable(
                                                          cartItem, 1, "minus");
                                                  print(item.quant.value);

                                                  item.quant.value -= 1;
                                                }
                                              },
                                              icon: Icon(
                                                FontAwesomeIcons.minus,
                                                size: 20,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Expanded(
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                ),
                                                onPressed: () {
                                                  CartController
                                                      cartController =
                                                      Get.put(CartController());
                                                  SignInController
                                                      signInController =
                                                      Get.put(
                                                          SignInController());
                                                  cartController
                                                          .clickedIndex.value =
                                                      int.parse(
                                                          item.id.toString());
                                                  cartController.getCartItems(
                                                      signInController
                                                          .user.value.id
                                                          .toString());
                                                },
                                                child: cartController.status ==
                                                            "Loading" &&
                                                        cartController
                                                                .clickedIndex
                                                                .value ==
                                                            int.parse(item
                                                                .id
                                                                .toString())
                                                    ? LinearProgressIndicator(
                                                        color: AppColor
                                                            .backgroundColor,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                AppColor
                                                                    .bottomitemColor1))
                                                    : Text("Add")),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  onPressed: () {
                                    if (signinController.id.value.trim() !=
                                            "null" &&
                                        signinController.id.value.trim() !=
                                            "") {
                                      CartItem cartItem = new CartItem();
                                      cartItem.product = item;
                                      cartItem.color =
                                          controller.selectedColor.value;
                                      cartItem.quantity.value =
                                          item.quant.value;

                                      cartController.saveToCart(
                                          cartItem, signinController.id.value);

                                      cartController.addToCart(cartItem);
                                      item.isInCart.value = true;
                                    } else {
                                      cartController.comeBack.value = true;
                                      Get.toNamed(MyPagesName.SignIn);
                                    }
                                  },
                                  child: Text("Add")),
                        ),
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
