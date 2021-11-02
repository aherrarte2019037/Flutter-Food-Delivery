import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/pages/client/product/detail/client_product_detail_page.dart';
import 'package:food_delivery/src/providers/product_category_provider.dart';
import 'package:food_delivery/src/providers/product_provider.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductListController {
  ProductCategoryProvider categoryProvider = ProductCategoryProvider();
  ProductProvider productProvider = ProductProvider();
  UserProvider userProvider = UserProvider();
  User? user;
  List<ProductCategory> categories = [];
  List products = [];
  bool categoriesIsLoading = false;
  late BuildContext context;
  late Function updateView;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<AnimatedListState> categoriesListKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  void init(BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView = updateView;
    user = await userProvider.getProfile();
    addCategoriesToList();
    products = await getProductsGrouped();
    updateView();
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  void goToOrderCreate() => Navigator.pushNamed(context, 'client/order/create');

  void scrollToCategory(ProductCategory category) {
    int index = products.indexWhere(
      (element) => element['category']['name'].toLowerCase() == category.name?.toLowerCase(),
    );
    scrollController.animateTo(
      (index + 1) * 260,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  Future<List> getProductsGrouped() async {
    List productsGrouped = await productProvider.productsGroupBy('category');
    return productsGrouped;
  }

  Future<void> addCategoriesToList() async {
    categoriesIsLoading = true;
    updateView();

    List<ProductCategory> allCategories = await categoryProvider.getCategoriesWithProducts();
    if (allCategories.isEmpty) allCategories.add(ProductCategory(name: 'No hay categorías', image: 'assets/images/product-category-image.png',));
    
    categoriesIsLoading = false;
    updateView();

    for (var i = 0; i < allCategories.length; i++) {
      Future.delayed(Duration(milliseconds: i * 400), () {
        categories.add(allCategories[i]);
        categoriesListKey.currentState?.insertItem(categories.length - 1);
      });
    }
  }

  void showProductDetailModal(Product product) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (_) => ClientProductDetailPage(product: product),
    );
  }

}