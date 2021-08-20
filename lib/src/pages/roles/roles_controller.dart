import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/role_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';

class RolesController {
  late BuildContext context;

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<dynamic> getUserRoles() async {
    User user = User.fromJson(await SharedPref.read('user'));
    return user.roles;
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

}
