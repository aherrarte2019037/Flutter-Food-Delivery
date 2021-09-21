import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/providers/product_category_provider.dart';

class ClientProductListController {
  ProductCategoryProvider categoryProvider = ProductCategoryProvider();
  List<ProductCategory> categories = [];
  bool categoriesIsLoading = false;
  bool productsIsLoading = false;
  late BuildContext context;
  late Function updateView;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<AnimatedListState> categoriesListKey = GlobalKey();

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> addCategoriesToList() async {
    categoriesIsLoading = true;
    updateView();

    List<ProductCategory> allCategories = await categoryProvider.getAll();
    if (allCategories.isEmpty) allCategories.add(ProductCategory(name: 'No hay categorías', image: 'assets/images/product-category-image.png',));
    
    categoriesIsLoading = false;
    updateView();

    for (var i = 0; i < allCategories.length; i++) {
      print(i);
      Future.delayed(Duration(milliseconds: i * 400), () {
        categories.add(allCategories[i]);
        categoriesListKey.currentState?.insertItem(categories.length - 1);
      });
    }
  }

}