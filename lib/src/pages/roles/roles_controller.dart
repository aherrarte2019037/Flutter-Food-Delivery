import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/role_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class RolesController {
  late BuildContext context;
  static Map buttonsSelected = {
    'CLIENT'    : false,
    'RESTAURANT': false,
    'DELIVERY'  : false
  };

  void init(BuildContext context) async{
    this.context = context;
    await SharedPref.logOut();
  }

  Future<dynamic> getUser() async {
    User user = User.fromJson(await SharedPref.read('user'));
    return user;
  }

  void goToSelectedPage() {
    late String route;
    if(buttonsSelected['CLIENT']) route = 'client/product/list';
    if(buttonsSelected['RESTAURANT']) route = 'restaurant/order/list';
    if(buttonsSelected['DELIVERY']) route = 'delivery/order/list';
    Navigator.pushNamed(context, route);
  }

  void logOut() {
    SharedPref.logOut();
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  static String getRolesFormated(User user) {
    String roles = '';

    for (var i = 0; i < user.roles!.length; i++) {
      if(user.roles![i].name == 'CLIENT') roles = roles + 'Cliente • ';
      if(user.roles![i].name == 'RESTAURANT') roles = roles + 'Restaurante • ';
      if(user.roles![i].name == 'DELIVERY') roles = roles + 'Repartidor • ';
    }

    return roles.substring(0, roles.length - 2);
  }

  static String getTextRoleByRole(Role role) {
    switch (role.name) {
      case 'CLIENT':
        return 'Cliente';

      case 'RESTAURANT':
        return 'Restaurante';

      case 'DELIVERY':
        return 'Repartidor';

      default:
        return '';
    }
  }

  static Map<String, Color> getColorsByRole(Role role) {
    switch (role.name) {
      case 'CLIENT':
        return {
          'lightColor': const Color(0XFF39CBDE),
          'darkColor': const Color(0XFF12A6B9)
        };

      case 'RESTAURANT':
        return {
          'lightColor': const Color(0XFF879EF3),
          'darkColor': const Color(0XFF5D78D4)
        };

      case 'DELIVERY':
        return {
          'lightColor': const Color(0XFF39B4DE),
          'darkColor': const Color(0XFF1294C3)
        };

      default:
        return {};
    }
  }

  static List getIconsByRole(Role role) {
    switch (role.name) {
      case 'CLIENT':
        return [
          Icons.shopping_cart,
          FlutterIcons.attach_money_mdi,
          FlutterIcons.credit_card_mdi,
          FlutterIcons.person_mdi
        ];

      case 'RESTAURANT':
        return [
          Icons.restaurant_menu,
          FlutterIcons.chart_donut_mco,
          FlutterIcons.ios_build_ion,
          FlutterIcons.food_variant_mco
        ];

      case 'DELIVERY':
        return [
          Icons.restaurant_menu,
          FlutterIcons.chart_donut_mco,
          FlutterIcons.ios_build_ion,
          FlutterIcons.food_variant_mco
        ];

      default:
        return [
          Icons.delivery_dining,
          FlutterIcons.ios_alarm_ion,
          FlutterIcons.pin_ent,
          FlutterIcons.shopping_bag_ent
        ];
    }
  }

  static selectButton(Role role) {
    buttonsSelected[role.name] = true;

    buttonsSelected.forEach((key, value) {
      if(key == role.name) return;
      buttonsSelected[key] = false;
    });
  }

  static defaultButtonSelected(List<Role> roles) {
    buttonsSelected.update(roles[0].name, (value) => true);
  }

}
