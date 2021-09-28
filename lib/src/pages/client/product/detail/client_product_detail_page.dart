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
      bottomNavigationBar: _bottomSection(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        height: height,
        width: width,
        child: Column(
          children: [
            const SizedBox(height: 4),
            _imageCarousel(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
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
      height: 228,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: _controller.product.images!.length,
            itemBuilder: (_, index, __) => _imageCarouselItem(_controller.product.images![index]),
            options: CarouselOptions(
              height: 220,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, _) => {
                setState(() => {
                  _controller.actualCarouselIndex = index
                })
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _controller.product.images!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 5),
              itemBuilder: (_, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _controller.actualCarouselIndex == index ? 18 : 8,
                  height: 8,
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
            placeholder: 'assets/images/loading.gif',
            fit: BoxFit.contain,
          ),
    );
  }

  Widget _bottomSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42),
      child: Container(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {},
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
              const Text('Añadir al carrito', style: TextStyle(color: Colors.white, letterSpacing: 0.64)),
              const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Icon(FlutterIcons.shopping_cart_fea, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

}