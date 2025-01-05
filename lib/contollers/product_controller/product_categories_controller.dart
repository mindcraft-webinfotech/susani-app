import 'dart:convert';

import 'package:get/get.dart';
import 'package:Susani/contollers/wishlist/WishlistController.dart';
import 'package:Susani/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/services/remote_servies.dart';

class ProductCategoriesController extends GetxController {
  var type="school".obs;
  var categoriesName = "All".obs;
  var searchCategoriesName = "".obs;
  var isLoading = true.obs;
  var selectItem = "All".obs;



  List<Category> categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }


  void loadCategories() {
    isLoading = true.obs;
     Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getCategory(type.value);
      print("loadCategories");
       print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;

          categories = re.map<Category>((e) => Category.fromJson(e)).toList();
          Category cat = new Category();
          cat.id = 0.toString();
          cat.categoryname = "All";
         // cat.image = null;
          categories.insert(0, cat);
          isLoading.value = false;


        } else {}
      } else {
        //throw Exception('Failed to load album');
      }
    });
  }


  void selectedCategories(String item) {
    print(item);
    selectItem.value=item;
    categoriesName.value = item;
  }

  var catIndex = 0.obs;
   getCategoryId(index){
     catIndex.value = index ;
     return catIndex.value.toString();
  }

}
