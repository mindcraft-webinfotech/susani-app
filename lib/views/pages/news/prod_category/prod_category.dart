import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/news_controller/news_controller.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategory extends StatelessWidget {
  // const ProductCategory({ Key? key }) : super(key: key);
  Category category;

  ProductCategory({required this.category});

  // var ctrl = Get.put(NewsController());
  var prod_ctrl = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Text(""),
        centerTitle: true,
        title: Text(
          category.categoryname!, // ctrl.categoriesName.value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Obx(
          () => Get.find<ProductController>().isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.black,
                ))
              : Get.find<ProductController>().productList.isEmpty
                  ? Center(
                      child: Text("Product Not Found"),
                    )
                  : Obx(
                      () => prod_ctrl.isLoading.value == true
                          ? CircularProgressIndicator()
                          : GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: prod_ctrl.productList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    // Get.find<ProductController>().fetchProductByCategory(int.parse(prod_ctrl.productList[index].id!));
                                    // Get.to(()=>ProductCategory(category:prod_ctrl.categories[index]));
                                  },
                                  child: Container(
                                    // padding: EdgeInsets.all(10),
                                     margin: EdgeInsets.all(5),
                                       decoration: BoxDecoration( 
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(1),
                                          Colors.lightBlueAccent.shade100,
                                        ],
                                        // begin: Alignment.topLeft,
                                        // end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                        child: Obx(() => prod_ctrl
                                                    .isLoading.value ==
                                                false
                                            ? Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment
                                              //         .spaceEvenly,
                                              children: [
                                                Image.network(AppConstraints
                                                        .PRODUCT_URL +
                                                    prod_ctrl.productList
                                                        .first.images!,
                                                        fit: BoxFit.contain,),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    
                                                    Text(
                                                        "${prod_ctrl.productList[index].name}"),
                                                     Text(
                                                    "\₹ "+ "${prod_ctrl.productList[index].mrp}")
                                                  ],
                                                ),
                                               
                                              ],
                                            )
                                            : Image.asset(
                                                'assets/images/laundry_delivery.png'))),
                                  ),
                                );
                              }),
                    ),
        ),
      ),
    );
  }
}
