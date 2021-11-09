import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/providers/order_provider.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/utils/launch_url.dart';

class DeliveryOrderDetailController {
  late BuildContext context;
  late Function updateView;
  late Function updateParentOrders;
  UserProvider userProvider = UserProvider();
  OrderProvider orderProvider = OrderProvider();
  Map<dynamic, List<ShoppingCartItem>> productsByCategory = {};
  Order order = Order();
  int productCount = 0;

  void init(BuildContext context, Function updateView, Function updateParentOrders, Order order) async {
    this.context = context;
    this.updateView = updateView;
    this.order = order;
    this.updateParentOrders = updateParentOrders;
    productCount = order.cart?.products?.length ?? 0;
    updateView();
  }

  void goBack() => Navigator.pop(context);

  Future confirmOrder() async {
    order.status = OrderStatus.despachado;
    await orderProvider.assignDelivery(order.id!, order.delivery!.id!);
    updateParentOrders();
    updateView();
  }

  Future callUser(int phoneNumber) async {
    await LaunchUrl.phoneCall(phoneNumber);
  }

  Future sendUserEmail(String email) async {
    await LaunchUrl.sendEmail(email);
  }

  Future startDelivery() async {
    orderProvider.editStatus(order.id!, OrderStatus.enCamino);
    order.status = OrderStatus.enCamino;
  }

}