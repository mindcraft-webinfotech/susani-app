import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/profile_controller/profile_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';

import 'package:Susani/views/widgets/profile_card.dart';

import '../../../consts/app_color.dart';
import '../../../contollers/cart_controller/cart_controller.dart';
import '../../../contollers/dashboard_controller/dashboard_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  SignInController signInController = Get.put(SignInController());

  var cartController = Get.put(CartController());
  var dashboardController = Get.put(DashboardController());

  ProfilePage({Key? key}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            Text(
              "Profile",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                dashboardController.goToTab(3);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Obx(
                  () => Badge(
                    label: Text(
                      cartController.totalQuantity.toString(),
                      style: TextStyle(color: AppColor.backgroundColor),
                    ),
                    child: Icon(
                      FontAwesomeIcons.cartPlus,
                      color: AppColor.bottomitemColor2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => signInController.id.value == "" ||
                  signInController.id.value == "null"
              ? Container(
                  child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(MyPagesName.SignIn);
                          },
                          child: Text("Login first to see your profile"))))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Container(
                                      margin: EdgeInsets.all(5),
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(signInController
                                                .user.value.image.value),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          signInController.user.value.name
                                                      .toString() ==
                                                  "null"
                                              ? ""
                                              : signInController.user.value.name
                                                  .toString(),
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              signInController.user.value.email
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.verified_user_rounded,
                                                  color: Colors.blueGrey,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  "Verified",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Expanded(
                                            flex: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    MyPagesName.editProfile);
                                              },
                                              child: Card(
                                                color: Colors.blueGrey,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5,
                                                      bottom: 5,
                                                      left: 10,
                                                      right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/icon/edit.png",
                                                        width: 20,
                                                        height: 20,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: () {
                          Get.toNamed(MyPagesName.myOrders);
                        },
                        child: Container(
                          child:
                              ProfileCard(context: context, title: "My Orders")
                                  .profileCard,
                        )),
                    InkWell(
                        onTap: () {
                          Get.toNamed(MyPagesName.myFavourites);
                        },
                        child: Container(
                          child: ProfileCard(
                                  context: context, title: "My Favorites")
                              .profileCard,
                        )),
                    InkWell(
                      onTap: () {
                        Get.toNamed(MyPagesName.shippingAddress);
                      },
                      child: Container(
                        child: ProfileCard(
                                context: context, title: "Shipping Address")
                            .profileCard,
                      ),
                    ),
                    // InkWell(
                    //     onTap: () {
                    //       Get.toNamed(MyPagesName.savedCards);
                    //     },
                    //     child: Container(
                    //       child: ProfileCard(
                    //               context: context, title: "My Save Cards")
                    //           .profileCard,
                    //     )),
                    InkWell(
                      onTap: () {
                        Get.toNamed(MyPagesName.giftCards);
                      },
                      child: Container(
                        child:
                            ProfileCard(context: context, title: "Promo codes")
                                .profileCard,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(MyPagesName.MyWebView, arguments: [
                          "https://susani.in/return.php",
                          "Cancellation and Refund"
                        ]);
                      },
                      child: Container(
                        child: ProfileCard(
                                context: context,
                                title: "Cancellation and refund policy")
                            .profileCard,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(MyPagesName.MyWebView, arguments: [
                          "https://susani.in/terms_conditions.php",
                          "Terms Condition"
                        ]);
                      },
                      child: Container(
                        child: ProfileCard(
                                context: context, title: "Terms and Condition")
                            .profileCard,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(MyPagesName.MyWebView, arguments: [
                          "https://susani.in/privacy_policy.php",
                          "Privacy Policy"
                        ]);
                      },
                      child: Container(
                        child: ProfileCard(
                                context: context, title: "Privacy and policy")
                            .profileCard,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(MyPagesName.ContctUs);
                      },
                      child: Container(
                        child:
                            ProfileCard(context: context, title: "Contact Us")
                                .profileCard,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          /* Get.dialog(LogoutPopup(context: context).dialog,
                        useSafeArea: true); */
                          Get.defaultDialog(
                              title: "CONFIRMATION",
                              titleStyle: TextStyle(fontSize: 16),
                              middleText: "Are you sure to logout?",
                              middleTextStyle: TextStyle(fontSize: 12),
                              cancel: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Cancel",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ))),
                              confirm: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      elevation: 5),
                                  onPressed: () {
                                    signInController.id.value = "";
                                    signInController.returnItems();
                                    signInController.message.value = "";
                                    signInController.user.value = new User();
                                    CommonTool()
                                        .removeFromPreference()
                                        .then((value) => {});
                                    Get.back();
                                    Get.toNamed(MyPagesName.SignIn);
                                  },
                                  child: Text("Logout",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                              contentPadding: EdgeInsets.all(20));

                          /* cancel: AppButton(context: context, buttonTitle: "Cancel")
                            .myButton,
                        confirm:
                            AppButton(context: context, buttonTitle: "Logout")
                                .myButton); */
                        },
                        child: Container(
                            child:
                                ProfileCard(context: context, title: "Logout")
                                    .profileCard)),
                  ],
                ),
        ),
      ),
    );
  }
}
