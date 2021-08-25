import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class ClientProductListController {
  late BuildContext context;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  void init(BuildContext context) {
    this.context = context;
  }

  Future<dynamic> getUser() async {
    User user = User.fromJson(await SharedPref.read('user'));
    return user;
  }

  void logOut() {
    SharedPref.logOut();
    Future.delayed(const Duration(milliseconds: 180), () {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    });
  }

  void openDrawer() {
    drawerKey.currentState!.openDrawer();
  }

}