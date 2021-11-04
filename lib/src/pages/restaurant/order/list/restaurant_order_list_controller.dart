import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
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
  Map<String, List<Order>> ordersGrouped = {};
  Map<OrderStatus, String> statusImages = {
    OrderStatus.pagado    : 'assets/images/paid-icon.png',
    OrderStatus.despachado: 'assets/images/product-category-image.png',
    OrderStatus.enCamino  : 'assets/images/location-icon.png',
    OrderStatus.entregado : 'assets/images/delivered-icon.png',
  };
  Map<OrderStatus, Icon> statusIcons = {
    OrderStatus.pagado    : const Icon(FlutterIcons.md_card_ion, size: 24, color: Color(0XFF50C254)),
    OrderStatus.despachado: const Icon(FlutterIcons.md_card_ion, size: 24, color: Colors.blueAccent),
    OrderStatus.enCamino  : const Icon(FlutterIcons.md_card_ion, size: 24, color: Colors.deepPurpleAccent),
    OrderStatus.entregado : const Icon(FlutterIcons.md_card_ion, size: 24, color: Colors.orangeAccent),
  };
  Map<OrderStatus, Color> statusColors = {
    OrderStatus.pagado    : const Color(0XFF50C254),
    OrderStatus.despachado: Colors.blueAccent,
    OrderStatus.enCamino  : Colors.deepPurpleAccent,
    OrderStatus.entregado : Colors.orangeAccent,
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

    ordersGrouped = await orderProvider.getOrdersGroupedByStatus();
    List<String> status = ordersGrouped.keys.toList();
    
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

  void scrollToStatus(OrderStatus status) {
    int index = ordersGrouped.keys.toList().indexWhere(
      (element) => element.toLowerCase() == EnumToString.convertToString(status).toLowerCase()
    );
    scrollController.animateTo(
      (index + 1) * 260,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void showOrderDetailModal(Order order) {

  }

}