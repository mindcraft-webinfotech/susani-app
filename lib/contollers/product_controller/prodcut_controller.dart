import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/product_controller/product_categories_controller.dart';
import 'package:Susani/contollers/wishlist/WishlistController.dart';
import 'package:Susani/models/category.dart';
import 'package:Susani/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/services/remote_servies.dart';

import '../../models/size_model.dart';

class ProductController extends GetxController {
  var type = "laundry".obs;
  var user_id = "".obs;
  var productList = <Product>[].obs;
  var searchedProductList = <Product>[].obs;
  var slder = <String>[].obs;
  var currentPos = 0.obs;
  var isLoading = false.obs;
  var isLoadingbyfetch = true.obs;
  var searchStatus = "".obs;
  var isLoadingForLoadProduct = true.obs;
  var isError = false.obs;
  var product = Product().obs;
  var isFavorite = false.obs;
  var selectedColor = "".obs;
  var category_name = "".obs;
  var status = "".obs;
  var sortIndex = 0.obs;
  int pageSize = 6;
  var startPoint = 0.obs;
  ScrollController scroll = ScrollController();
  WishlistController wishlistController = Get.put(WishlistController());
  var isLoaded = false.obs;
  RxList colors = <String>[].obs;

  // Method to set options from size input as a string or a List
  // Observable list of size options
  var options = <SizeModel>[].obs;

  // Observable variable to hold the selected size
  // var selectedSize = ''.obs;
  var selectedSize = Rx<String?>(null);

  // Method to set the size
  void setSize(String size) {
    selectedSize.value = size;
  }

  String? get getSize => selectedSize.value;

  // Method to set options from size input as a string or a List
  void setOptions(dynamic sizes) {
    selectedSize.value = null;
    // Check if the sizes are provided in List format
    if (sizes is List<String>) {
      options.value = sizes.map((value) => SizeModel(value: value)).toList();
    } else if (sizes is String) {
      // If sizes are provided as a string, try to parse it
      // Example: "10, 20, 30" or "[10, 20, 30]"
      sizes = sizes.replaceAll(RegExp(r'[\[\]" ]'), ''); // Remove brackets
      options.value = sizes.split(',').map((value) => SizeModel(value: value.trim())).toList();
    }

    // Set the selected size to the first option if available
    if (options.isNotEmpty) {
      setSize(options.first.value);
    }
  }

  @override
  void onInit() {
    startPoint.value = 0;
    scroll.addListener(scrollListener);
    fetchProduct();
    super.onInit();
  }

  void fetchProduct({bool onscroll = false}) {
    if (onscroll) isLoadingbyfetch.value = true;

    Future.delayed(Duration(seconds: 1), () async {
      if (onscroll) {
      } else {
        isLoaded.value = false;
        startPoint.value = 0;
      }
      print("start point = " + startPoint.value.toString());
      print("isloaded = " + isLoaded.value.toString());
      http.Response response =
          await MyApi.getproduct(startPoint.value, pageSize,type.value,user_id.value);
      print("===============================product");
      print(response.body);
      print("===============================product");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          print(re);
          isError.value = false;
          isLoading.value = false;
          isLoadingbyfetch.value = false;
          if (onscroll && !isLoaded.value) {
            var newlist = re.map<Product>((e) => Product.fromJson(e)).toList();
            if (newlist.length < pageSize) {
              if (!isLoaded.value) {
                newlist.forEach((element) {
                  productList.add(element);
                });
              }
              startPoint.value = int.parse(newlist[0].id!);
              print("assigning --1" + startPoint.value.toString());
              isLoaded.value = true;
            } else {
              if (!isLoaded.value) {
                newlist.forEach((element) {
                  productList.add(element);
                });
              }
              startPoint.value = int.parse(newlist[0].id!);
              print("assigning --1" + startPoint.value.toString());
            }
          } else {
            productList.value =
                re.map<Product>((e) => Product.fromJson(e)).toList();

            startPoint.value = int.parse(productList[0].id!);
            print("assigning --2" + startPoint.value.toString());
          }

          switch (sortIndex.value) {
            case 0:
              {
                sortProductByLatest(productList);
                break;
              }
            case 1:
              {
                sortProductByAtoZ(productList);
                break;
              }
            case 2:
              {
                sortProductByZtoA(productList);
                break;
              }
            case 3:
              {
                sortProductByASC(productList);
                break;
              }
            case 4:
              {
                sortProductByDESC(productList);
                break;
              }
          }
        } else {
          isLoadingbyfetch.value = false;
          isError.value = true;
        }
      } else {
        isError.value = true;
        throw Exception('Failed to load data');
      }
    });
  }

  void searchProductByKey(String key, {bool onscroll = false}) {
    if (onscroll) isLoadingbyfetch.value = true;

    Future.delayed(Duration(seconds: 1), () async {
      if (onscroll) {
      } else {
        isLoaded.value = false;
        startPoint.value = 0;
      }
      print("start point = " + startPoint.value.toString());
      print("isloaded = " + isLoaded.value.toString());
      http.Response response =
          await MyApi.searchproduct(startPoint.value, pageSize, key,type.value,user_id.value);
      print("===============================product");
      print(response.body);
      print("===============================product");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          print(re);
          isError.value = false;
          isLoading.value = false;
          isLoadingbyfetch.value = false;
          if (onscroll && !isLoaded.value) {
            var newlist = re.map<Product>((e) => Product.fromJson(e)).toList();
            if (newlist.length < pageSize) {
              if (!isLoaded.value) {
                newlist.forEach((element) {
                  productList.add(element);
                });
              }
              startPoint.value = int.parse(newlist[0].id!);
              print("assigning --1" + startPoint.value.toString());
              isLoaded.value = true;
            } else {
              if (!isLoaded.value) {
                newlist.forEach((element) {
                  productList.add(element);
                });
              }
              startPoint.value = int.parse(newlist[0].id!);
              print("assigning --1" + startPoint.value.toString());
            }
          } else {
            productList.value =
                re.map<Product>((e) => Product.fromJson(e)).toList();

            startPoint.value = int.parse(productList[0].id!);
            print("assigning --2" + startPoint.value.toString());
          }

          switch (sortIndex.value) {
            case 0:
              {
                sortProductByLatest(productList);
                break;
              }
            case 1:
              {
                sortProductByAtoZ(productList);
                break;
              }
            case 2:
              {
                sortProductByZtoA(productList);
                break;
              }
            case 3:
              {
                sortProductByASC(productList);
                break;
              }
            case 4:
              {
                sortProductByDESC(productList);
                break;
              }
          }
        } else {
          isLoadingbyfetch.value = false;
          isError.value = true;
        }
      } else {
        isError.value = true;
        throw Exception('Failed to load data');
      }
    });
  }

  RxList<Product> sortProductByAtoZ(RxList<Product> productList) {
    productList.sort((a, b) => a.name!
        .toString()
        .toLowerCase()
        .compareTo(b.name!.toString().toLowerCase()));
    productList
        .where((p0) => p0.name!.toLowerCase().contains("other".toLowerCase()));
    return productList;
  }

  RxList<Product> sortProductByZtoA(RxList<Product> productList) {
    productList.sort((a, b) => b.name!
        .toString()
        .toLowerCase()
        .compareTo(a.name!.toString().toLowerCase()));
    return productList;
  }

  RxList<Product> sortProductByLatest(RxList<Product> productList) {
    productList.sort((b, a) => int.parse(a.id!).compareTo(int.parse(b.id!)));
    return productList;
  }

  RxList<Product> sortProductByASC(RxList<Product> productList) {
    productList.sort((a, b) => int.parse(a.mrp!).compareTo(int.parse(b.mrp!)));
    return productList;
  }

  RxList<Product> sortProductByDESC(RxList<Product> productList) {
    productList.sort((a, b) => int.parse(b.mrp!).compareTo(int.parse(a.mrp!)));
    return productList;
  }

  RxList<Product> fetchProductByCategory(int categoryId) {
    isLoading.value = true;
    productList.clear();
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getProductBycategory(categoryId,type.value,user_id.value);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("---------------------------------" + categoryId.toString());
        print(data);
        print("-------------------------------");
        String res = data['res'];
        isLoading.value = false;
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          isLoading.value = false;
          isError.value = false;
          productList.value =
              re.map<Product>((e) => Product.fromJson(e)).toList();
        } else {
          isError.value = true;
          print('Failed to load data ' + msg);
        }
      } else {
        isError.value = true;
        isLoading.value = false;
        throw Exception('Failed to load data');
      }
    });
    return productList;
  }

  RxList<Product> searchProductByCategory(int categoryId) {
    searchStatus.value = "Searching";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getProductBycategory(categoryId,type.value,user_id.value);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          searchStatus.value = "Done";
          searchedProductList.value =
              re.map<Product>((e) => Product.fromJson(e)).toList();

          switch (sortIndex.value) {
            case 0:
              {
                sortProductByLatest(searchedProductList);
                break;
              }
            case 1:
              {
                sortProductByAtoZ(searchedProductList);
                break;
              }
            case 2:
              {
                sortProductByZtoA(searchedProductList);
                break;
              }
            case 3:
              {
                sortProductByASC(searchedProductList);
                break;
              }
            case 4:
              {
                sortProductByDESC(searchedProductList);
                break;
              }
          }
        } else {
          isError.value = false;
          searchStatus.value = msg;
          print('Failed to load data ' + msg);
        }
      } else {
        isError.value = false;
        searchStatus.value = "Failed to load data";
        throw Exception('Failed to load data');
      }
    });
    return searchedProductList;
  }

  updateSlider(int index) {
    currentPos.value = index;
  }

  loadProductDetails(Product product) {
    loadProduct(product.id!);
  }

  void loadProduct(String productId) {
    status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getProductDetails(productId);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'];
          status.value = "done";
          product.value = Product.fromJson(re);
          addisFavorite();
          // print(product.value.name);
          if (product.value.color!.contains(",")) {
            colors.value = product.value.color!.split(",");
          } else {
            colors.clear();
            if (product.value.color != "") colors.add(product.value.color);
          }
          // selectedColor.value = colors[0] == "" ? 0 : colors[0];
          var cat_controller = Get.put(ProductCategoriesController());
          // print("Print length" + product.value.img!.length.toString());
          for (var item in product.value.img!) {
            // print(item);
          }
          for (Category cat in cat_controller.categories) {
            // print(cat.id! + "==" + product.value.categoryId.toString());
            if (cat.id == product.value.categoryId.toString()) {
              // print("category=" + cat.categoryname.toString());
              category_name.value = cat.categoryname.toString();
            }
          }

          setOptions(product.value.size.toString());
        } else {
          status.value = "failed";
        }
      } else {
        status.value = "Failed";

        //throw Exception('Failed to load album');
      }
    });
  }

  //handle quantity of product

  increment(Product product) {
    product.quant++;
  }

  decrement(Product product) {
    if (product.quant > 1) {
      product.quant--;
    }
  }

  void scrollListener() {
    if (scroll.position.pixels >= scroll.position.maxScrollExtent) {
      if (isLoadingbyfetch.value) {
      } else {
        if (!isLoaded.value) {
          fetchProduct(onscroll: true);
        }
      }
    }
  }

  void addisFavorite() {
    for (var product in wishlistController.productList) {
      if (product.id == this.product.value.id) {
        this.product.value.isFavoirite.value = true;
        break;
      }
    }
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }
}
