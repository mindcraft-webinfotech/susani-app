import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/wishlist/WishlistController.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/views/widgets/product_design.dart';

class MyFavouritePage extends StatelessWidget {
  var controller = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    controller.update_wishlist();
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
          "My Favorites ",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() => controller.status.value == "Loading"
              ? Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(child: new CircularProgressIndicator()))
              : Obx(
                  () => controller.productList.length > 0
                      ? StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          primary: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.productList.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              //controller.loadProductDetails(controller.productList[index]);
                              Get.toNamed(MyPagesName.productFullView,
                                  arguments: controller.productList[index].id);
                            },
                            child: ProductDesign(
                                    context: context,
                                    product: controller.productList[index])
                                .productDesign,
                          ),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.fit(2),
                          mainAxisSpacing: 9.0,
                          crossAxisSpacing: 10.0,
                        )
                      : Container(
                          height: Get.height - 150,
                          child: Center(
                            child: Text("Wishlist is empty"),
                          ),
                        ),

                )),
        ),
      ),
    );
  }
}
