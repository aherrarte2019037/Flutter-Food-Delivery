import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/order_provider.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/utils/launch_url.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/widgets/custom_fade_in_image.dart';

class RestaurantOrderDetailController {
  late BuildContext context;
  late Function updateView;
  late Function updateParentOrders;
  late Function openDeliveryDialog;
  UserProvider userProvider = UserProvider();
  OrderProvider orderProvider = OrderProvider();
  Map<dynamic, List<ShoppingCartItem>> productsByCategory = {};
  List<DropdownMenuItem> deliveryUserItems = [];
  List<User> deliveryUsers = [];
  User? deliveryy; 
  Order order = Order();
  int productCount = 0;

  void init(BuildContext context, Function updateView, Function updateParentOrders, Order order) async {
    this.context = context;
    this.updateView = updateView;
    this.order = order;
    this.updateParentOrders = updateParentOrders;
    productCount = order.cart?.products?.length ?? 0;
    await setDeliveryUserItems();
    updateView();
  }

  void goBack() => Navigator.pop(context);
  
  void dropDownOnChanged(String value) {
    order.delivery = deliveryUsers.firstWhere((user) => user.id == value); 
    updateView();
  }

  Future setDeliveryUserItems() async {
    deliveryUsers = await userProvider.getByRole('DELIVERY');
    deliveryUserItems = (deliveryUsers).map(
      (user) => DropdownMenuItem(
        child: Row(
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: CustomFadeInImage(
                image: user.image ?? 'assets/images/loading.gif',
                placeholder: 'assets/images/loading.gif',
                fit: BoxFit.contain,
                size: const Size(45, 45),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName.capitalize()} ${user.lastName.capitalize()}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5)),
                ),
              ],
            )
          ],
        ),
        value: user.id,
      ),
    ).toList();
  }

  void assignDelivery() => openDeliveryDialog('');

  Future confirmOrder() async {
    order.status = OrderStatus.despachado;
    await orderProvider.assignDelivery(order.id!, order.delivery!.id!);
    updateParentOrders();
    updateView();
  }

  Future callUser(int phoneNumber) async {
    await LaunchUrl.phoneCall(phoneNumber);
  }

  Future sendUserEmail(String email) async {
    await LaunchUrl.sendEmail(email);
  }

}