import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/utils/current_user_role.dart';

class RoleRedirect {

  static void redirect(List roles, BuildContext context) {
    if(roles.length > 1) {
      Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);

    } else  {
      final String role = roles[0].name;
      switch (role) {
        case 'CLIENT':
          CurrentUserRole.setCurrentRole('CLIENT');
          Navigator.pushNamedAndRemoveUntil(context, 'client/product/list', (route) => false);
          break;
          
        case 'RESTAURANT':
          CurrentUserRole.setCurrentRole('RESTAURANT');
          Navigator.pushNamedAndRemoveUntil(context, 'restaurant/order/list', (route) => false);
          break;

        case 'DELIVERY':
          CurrentUserRole.setCurrentRole('DELIVERY');
          Navigator.pushNamedAndRemoveUntil(context, 'delivery/order/list', (route) => false);
          break;  
      }
    }
  }

  static String getInitialRoute(user) {
    if(user == false) return 'login';
    if(user?['roles'].length > 1) return 'roles';

    switch (user?['roles'][0]['name']) {
      case 'CLIENT':
        CurrentUserRole.setCurrentRole('CLIENT');
        return 'client/product/list';

      case 'RESTAURANT':
        CurrentUserRole.setCurrentRole('RESTAURANT');
        return 'restaurant/order/list';

      case 'DELIVERY':
        CurrentUserRole.setCurrentRole('DELIVERY');
        return 'delivery/order/list';  

      default: return 'login';
    }
  }

}