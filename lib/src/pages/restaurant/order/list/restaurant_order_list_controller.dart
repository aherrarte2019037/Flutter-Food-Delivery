import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/order_provider.dart';
import 'package:food_delivery/src/providers/user_provider.dart';

class RestaurantOrderListController {
  late Function updateView;
  late BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  UserProvider userProvider = UserProvider();
  OrderProvider orderProvider = OrderProvider();
  Map<String, List<Order>> ordersGroupedByStatus = {};
  Map<OrderStatus, String> statusImages = {
    OrderStatus.pagado    : 'assets/images/paid-icon.png',
    OrderStatus.despachado: 'assets/images/product-category-image.png',
    OrderStatus.enCamino  : 'assets/images/location-icon.png',
    OrderStatus.entregado : 'assets/images/delivered-icon.png',
  };
  List<String> statusList = [];
  bool orderStatusChipsIsLoading = false;
  GlobalKey<AnimatedListState> orderStatusListKey = GlobalKey();
  User? user;

  void init(BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView = updateView;
    user = await userProvider.getProfile();
    await addOrdersToList();
  }

  Future addOrdersToList() async {
    orderStatusChipsIsLoading = true;
    updateView();

    ordersGroupedByStatus = await orderProvider.getOrdersGroupedByStatus();
    List<String> status = ordersGroupedByStatus.keys.toList();
    
    orderStatusChipsIsLoading = false;
    updateView();

    for (var i = 0; i < status.length; i++) {
      Future.delayed(Duration(milliseconds: i * 400), () {
        statusList.add(status[i]);
        orderStatusListKey.currentState?.insertItem(statusList.length - 1);
      });
    }
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

}