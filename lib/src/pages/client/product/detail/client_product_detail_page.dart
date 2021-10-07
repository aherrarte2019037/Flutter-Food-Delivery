import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/pages/client/product/detail/client_product_detail_controller.dart';

class ClientProductDetailPage extends StatefulWidget {
  final Product product;

  ClientProductDetailPage({ required this.product });

  @override
  _ClientProductDetailPageState createState() => _ClientProductDetailPageState();
}

class _ClientProductDetailPageState extends State<ClientProductDetailPage> {
  final ClientProductDetailController _controller = ClientProductDetailController();

  updateView() {
    setState(() => {});
  }

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, updateView, widget.product);
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
      bottomNavigationBar: _addToCartButton(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 10),
        height: height,
        width: width,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  _imageCarousel(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _quantityButton(),
                          const SizedBox(height: 50),
                          _nameSection(),
                          const SizedBox(height: 25),
                          _chipsSection(),
                          const SizedBox(height: 35),
                          _descriptionSection()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
            const Text(
              'Detalles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Icon(FlutterIcons.heart_faw5, size: 20, color: Color(0XFFFF6565)),
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

  Widget _imageCarousel() {
    return Container(
      height: 225,
      child: Column(
        children: [
          if (_controller.product.images!.isNotEmpty)
            CarouselSlider.builder(
              itemCount: _controller.product.images!.length,
              itemBuilder: (_, index, __) => _imageCarouselItem(_controller.product.images![index]),
              options: CarouselOptions(
                height: 220,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, _) => _controller.setActualCarouselIndex(index),
              ),
            ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _controller.product.images!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (_, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _controller.actualCarouselIndex == index ? 18 : 6,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _controller.actualCarouselIndex == index
                      ? const Color(0XFFFF8C3E)
                      : Colors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageCarouselItem(String image) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: image.contains('assets')
        ? Image.asset(
            image,
            fit: BoxFit.cover,
          )
        : FadeInImage.assetNetwork(
            height: 20,
            width: 20,
            image: image,
            placeholder: 'assets/images/picture-loading.gif',
            fit: BoxFit.contain,
          ),
    );
  }

  Widget _quantityButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(6, 0),
          child: ElevatedButton(
            onPressed: _controller.increaseProductQuantity,
            child: const Icon(Icons.add_rounded, size: 24, color: Colors.white),
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              minimumSize: const Size(45, 45),
              padding: const EdgeInsets.only(left: 8, bottom: 1),
              elevation: 0,
              primary: const Color(0XFFFF8C3E),
              onPrimary: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: ZoomIn(
            from: 1,
            manualTrigger: true,
            duration: const Duration(milliseconds: 300),
            controller: (controller) => _controller.productQuantityController = controller,
            child: Text(
              _controller.productQuantity.toString(),
              style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.all(0),
            fixedSize: const Size(40, 45),
            minimumSize: const Size(40, 45),
            elevation: 0,
            primary: const Color(0XFFFF8C3E),
            onPrimary: const Color(0XFFFF8C3E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
        ),
        Transform.translate(
          offset: const Offset(-6, 0),
          child: ElevatedButton(
            onPressed: _controller.decreaseProductQuantity,
            child: const Icon(Icons.remove_rounded, size: 24, color: Colors.white),
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              minimumSize: const Size(45, 45),
              padding: const EdgeInsets.only(right: 8, bottom: 1),
              elevation: 0,
              primary: const Color(0XFFFF8C3E),
              onPrimary: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _nameSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _controller.product.name,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.9),
              ),
            ),
            if (_controller.isProductPurchased['purchased'] == true)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -1),
                    child: const Icon(
                      FlutterIcons.shopping_cart_fea,
                      size: 17,
                      color: Color(0XFF8F8F8F),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      '${_controller.isProductPurchased['product'].quantity} en el carrito',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF8F8F8F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 3.5, top: 3.5),
              child: Text(
                'Q',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFFFE9B57),
                ),
              ),
            ),
            ZoomIn(
              from: 1,
              manualTrigger: true,
              duration: const Duration(milliseconds: 300),
              controller: (controller) => _controller.productPriceController = controller,
              child: Text(
                (_controller.product.price * _controller.productQuantity).toString(),
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _chipsSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -1.4),
                    child: const Icon(
                      FlutterIcons.fire_faw5s,
                      color: Color(0XFFFF8C3E),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${_controller.product.calories.toString()} Cal',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(FlutterIcons.md_restaurant_ion, color: Colors.redAccent, size: 23),
                  const SizedBox(width: 7),
                  Text(
                    _controller.product.category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 9.5, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -1),
                    child: Icon(
                      _controller.product.available! ? FlutterIcons.md_checkmark_circle_ion : FlutterIcons.md_close_circle_ion,
                      color: _controller.product.available! ? Colors.greenAccent : Colors.redAccent,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _controller.product.available! ? 'Disponible' : 'No Disponible',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _descriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 15),
        Text(
          '${_controller.product.description}.',
          style: const TextStyle(fontSize: 16, color: Color(0XFF7A7A7A)),
        ),
      ],
    );
  }

  Widget _addToCartButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42),
      child: Container(
        height: 60,
        child: Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _controller.product.available! ? _controller.addToCart : () {},
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 185,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _controller.product.available! ? 'Añadir al carrito' : 'No disponible',
                    style: const TextStyle(color: Colors.white, letterSpacing: 0.64),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Icon(
                      _controller.product.available! ? FlutterIcons.shopping_cart_fea : FlutterIcons.ban_sli,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}