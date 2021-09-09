import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/client/product/list/client_product_list_page.dart';
import 'package:food_delivery/src/pages/delivery/order/list/delivery_order_list_page.dart';
import 'package:food_delivery/src/pages/login/login_page.dart';
import 'package:food_delivery/src/pages/profile/profile_page.dart';
import 'package:food_delivery/src/pages/register/register_page.dart';
import 'package:food_delivery/src/pages/restaurant/category/create/restaurant_category_create_page.dart';
import 'package:food_delivery/src/pages/restaurant/order/list/restaurant_order_list_page.dart';
import 'package:food_delivery/src/pages/restaurant/product/create/restaurant_product_create_page.dart';
import 'package:food_delivery/src/pages/roles/roles_page.dart';
import 'package:food_delivery/src/utils/role_redirect.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:food_delivery/src/utils/theme_colors.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeago.setLocaleMessages('es', timeago.EsMessages());
  timeago.setDefaultLocale('es');

  final dynamic user = await SharedPref.read('user');
  await SharedPref.setAuthToken();

  String initialRoute = RoleRedirect.getInitialRoute(user);
  runApp(MainApp(initialRoute));
}

class MainApp extends StatefulWidget {
  final String initialRoute;

  MainApp(this.initialRoute);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: ThemeColors.primaryColor),
      title: 'Chicken Delivery',
      initialRoute: widget.initialRoute,
      routes: {
        'login': (BuildContext context) => const LoginPage(),
        'register': (BuildContext context) => const RegisterPage(),
        'roles': (BuildContext context) => const RolesPage(),
        'profile': (BuildContext context) => const ProfilePage(),
        'client/product/list': (BuildContext context) => const ClientProductListPage(),
        'restaurant/order/list': (BuildContext context) => const RestaurantOrderListPage(),
        'restaurant/category/create': (BuildContext context) => const RestaurantCategoryCreatePage(),
        'restaurant/product/create': (BuildContext context) => const RestaurantProductCreatePage(),
        'delivery/order/list': (BuildContext context) => const DeliveryOrderListPage(),
      },
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(450, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
    );
  }
}
