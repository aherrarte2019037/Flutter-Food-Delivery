import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class UserDrawerController {
  late BuildContext context;
  List<Map> clientDrawerItems = [
    { 'title': 'Perfil', 'icon': FlutterIcons.md_person_ion, 'route': 'profile' },
    { 'title': 'Compras', 'icon': FlutterIcons.shopping_cart_fea },
    { 'title': 'Ajustes', 'icon': FlutterIcons.setting_ant },
    { 'title': 'Notificaciones', 'icon': FlutterIcons.bell_mco }
  ];
  List<Map> restaurantDrawerItems = [
    {
      'title': 'Perfil',
      'icon': FlutterIcons.md_person_ion,
      'route': 'profile',
    },
    {
      'title': 'Crear Categoría',
      'icon': FlutterIcons.layers_fea,
      'route': 'restaurant/category/create'
    },
    {
      'title': 'Crear Producto',
      'icon': Icons.fastfood_rounded,
      'route': 'restaurant/product/create'
    },
    {
      'title': 'Ajustes',
      'icon': FlutterIcons.setting_ant,
    },
    {
      'title': 'Notificaciones',
      'icon': FlutterIcons.bell_mco,
    }
  ];
  List<Map> deliveryDrawerItems = [
    { 'title': 'Perfil', 'icon': FlutterIcons.md_person_ion, 'route': 'profile' },
    { 'title': 'Pedidos', 'icon': FlutterIcons.shopping_bag_ent },
    { 'title': 'Ajustes', 'icon': FlutterIcons.setting_ant },
    { 'title': 'Notificaciones', 'icon': FlutterIcons.bell_mco },
  ];

  void init(BuildContext context) async {
    this.context = context;
  }

  Future<dynamic> getUser() async {
    User user = User.fromJson(await SharedPref.read('user'));
    return user;
  }
  
  List<Map> getDrawerItems(User user, String drawerType) {
    if(drawerType == 'CLIENT') return clientDrawerItems;
    if(drawerType == 'RESTAURANT') return restaurantDrawerItems;
    if(drawerType == 'DELIVERY') return deliveryDrawerItems;

    return [];
  }

  void drawerItemNavigate(String route) {
    Future.delayed(const Duration(milliseconds: 140), () {
      Navigator.popAndPushNamed(context, route);
    });
  }

}