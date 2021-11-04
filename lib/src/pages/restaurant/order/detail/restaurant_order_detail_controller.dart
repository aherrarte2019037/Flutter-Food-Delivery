import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/utils/launch_url.dart';

class RestaurantOrderDetailController {
  late BuildContext context;
  late Function updateView;
  Order order = Order();
  Map<dynamic, List<ShoppingCartItem>> productsByCategory = {};
  int productCount = 0;

  void init(BuildContext context, Function updateView, Order order) {
    this.context = context;
    this.updateView = updateView;
    this.order = order;
    productCount = order.cart?.products?.length ?? 0;
    updateView();
  }

  void goBack() => Navigator.pop(context);

  Future assignDelivery() async {

  }

  Future callUser(int phoneNumber) async {
    await LaunchUrl.phoneCall(phoneNumber);
  }

  Future sendUserEmail(String email) async {
    await LaunchUrl.sendEmail(email);
  }

}