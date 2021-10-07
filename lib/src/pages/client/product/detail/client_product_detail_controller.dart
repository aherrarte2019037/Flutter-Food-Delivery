import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/models/shopping_cart_model.dart';
import 'package:food_delivery/src/providers/shopping_cart_provider.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';

class ClientProductDetailController {
  late BuildContext context;
  late Function updateView;
  late AnimationController productQuantityController;
  late AnimationController productPriceController;
  ShoppingCartProvider shoppingCartProvider = ShoppingCartProvider();
  Product product = Product(name: '', description: '', price: 0, calories: 0, images: [], createdAt: DateTime(0), category: '', available: true);
  List<ShoppingCartItem> productsPurchased = [];
  int actualCarouselIndex = 0;
  Map<String, dynamic> isProductPurchased = { 'purchased': false, 'product': null };
  int productQuantity = 1;

  void init(BuildContext context, Function updateView, Product product) async {
    this.context = context;
    this.updateView = updateView;
    this.product = product;
    productsPurchased = await shoppingCartProvider.getProductsPurchased();
    verifyProductPurchased();
    updateView();
  }

  void verifyProductPurchased() {
    productsPurchased.any((item) {
      if (item.product.id == product.id) {
        isProductPurchased['purchased'] = true;
        isProductPurchased['product'] = item;
        return true;
      }

      return false;
    });
  }

  void goBack() => Navigator.pop(context);

  void increaseProductQuantity() {
    productQuantity++;
    productQuantityController.repeat();
    productPriceController.repeat();
    updateView();
  }

  void decreaseProductQuantity() {
    if (productQuantity == 1) return;
    productQuantity--;
    productQuantityController.repeat();
    productPriceController.repeat();
    updateView();
  }
  
  void addToCart() async {
    ShoppingCart? cart = await shoppingCartProvider.addProductToShoppingCart(product, productQuantity);

    if (cart == null) {
      CustomSnackBar.showError(context, 'Aviso', 'Error al añadir producto');
      return;
    }

    CustomSnackBar.showSuccess(context, 'Felicidades', 'Producto añadido al carrito');
    productsPurchased = cart.products!;
    verifyProductPurchased();
    updateView();
  }

  void setActualCarouselIndex(int index) {
    actualCarouselIndex = index;
    updateView();
  }

}