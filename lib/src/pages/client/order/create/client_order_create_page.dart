import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';
import 'package:food_delivery/src/pages/client/order/create/client_order_create_controller.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/widgets/custom_fade_in_image.dart';

class ClientOrderCreatePage extends StatefulWidget {
  const ClientOrderCreatePage({Key? key}) : super(key: key);

  @override
  _ClientOrderCreatePageState createState() => _ClientOrderCreatePageState();
}

class _ClientOrderCreatePageState extends State<ClientOrderCreatePage> {
  final _controller = ClientOrderCreateController();

  updateView() => setState(() => {});

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, updateView);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      bottomNavigationBar: _goToAddressList(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30, left: 42, right: 42),
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Expanded(
              child: _controller.productsByCategory.keys.isNotEmpty
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _controller.productsByCategory.keys.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 40),
                    itemBuilder: (_, categoryIndex) {
                      String category = _controller.productsByCategory.keys.toList()[categoryIndex];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.capitalize(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedList(
                            key: _controller.animatedListKeys[category],
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            initialItemCount: _controller.productsByCategory[category]!.length,
                            itemBuilder: (_, itemIndex, animation) => Container(
                              margin: EdgeInsets.only(top: itemIndex == 0 ? 0 : 30 ),
                              child: _shoppingCartItem(
                                item: _controller.productsByCategory.values.toList()[categoryIndex][itemIndex],
                                animation: animation,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : _emptyShoppingCart(),
            ),
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
                  'Mi Carrito',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${_controller.getItemsCount()} ${_controller.getItemsCount() == 1 ? 'item': 'items'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFFFF8C3E),
                  ),
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

  Widget _emptyShoppingCart() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 220,
            child: Image.asset(
              'assets/images/empty-cart.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Tu carrito esta vacío',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0XFF0C0C0C)),
          ),
        ],
      ),
    );
  }

  Widget _shoppingCartItem({required ShoppingCartItem item, required Animation<double> animation}) {
    return SlideTransition(
      position: Tween(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: Container(
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
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    item.product.name.capitalize(),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ZoomIn(
                    from: 1,
                  manualTrigger: true,
                  duration: const Duration(milliseconds: 300),
                  controller: (controller) => _controller.priceControllers[item.product.id!] = controller,
                    child: Text(
                      'Q${(item.product.price * item.quantity).toString()}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFFFF8C3E),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _quantityButton(item),
                        _deleteProductButton(item)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton(ShoppingCartItem item) {
    return Transform.translate(
      offset: const Offset(-7, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: const Offset(6, 0),
            child: ElevatedButton(
              onPressed: () => _controller.addItem(item.product),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                minimumSize: const Size(42, 42),
                padding: const EdgeInsets.all(0),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(width: 1.5, color: Color(0XFFD3D3D3)),
                ),
              ),
              child: const Icon(Icons.add_rounded, size: 24, color: Color(0XFFACAAB5)),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              fixedSize: const Size(40, 40),
              minimumSize: const Size(40, 40),
              elevation: 0,
              primary: Colors.white,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            ),
            child: ZoomIn(
              from: 1,
              manualTrigger: true,
              duration: const Duration(milliseconds: 300),
              controller: (controller) => _controller.quantityControllers[item.product.id!] = controller,
              child: Text(
                item.quantity.toString(),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Color(0XFF9896a2)),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-6, 0),
            child: ElevatedButton(
              onPressed: () => _controller.removeItem(item.product),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                minimumSize: const Size(42, 42),
                padding: const EdgeInsets.all(0),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(width: 1.5, color: Color(0XFFD3D3D3)),
                ),
              ),
              child: const Icon(Icons.remove_rounded, size: 24, color: Color(0XFFACAAB5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deleteProductButton(ShoppingCartItem item) {
    return Ink(
      decoration: ShapeDecoration(
        color: const Color(0XFFf1f1f3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: IconButton(
        onPressed: () => _controller.deleteProduct(item: item, buildWidget: _shoppingCartItem),
        constraints: const BoxConstraints(minWidth: 45, minHeight: 45, maxHeight: 45, maxWidth: 45),
        padding: const EdgeInsets.only(bottom: 3),
        icon: const Icon(FlutterIcons.md_trash_ion, color: Color(0XFF9896a2), size: 22),
      ),
    );
  }

  Widget _goToAddressList() {
    return _controller.productsByCategory.keys.isNotEmpty
      ? Padding(
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
                  ZoomIn(
                    from: 1,
                    manualTrigger: true,
                    duration: const Duration(milliseconds: 300),
                    controller: (controller) => _controller.totalController = controller,
                    child: Text(
                      'Q${_controller.shoppingCart.total}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Descuento 0% (Q0)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0XFF999999)),
              ),
              const SizedBox(height: 30),
              Container(
                height: 60,
                child: ElevatedButton(
                  onPressed: _controller.goToAddressList,
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
                      const Text('Confirmar orden', style: TextStyle(color: Colors.white)),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: Icon(FlutterIcons.md_checkmark_ion, size: 28),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      : const SizedBox.shrink();
  }

}