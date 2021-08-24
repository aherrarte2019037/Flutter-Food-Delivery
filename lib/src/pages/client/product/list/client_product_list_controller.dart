import 'package:flutter/material.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class ClientProductListController {
  late BuildContext context;

  void init(BuildContext context) {
    this.context = context;
  }

  void logOut() {
    SharedPref.logOut();
    Future.delayed(const Duration(milliseconds: 180), () {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    });
  }

}