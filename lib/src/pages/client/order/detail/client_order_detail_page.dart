import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/client/order/detail/client_order_detail_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/widgets/custom_fade_in_image.dart';

class ClientOrderDetailPage extends StatefulWidget {
  final Order order;
  final Function updateParentOrders;

  const ClientOrderDetailPage({Key? key, required this.order, required this.updateParentOrders}) : super(key: key);

  @override
  _ClientOrderDetailPageState createState() => _ClientOrderDetailPageState();
}

class _ClientOrderDetailPageState extends State<ClientOrderDetailPage> {
  final _controller = ClientOrderDetailController();

  void updateView() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, updateView, widget.updateParentOrders, widget.order);
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
      bottomNavigationBar: _totalSection(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 20, left: 42, right: 42),
        height: height,
        width: width,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              _detailSection(),
              const SizedBox(height: 40),
              if (_controller.order.status != OrderStatus.pagado) _deliverytSection(),
              _productSection(),
            ],
          ),
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

  Widget _detailSection() {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.only(bottom: 1, right: 1),
            decoration: BoxDecoration(
              color: const Color(0XFFFF8C3E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const IconButton(
              onPressed: null,
              icon: Icon(FlutterIcons.location_arrow_faw, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            _controller.order.address?.address ?? '',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Detalles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Referencias',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFFA2A2A2),
                ),
              ),
              Text(
                _controller.order.address?.references?.capitalize() ?? 'No hay referencias',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pedido realizado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFFA2A2A2),
                ),
              ),
              Text(
                timeago.format(_controller.order.createdAt ?? DateTime(0)).capitalize(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFFA2A2A2),
                ),
              ),
              Text(
                EnumToString.convertToString(_controller.order.status ?? OrderStatus.enCamino, camelCase: true),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ); 
  }

  Widget _deliverytSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            child: CustomFadeInImage(
                              image: _controller.order.delivery?.image ?? 'assets/images/loading.gif',
                              placeholder: 'assets/images/loading.gif',
                              fit: BoxFit.contain,
                              size: const Size(55, 55),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 27,
                              height: 27,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_controller.order.delivery?.firstName} ${_controller.order.delivery?.lastName}',
                              style: const TextStyle(
                                color: Color(0XFF303030),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${_controller.order.delivery?.email}',
                              style: const TextStyle(
                                color: Color(0XFF303030),
                                fontWeight: FontWeight.w400,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 45,
                        height: 45,
                        padding: const EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: () => _controller.sendUserEmail(_controller.order.delivery?.email ?? ''),
                          icon: const Icon(FlutterIcons.md_mail_ion, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Container(
                        width: 45,
                        height: 45,
                        padding: const EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: () => _controller .sendUserEmail(_controller.order.delivery?.email ?? ''),
                          icon: const Icon(FlutterIcons.phone_faw, color: Colors.white, size: 21.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Productos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _controller.order.cart?.products?.length ?? 0,
          separatorBuilder: (_, __) => const SizedBox(height: 25),
          itemBuilder: (_, index) => _shoppingCartItem(_controller.order.cart!.products![index]),
        ),        
      ],
    );
  }

  Widget _shoppingCartItem(ShoppingCartItem item) {
    return Container(
      height: 110,
      child: Row(
        children: [
          Container(
            child: CustomFadeInImage(
              image: item.product.images![0],
              placeholder: 'assets/images/picture-loading.gif',
              fit: BoxFit.contain,
              size: const Size(110, 110),
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20,
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
                  fontWeight: FontWeight.w400,
                  color: Color(0XFFA2A2A2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _goToOrderTrackerButton() {
    return Container(
      width: 185,
      height: 60,
      child: ElevatedButton(
        onPressed: _controller.goToOrderTracker,
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 28),
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
            const Text('Ver Mapa', style: TextStyle(color: Colors.white)),
            const Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(Icons.map_rounded, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, left: 42, right: 42, top: 10),
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Q${_controller.order.cart?.total}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                const Text(
                  'Descuento 0% (Q0)',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFFA2A2A2)),
                ),
              ],
            ),
            if (_controller.order.status == OrderStatus.enCamino) _goToOrderTrackerButton(),
          ],
        ),
      ),
    );
  }

}