import 'package:Susani/consts/app_theme.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/order_history/OrderHistory.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/product_controller/product_categories_controller.dart';
import 'package:Susani/models/CartItem.dart';
import 'package:Susani/models/Order.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/views/pages/product/product_page.dart';
import 'package:Susani/views/pages/profile/profile_page.dart';
import 'package:Susani/views/pages/schoolshop/schoolshop.dart';
import 'package:Susani/views/widgets/prod2_design.dart';
import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/news_controller/news_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/utils/routes_pages/CommonTool.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../../contollers/dashboard_controller/dashboard_controller.dart';
import '../../../contollers/search_controller/search_controller.dart';
import '../schoolshop/Search_School.dart';

class NewsPage extends GetView<NewsController> {
  DateTime now = new DateTime.now();
  var refreshController = RefreshController(initialRefresh: false).obs;

  SignInController signInController = Get.put(SignInController());

  var dashboardController = Get.put(DashboardController());

  NewsPage() {
    CartController cartController = Get.put(CartController());
    SignInController signInController = Get.put(SignInController());
    cartController.getCartItems(signInController.user.value.id.toString());
  }

  ProductCategoriesController prod_ctrl =
      Get.put(ProductCategoriesController());

  var ctrl = Get.put(NewsController());

  // Product product;
  OrderHistoryController orderController = Get.put(OrderHistoryController());

  // var signInController = Get.put(SignInController());
  var productController = Get.find<ProductController>();
  var cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    String datetime = new DateFormat.yMMMMd('en_US').format(now);
    return SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
          body: Stack(children: [
            SmartRefresher(
              controller: refreshController.value,
              enablePullDown: true,
              // header: WaterDropHeader(),
              onRefresh: () {
                controller.refershList();
                refreshController.value.refreshCompleted();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            signInController.id.value == "" ||
                                    signInController.id.value == "null"
                                ? Get.toNamed(MyPagesName.SignIn)
                                : Get.to(() => ProfilePage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.view_headline_rounded,
                              color: AppColor.bottomitemColor2,
                              size: 27,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(2),
                          child: TextField(
                              readOnly: true,
                              onTap: () {
                                dashboardController.goToTab(2);
                              },
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  hintText: "Search Products",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  contentPadding: EdgeInsets.only(left: 10))),
                        )),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            dashboardController.goToTab(3);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Badge(
                              label: Obx(
                                () => Text(
                                  cartController.totalQuantity.toString(),
                                  style: TextStyle(
                                      color: AppColor.backgroundColor),
                                ),
                              ),
                              child: Icon(
                                FontAwesomeIcons.cartPlus,
                                color: AppColor.bottomitemColor2,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Obx(() => Column(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                  height: 180.0,
                                  aspectRatio: 3.0,
                                  autoPlay: true,
                                  reverse: false,
                                  autoPlayInterval: const Duration(seconds: 4),
                                  scrollDirection: Axis.horizontal,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    controller.sliderIndex(index);
                                  }),
                              items: controller.sliders.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        // print("----------------------");
                                        // print(controller
                                        //     .sliders[
                                        //         controller.currentIndex.value]
                                        //     .description);

                                        var _url = controller
                                            .sliders[
                                                controller.currentIndex.value]
                                            .description;
                                        CommonTool.launchURL(_url);
                                        // Get.toNamed(MyPagesName.newsfullpage,
                                        //     arguments: [
                                        //       controller
                                        //           .sliders[controller
                                        //               .currentIndex.value]
                                        //           .id,
                                        //       controller
                                        //           .sliders[controller
                                        //               .currentIndex.value]
                                        //           .title
                                        //     ]);
                                      },
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CachedNetworkImage(
                                                  imageUrl: AppConstraints
                                                          .BANNER_URL +
                                                      i.image!,
                                                  fit: BoxFit.fill,
                                                  placeholder:
                                                      (context, value) =>
                                                          Shimmer.fromColors(
                                                    child: Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Container(
                                                            width: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .width,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)))),
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    enabled: true,
                                                    direction:
                                                        ShimmerDirection.rtl,
                                                    period:
                                                        Duration(seconds: 2),
                                                  ),
                                                ),
                                              ))),
                                    );
                                    // errorWidget: (context, url, error) => Icon(Icons.error),
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () => ctrl.isLoadin.value == true
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.white,
                              child: Container(
                                width: Get.width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                            )
                          : Container(
                              width: Get.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Our Services',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          height: 200,
                          child: Obx(
                            () => ctrl.isLoadin.value == true
                                ? Container()
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: ctrl.categories.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () {
                                            prod_ctrl.type.value = "laundry";
                                            controller.type.value = "laundry";
                                            productController.type.value = "laundry";
                                            productController.user_id.value="0";
                                            controller.loadCategories();
                                            ctrl.loadCategories();
                                            prod_ctrl.loadCategories();
                                            Get.find<ProductController>()
                                                .fetchProductByCategory(
                                                    int.parse(ctrl
                                                        .categories[index]
                                                        .id!));
                                            ProductCategoriesController ctrll =
                                                Get.find<
                                                    ProductCategoriesController>();
                                            ctrll.selectedCategories(ctrl
                                                .categories[index]
                                                .categoryname!);
                                            /*  Get.to(() => ProductCategory(
                                              category:
                                                  ctrl.categories[index])); */
                                            prod_ctrl.getCategoryId(index);
                                            // Get.to(() => ProductPage());
                                            dashboardController.goToTab(1);
                                          },
                                          child: Container(
                                              margin: EdgeInsets.all(5),
                                              width: Get.width / 2,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all()),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              topRight: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          0),
                                                              bottomLeft: Radius
                                                                  .circular(0)),
                                                      child: CachedNetworkImage(
                                                        imageUrl: AppConstraints
                                                                .CAT_IMAGE_URL +
                                                            ctrl
                                                                .categories[
                                                                    index]
                                                                .image!,
                                                        fit: BoxFit.fill,
                                                        placeholder: (context,
                                                                value) =>
                                                            Shimmer.fromColors(
                                                          child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)))),
                                                          baseColor: Colors
                                                              .grey.shade300,
                                                          highlightColor: Colors
                                                              .grey.shade100,
                                                          enabled: true,
                                                          direction:
                                                              ShimmerDirection
                                                                  .ltr,
                                                          period: Duration(
                                                              seconds: 1),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${ctrl.categories[index].categoryname}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(height: 3),
                                                  // Text(
                                                  //   "\₹${product.mrp}",
                                                  //   style: TextStyle(
                                                  //       color: Colors.black,
                                                  //       fontWeight:
                                                  //           FontWeight.bold),
                                                  // ),
                                                ],
                                              ))

                                          /* Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(2, 2),
                                                blurRadius: 8,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.16),
                                              )
                                            ],
                                            // gradient: LinearGradient(
                                            //   colors: [
                                            //     Colors.white.withOpacity(1),
                                            //     Colors.lightBlueAccent.shade200,
                                            //   ],
                                            //   // begin: Alignment.topLeft,
                                            //   // end: Alignment.bottomRight,
                                            // ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Obx(() => ctrl
                                                      .isLoadin.value ==
                                                  false
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      child: Image.network(
                                                        AppConstraints
                                                                .CAT_IMAGE_URL +
                                                            ctrl
                                                                .categories[
                                                                    index]
                                                                .image!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    // Text("${ctrl.categories.first.image!}"),
                                                    Text(
                                                        "${ctrl.categories[index].categoryname}")
                                                  ],
                                                )
                                              : Image.asset(
                                                  'assets/images/laundry_delivery.png')),
                                        ),  */
                                          );
                                    }),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap:
                          () => Get.to(SearchSchool()),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset("assets/images/school2.jpg")),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset("assets/images/comingsoon.jpeg")),
                    ),



                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => orderController.status == "Loading"
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.white,
                              child: Container(
                                width: Get.width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                            )
                          : Container(
                              width: Get.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Previously Ordered',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                    ),
                    Obx(
                      () => orderController.status == "Loading"
                          ? Center(
                              child: Text("Loading records.."),
                            )
                          : orderController.orders.length < 1
                              ? Center(
                                  child: Text("Order history is empty!"),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: orderController.orders.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        // padding: EdgeInsets.symmetric(
                                        //     vertical: 0, horizontal: 5),
                                        // margin: EdgeInsets.all(0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              child: Column(
                                                  children: itemList(
                                                      orderController
                                                          .orders[index]
                                                          .cartItems!,
                                                      index,
                                                      context)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(() => controller.isLoading == true
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.red,
                      color: Colors.black,
                    )
                  : Container()),
            )
          ]),
        ));
  }

  List<Widget> itemList(
      List<dynamic> cartItems, int index, BuildContext context) {
    List<Widget> itemlis = [];
    for (int subindex = 0; subindex < cartItems.length; subindex++) {
      itemlis.add(InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Get.toNamed(MyPagesName.productFullView,
                        arguments: orderController
                            .orders[index].cartItems![subindex].product.id);
                  },
                  child: CircleAvatar(
                    // radius: 30.0,
                    backgroundImage: NetworkImage(
                        "${AppConstraints.PRODUCT_URL + "" + orderController.orders[index].cartItems![subindex].product.img[0]}"),
                    backgroundColor: Colors.transparent,
                  )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderController
                            .orders[index].cartItems![subindex].product.name,
                        style: AppTheme.headingSmallTextStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      /*Text(
                        orderController.orders[index].cartItems![subindex]
                            .product.name,
                        style: AppTheme.smallTextStyle,
                      ),*/
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Text(
                        "\₹ " +
                            orderController
                                .orders[index].cartItems![subindex].product.mrp
                                .toString(),
                        style: AppTheme.smallTextStyl,
                      )
                    ],
                  ),
                ),
              ),

              // ),
            ],
          ),
        ),
      ));
    }
    return itemlis;
  }
}
