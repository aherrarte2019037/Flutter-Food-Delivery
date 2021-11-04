import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/pages/restaurant/order/detail/restaurant_order_detail_controller.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/widgets/custom_fade_in_image.dart';

class RestaurantOrderDetailPage extends StatefulWidget {
  final Order order;

  const RestaurantOrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  _RestaurantOrderDetailPageState createState() => _RestaurantOrderDetailPageState();
}

class _RestaurantOrderDetailPageState extends State<RestaurantOrderDetailPage> {
  final _controller = RestaurantOrderDetailController();

  updateView() => setState(() {});

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, updateView, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      bottomNavigationBar: _assignDeliveryButton(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30, left: 42, right: 42),
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            _clientSection(),
            const SizedBox(height: 40),
            _productSection(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _controller.goBack,
              child: const Icon(Icons.arrow_back_rounded, size: 30, color: Colors.black),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(2),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 5),
                const Text(
                  'Detalle De Pedido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${_controller.productCount} ${_controller.productCount == 1 ? 'Item' : 'Items'}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFFFF8C3E),
                      ),
                    ),
                    Text(
                      ' / ${EnumToString.convertToString(_controller.order.status ?? OrderStatus.pagado, camelCase: true)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFFFF8C3E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Icon(Icons.more_horiz, size: 30, color: Colors.black),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(2),
                shadowColor: Colors.transparent,
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clientSection() {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cliente',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 68,
                width: 68,
                child: CustomFadeInImage(
                  image: _controller.order.user?.image ?? 'assets/images/loading.gif',
                  placeholder: 'assets/images/loading.gif',
                  fit: BoxFit.contain,
                  size: const Size(68, 68),
                ),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_controller.order.user?.firstName} ${_controller.order.user?.lastName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${_controller.order.user?.email}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Ink(
                decoration: ShapeDecoration(
                  color: const Color(0XFFf1f1f3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: IconButton(
                  onPressed: () => _controller.sendUserEmail(_controller.order.user?.email ?? ''),
                  constraints: const BoxConstraints(minWidth: 50, minHeight: 50, maxHeight: 50, maxWidth: 50),
                  icon: const Icon(FlutterIcons.md_mail_ion, color: Color(0XFF9896a2), size: 24),
                ),
              ),
              const SizedBox(width: 15),
              Ink(
                decoration: ShapeDecoration(
                  color: const Color(0XFFf1f1f3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: IconButton(
                  onPressed: () => _controller.callUser(0),
                  constraints: const BoxConstraints(minWidth: 50, minHeight: 50, maxHeight: 50, maxWidth: 50),
                  icon: const Icon(FlutterIcons.phone_faw, color: Color(0XFF9896a2), size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Productos',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controller.order.cart?.products?.length ?? 0,
              separatorBuilder: (_, __) => const SizedBox(height: 40),
              itemBuilder: (_, index) => _shoppingCartItem(_controller.order.cart!.products![index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shoppingCartItem(ShoppingCartItem item) {
    return Container(
      height: 130,
      child: Row(
        children: [
          Container(
            child: CustomFadeInImage(
              image: item.product.images![0],
              placeholder: 'assets/images/picture-loading.gif',
              fit: BoxFit.contain,
              size: const Size(130, 130),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.product.name.capitalize(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    'Cantidad ${item.quantity}',
                    style: const TextStyle(
                      fontSize: 13,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Q${item.product.price.toString()}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFFFF8C3E),
                ),
              ),
              Text(
                'Total Q${(item.product.price * item.quantity).toString()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF9896a2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _assignDeliveryButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: _controller.assignDelivery,
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            primary: Colors.black.withOpacity(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: const TextStyle(
              fontSize: 16.5,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Confirmar', style: TextStyle(color: Colors.white)),
              const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Icon(FlutterIcons.md_checkmark_ion, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }

}