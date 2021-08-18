import 'package:flutter/cupertino.dart';

class RoleRedirect {

  static void redirect(List roles, BuildContext context) {
    if(roles.length > 1) {
      Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);

    } else  {
      final String role = roles[0].name;
      switch (role) {
        case 'CLIENT':
          Navigator.pushNamedAndRemoveUntil(context, 'client/product/list', (route) => false);
          break;
        case 'RESTAURANT':
          Navigator.pushNamedAndRemoveUntil(context, 'restaurant/order/list', (route) => false);
          break;
        case 'DELIVERY':
          Navigator.pushNamedAndRemoveUntil(context, 'delivery/order/list', (route) => false);
          break;  
      }
    }
  }

  static String getInitialRoute(user) {
    if(user == false) return 'login';
    if(user?['roles'].length > 1) return 'roles';
    if(user?['roles'][0]['name'] == 'CLIENT') return 'client/product/list';
    if(user?['roles'][0]['name'] == 'RESTAURANT') return 'restaurant/order/list';
    if(user?['roles'][0]['name'] == 'DELIVERY') return 'delivery/order/list';

    return 'login';
  }

}