import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_model.dart';

class ClientProductDetailController {
  late BuildContext context;
  late Function updateView;
  Product product = Product(name: '', description: '', price: 0, images: []);
  int actualCarouselIndex = 0;

  void init(BuildContext context, Function updateView, Product product) {
    this.context = context;
    this.updateView = updateView;
    this.product = product;
    updateView();
  }

  void goBack() => Navigator.pop(context);

}