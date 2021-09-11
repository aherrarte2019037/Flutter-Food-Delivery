import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/providers/product_category_provider.dart';
import 'package:food_delivery/src/providers/product_provider.dart';

class RestaurantProductCreateController {
  late BuildContext context;
  late Function updateView;
  final ProductProvider productProvider = ProductProvider();
  final ProductCategoryProvider categoryProvider = ProductCategoryProvider();
  final GlobalKey<AnimatedListState> productsListKey = GlobalKey();
  Map<String, TextEditingController> textFieldControllers = {
    'name': TextEditingController(),
    'price' : TextEditingController(),
    'description' : TextEditingController(),
  };
  bool latestProductsIsLoading = false;
  List<Product> latestProducts = [];
  List<DropdownMenuItem> categoryItems = [];

  void init (BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView  = updateView;
    latestProducts = await getLatestProducts();
    categoryItems = (await getCategories()).map(
      (ProductCategory c) {
        return DropdownMenuItem(
          child: Text(
            c.name!.capitalize(),
            style: const TextStyle(fontSize: 17, color: Color(0XFF494949)),
          ),
          value: c.id,
        );
      },
    ).toList();
    updateView();
  }

  Future<List<Product>> getLatestProducts() async {
    latestProductsIsLoading = true;
    updateView();

    ResponseApi? response = await productProvider.getLatestProducts();
    List<Product> latestProducts = response?.data ?? [];

    latestProductsIsLoading = false;
    updateView();
    
    return latestProducts;
  }

  Future<List<ProductCategory>> getCategories() async {
    List<ProductCategory> categories = await categoryProvider.getAll();
    return categories;
  }

  void goBack() {
    Navigator.pop(context);
  }

}