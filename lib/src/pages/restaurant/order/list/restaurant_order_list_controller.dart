import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/user_provider.dart';

class RestaurantOrderListController {
  late Function updateView;
  late BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  UserProvider userProvider = UserProvider();
  User? user;

  void init(BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView = updateView;
    user = await userProvider.getProfile();
    updateView();
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

}