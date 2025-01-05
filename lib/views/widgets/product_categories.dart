import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/contollers/product_controller/prodcut_controller.dart';
import 'package:Susani/contollers/product_controller/product_categories_controller.dart';
import 'package:Susani/models/category.dart';

String selectItem = "All";

class ProductCategoriesDesign extends StatefulWidget {
  final Function(String category) category;

  final List<Category> itemList;
  static String? sItem;

  ProductCategoriesDesign({required this.itemList, required this.category});



  @override
  _ProductCategoriesDesignState createState() =>
      _ProductCategoriesDesignState();
}

class _ProductCategoriesDesignState extends State<ProductCategoriesDesign> {
    var controller=Get.find<ProductCategoriesController>();
  _buildList() {
    List<Widget> choices = [];
    widget.itemList.forEach((item) {
      choices.add(Padding(
        padding: const EdgeInsets.all(3.0),
        child: Obx(
          ()=>Container(
            child: ChoiceChip(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              label:  
              Text(
                  item.categoryname!,
                  style: TextStyle(
                     /*  color: ProductCategoriesDesign.sItem != null
                          ? ProductCategoriesDesign.sItem == item.categoryname
                              ? Colors.white
                              : AppColor.bottomitemColor2
                          : selectItem == item.categoryname
                              ? Colors.white
                              : AppColor.bottomitemColor2 */
                                color: ProductCategoriesDesign.sItem != null
                          ? ProductCategoriesDesign.sItem == item.categoryname
                              ? Colors.white
                              : AppColor.bottomitemColor2
                          :  controller.selectItem.value == item.categoryname
                              ? Colors.white
                              : AppColor.bottomitemColor2 
                              
                              
                              ),
                
              ),
              selectedColor: AppColor.bottomitemColor2,
              padding: const EdgeInsets.all(10),
              //disabledColor: AppColor.backgroundColor,
              backgroundColor:
                  controller.selectItem.value != item.categoryname ? Colors.white : AppColor.bottomitemColor1,
              selected: ProductCategoriesDesign.sItem != null
                  ? ProductCategoriesDesign.sItem == item
                  : controller.selectItem.value == item,
              onSelected: (selected) {
                if (ProductCategoriesDesign.sItem != null) {
                  ProductCategoriesDesign.sItem = null;
                }
                  setState(() {
                       selectItem = item.categoryname!;
                  });
                 
                  ProductCategoriesController ctrl =
                      Get.find<ProductCategoriesController>();
                  ctrl.selectedCategories(item.categoryname!);
                  widget.category(item.id.toString());
             
              },
            ),
          ),
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(scrollDirection: Axis.horizontal, children: _buildList());
  }

  String getSelectedItem() {
    if (ProductCategoriesDesign.sItem != null) {
      return ProductCategoriesDesign.sItem!;
    } else {
      return selectItem;
    }
  }
}
