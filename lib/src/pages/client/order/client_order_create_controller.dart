import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/models/shopping_cart_model.dart';
import 'package:food_delivery/src/providers/shopping_cart_provider.dart';
import 'package:food_delivery/src/utils/iterable_extension.dart';

class ClientOrderCreateController {
  late BuildContext context;
  late Function updateView;
  Map<String, AnimationController> quantityControllers = {};
  Map<String, AnimationController> priceControllers = {};
  Map<String, GlobalKey<AnimatedListState>> animatedListKeys = {};
  bool confirmOrderIsLoading = false;
  ShoppingCartProvider shoppingCartProvider = ShoppingCartProvider();
  Map<dynamic, List<ShoppingCartItem>> productsByCategory = {};

  void init(BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView = updateView;
    await groupProductsByCategory();
    generateAnimatedListKeys();
    updateView();
  }

  void generateAnimatedListKeys() {
    productsByCategory.forEach((key, value) {
      animatedListKeys[key] = GlobalKey<AnimatedListState>();
    });
  }

  Future<void> groupProductsByCategory() async {
    ShoppingCart shoppingCart = await shoppingCartProvider.getUserShoppingCart() ?? ShoppingCart(subTotal: 0, total: 0, products: []);
    productsByCategory = shoppingCart.products!.groupBy((product) => product.product.category['name']);
  }

  int getItemsCount() {
    int count = 0;

    productsByCategory.forEach((key, value) {
      count += (productsByCategory[key] as List).length;
    });

    return count;
  }

  void goBack() => Navigator.pop(context);

  void addItem(Product product) {
    int index = productsByCategory[product.category['name']]!.indexWhere((element) => element.product.id == product.id);
    productsByCategory[product.category['name']]![index].quantity++;

    quantityControllers[product.id]?.repeat();
    priceControllers[product.id]?.repeat();

    updateView();
  }

  void removeItem(Product product) {
    int index = productsByCategory[product.category['name']]!.indexWhere((element) => element.product.id == product.id);
    if (productsByCategory[product.category['name']]![index].quantity == 1) return;

    productsByCategory[product.category['name']]![index].quantity--;
    
    quantityControllers[product.id]?.repeat();
    priceControllers[product.id]?.repeat();

    updateView();
  }

  void deleteProduct({required ShoppingCartItem item, required Function buildWidget}) {
    String category = item.product.category['name'];
    int categoryLength = productsByCategory[category]!.length;
    int index = productsByCategory[category]!.indexWhere((element) => element.product.id == item.product.id);

    if (categoryLength == 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        productsByCategory.remove(category);
        updateView();
      });
    }

    productsByCategory[category]?.remove(item);
    animatedListKeys[category]!.currentState!.removeItem(
      index,
      (_, animation) => buildWidget(item: item, animation: animation),
      duration: const Duration(milliseconds: 500)
    );
  }

  Future<void> confirmOrder() async {

  }

}