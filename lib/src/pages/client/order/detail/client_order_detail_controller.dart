import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/order_provider.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/utils/launch_url.dart';
import 'package:food_delivery/src/widgets/order_tracker/order_tracker_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientOrderDetailController {
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

  Future<void> callUser(int phoneNumber) async {
    await LaunchUrl.phoneCall(phoneNumber);
  }

  Future<void> sendUserEmail(String email) async {
    await LaunchUrl.sendEmail(email);
  }

  Future<void> startDelivery() async {
    order.status = OrderStatus.enCamino;

    User? user = await userProvider.getProfile();
    if (user == null) return;

    showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => OrderTracker(order: order, currentRoles: user.roles ?? []),
    );
    await orderProvider.editStatus(order.id!, OrderStatus.enCamino);
    
    updateParentOrders();
    updateView();
  }

  Future<void> goToOrderTracker() async {
    User? user = await userProvider.getProfile();
    if (user == null) return;

    showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => OrderTracker(order: order, currentRoles: user.roles ?? []),
    );
  }

}