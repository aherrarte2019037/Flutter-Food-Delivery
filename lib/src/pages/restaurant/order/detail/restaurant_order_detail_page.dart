import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/pages/restaurant/order/detail/restaurant_order_detail_controller.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/widgets/custom_fade_in_image.dart';
import 'package:search_choices/search_choices.dart';

class RestaurantOrderDetailPage extends StatefulWidget {
  final Order order;
  final Function updateParentOrders;

  const RestaurantOrderDetailPage({Key? key, required this.order, required this.updateParentOrders}) : super(key: key);

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
              _dropDownDelivery(),
              const SizedBox(height: 25),
              _detailSection(),
              const SizedBox(height: 40),
              if (_controller.order.delivery != null) _deliverySection(),
              _clientSection(),
              const SizedBox(height: 40),
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

  Widget _dropDownDelivery() {
    return Container(
      width: 0,
      height: 0,
      child: SearchChoices.single(
        underline: Container(
          height: 0,
        ),
        buildDropDownDialog: (titleBar, searchBar, list, closeButton, dropDownContext) {
          return Card(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.085,
              vertical: MediaQuery.of(context).size.height * 0.30,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.only(top: 40, bottom: 13, left: 40, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleBar,
                  searchBar,
                  const SizedBox(height: 15),
                  Transform.scale(
                    scale: 0.92,
                    child: SizedBox(
                      height: 145,
                      child: Column(
                        children: [
                          list,
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.modulate),
                    child: Transform.scale(
                      scale: 0.9,
                      child: Transform.translate(
                        offset: const Offset(22, 0),
                        child: closeButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        closeButton: 'Cerrar',
        searchInputDecoration: InputDecoration(
          filled: true,
          fillColor: const Color(0XFFe7e7e7),
          suffixIcon: null,
          hintText: 'Buscar',
          hintStyle: const TextStyle(color: Color(0XFF79899b)),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 0.5),
            child: Icon(FlutterIcons.search1_ant, size: 20, color: Colors.blueGrey),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        searchFn: (String keyword, items) {
          List<int> results = [];
          if (items != null && keyword.isNotEmpty) {
            keyword.split(" ").forEach((k) {
              int i = 0;
              items.forEach((item) {
                if (!results.contains(i) &&
                    k.isNotEmpty &&
                    (item.value
                        .toString()
                        .toLowerCase()
                        .contains(k.toLowerCase()))) {
                  results.add(i);
                }
                i++;
              });
            });
          }
          if (keyword.isEmpty) {
            results = Iterable<int>.generate(items.length).toList();
          }
          return (results);
        },
        emptyListWidget: const Padding(
          padding: EdgeInsets.only(top: 12, left: 6),
          child: Text('No hay resultados', style: TextStyle(fontSize: 17)),
        ),
        items: _controller.deliveryUserItems,
        icon: null,
        autofocus: false,
        setOpenDialog: (openDialog) {
          _controller.openDeliveryDialog = openDialog;
        },
        value: _controller.order.id ?? '',
        onChanged: (String value) => _controller.dropDownOnChanged(value),
        dialogBox: true,
        isExpanded: true,
        displayClearIcon: false,
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
            child: IconButton(
              onPressed: () {},
              icon: const Icon(FlutterIcons.location_arrow_faw, color: Colors.white, size: 28),
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
                EnumToString.convertToString(_controller.order.status ?? OrderStatus.pagado, camelCase: true),
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
                'Latitud',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFFA2A2A2),
                ),
              ),
              Text(
                _controller.order.address?.latitude.toStringAsFixed(6) ?? '',
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
                'Longitud',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFFA2A2A2),
                ),
              ),
              Text(
                _controller.order.address?.longitude.toStringAsFixed(6) ?? '',
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

  Widget _deliverySection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _controller.assignDelivery,
            child: Container(
              width: 146,
              child: Row(
                children: [
                  const Text(
                    'Repartidor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (_controller.order.status == OrderStatus.pagado)
                  Transform.translate(
                    offset: const Offset(-6, -0.5),
                    child: IconButton(
                      onPressed: _controller.assignDelivery,
                      icon: const Icon(FlutterIcons.md_refresh_ion, color: Colors.black, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: _controller.order.status == OrderStatus.pagado ? 7 : 15 ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 55,
                width: 55,
                child: CustomFadeInImage(
                  image: _controller.order.user?.image ?? 'assets/images/loading.gif',
                  placeholder: 'assets/images/loading.gif',
                  fit: BoxFit.contain,
                  size: const Size(55, 55),
                ),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_controller.order.delivery?.firstName} ${_controller.order.delivery?.lastName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${_controller.order.delivery?.email}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  color: const Color(0XFFf1f1f3),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () => _controller.sendUserEmail(_controller.order.delivery?.email ?? ''),
                  icon: const Icon(FlutterIcons.md_mail_ion, color: Color(0XFF9896a2), size: 24),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(top: 1, left: 1),
                decoration: BoxDecoration(
                  color: const Color(0XFFf1f1f3),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () => _controller.sendUserEmail(_controller.order.delivery?.email ?? ''),
                  icon: const Icon(FlutterIcons.phone_faw, color: Color(0XFF9896a2), size: 25),
                ),
              ),
            ],
          ),
        ],
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
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 55,
                width: 55,
                child: CustomFadeInImage(
                  image: _controller.order.user?.image ?? 'assets/images/loading.gif',
                  placeholder: 'assets/images/loading.gif',
                  fit: BoxFit.contain,
                  size: const Size(55, 55),
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
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  color: const Color(0XFFf1f1f3),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () => _controller.sendUserEmail(_controller.order.user?.email ?? ''),
                  icon: const Icon(FlutterIcons.md_mail_ion, color: Color(0XFF9896a2), size: 24),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(top: 1, left: 1),
                decoration: BoxDecoration(
                  color: const Color(0XFFf1f1f3),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () => _controller.sendUserEmail(_controller.order.user?.email ?? ''),
                  icon: const Icon(FlutterIcons.phone_faw, color: Color(0XFF9896a2), size: 25),
                ),
              ),
            ],
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

  Widget _confirmButton() {
    return AnimatedContainer(
      duration: const Duration(seconds: 4),
      height: _controller.order.delivery != null && _controller.order.status == OrderStatus.pagado ? 60 : 0,
      child: ElevatedButton(
        onPressed: _controller.confirmOrder,
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
            const Text('Despachar Pedido', style: TextStyle(color: Colors.white)),
            const Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(FlutterIcons.md_checkmark_ion, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _assignDeliveryButton() {
    return Container(
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
            const Text('Asignar Repartidor', style: TextStyle(color: Colors.white)),
            const Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(Icons.delivery_dining_rounded, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42),
      child: Column(
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
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Descuento 0% (Q0)',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0XFFA2A2A2)),
          ),
          if (_controller.order.status == OrderStatus.pagado) const SizedBox(height: 20),
          if (_controller.order.delivery == null && _controller.order.status == OrderStatus.pagado) _assignDeliveryButton(),
          _confirmButton()
        ],
      ),
    );
  }

}