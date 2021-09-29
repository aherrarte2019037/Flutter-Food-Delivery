import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_model.dart';

class ClientProductDetailController {
  late BuildContext context;
  late Function updateView;
  late AnimationController productQuantityController;
  Product product = Product(name: '', description: '', price: 0, images: []);
  int actualCarouselIndex = 0;
  int productQuantity = 1;

  void init(BuildContext context, Function updateView, Product product) {
    this.context = context;
    this.updateView = updateView;
    this.product = product;
    updateView();
  }

  void goBack() => Navigator.pop(context);

  void increaseProductQuantity() {
    productQuantity++;
    productQuantityController.repeat();
    updateView();
  }

  void decreaseProductQuantity() {
    if (productQuantity == 1) return;
    productQuantity--;
    productQuantityController.repeat();
    updateView();
  }

  void addToCart() {
    
  }

}