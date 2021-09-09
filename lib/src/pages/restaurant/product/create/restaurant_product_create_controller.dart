import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/providers/product_provider.dart';

class RestaurantProductCreateController {
  late BuildContext context;
  late Function updateView;
  final ProductProvider productProvider = ProductProvider();
  final GlobalKey<AnimatedListState> productsListKey = GlobalKey();
  Map<String, TextEditingController> textFieldControllers = {
    'name': TextEditingController(),
    'price' : TextEditingController(),
    'description' : TextEditingController(),
  };
  bool latestProductsIsLoading = false;
  List<Product> latestProducts = [];

  void init (BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView  = updateView;
    latestProducts = await getLatestProducts();
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

  void goBack() {
    Navigator.pop(context);
  }

}