import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/contollers/wishlist/WishlistController.dart';
import 'package:Susani/models/product.dart';
import 'package:shimmer/shimmer.dart';

class Product2Design {
  BuildContext context;
  Product product;
  var controller = Get.put(ProductController());
  var wishlistController = Get.put(WishlistController());
  var signinController = Get.put(SignInController());
  Product2Design({required this.context, required this.product});
  Widget get productDesign => Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(5),
        // color: Colors.black,
      ),
      height: 80,
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: AppConstraints.PRODUCT_URL + product.img![0].toString(),
              fit: BoxFit.fill,
              errorWidget: (context, url, error) => Icon(Icons.error),
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
          SizedBox(
            width: 25,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('${product.name}'),
              Text('\₹${product.mrp}'),
            ],
          ),
        ],
      ));

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
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        image: DecorationImage(
                            repeat: ImageRepeat.noRepeat,
                            fit: BoxFit.fill,
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
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 3),
              Text(
                "\₹${product.mrp}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}
