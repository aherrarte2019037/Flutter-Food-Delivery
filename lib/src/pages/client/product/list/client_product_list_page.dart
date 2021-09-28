import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/pages/client/product/list/client_product_list_controller.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/widgets/shimmer_widget.dart';
import 'package:food_delivery/src/widgets/drawer/user_drawer.dart';

class ClientProductListPage extends StatefulWidget {
  const ClientProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ClientProductListPage> {
  final ClientProductListController _controller = ClientProductListController();

  updateView() {
    setState(() => {});
  }

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
      key: _controller.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _appBar(),
      drawer: UserDrawer(drawerType: 'CLIENT'),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30, left: 42, right: 42),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _bannerImage(),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bievenido,', style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 4),
                  const Text('Angel Herrarte', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 20),
              _searchBar(),
              const SizedBox(height: 35),
              _categoriesChipSection(),
              const SizedBox(height: 40),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.products.length,
                shrinkWrap: true,
                separatorBuilder: (_, __) => const SizedBox(height: 40),
                itemBuilder: (_, index) {
                  if (_controller.products[index]['products'].length == 0) return const SizedBox.shrink();
                  
                  return _foodCategoryList(_controller.products[index]);
                },
              ),
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
            Transform.translate(
              offset: const Offset(0, 0.5),
              child: ElevatedButton(
                onPressed: _controller.openDrawer,
                child: const Icon(FlutterIcons.align_left_fea, size: 26, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(2),
                  elevation: 0,
                  primary: Colors.white,
                  onPrimary: Colors.grey,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
            const Text(
              'Inicio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Stack(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(FlutterIcons.shopping_cart_fea, size: 24.5, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(2),
                    elevation: 0,
                    primary: Colors.white,
                    onPrimary: Colors.grey,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 14,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0XFFFF8C3E),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  
  Widget _bannerImage() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: AssetImage('assets/images/product-list.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0XFFf3f5f9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
              border: InputBorder.none,
              hintText: 'Qué quieres comer?',
              hintStyle: const TextStyle(color: Color(0XFF9FA6C1), fontWeight: FontWeight.w400, fontSize: 15.5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Ink(
          decoration: ShapeDecoration(
            color: const Color(0XFFFF8C3E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          ),
          child: Transform.translate(
            offset: const Offset(0, -1),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(FlutterIcons.search1_ant, color: Colors.white),
              padding: const EdgeInsets.all(14.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoriesChipSection() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categorías',
            style: TextStyle(color: Color(0XFF292929), fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 55,
              child: _controller.categoriesIsLoading
                ? Container(
                    padding: const EdgeInsets.all(10),
                    width: 55,
                    height: 50,
                    child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                  )
                : AnimatedList(
                    key: _controller.categoriesListKey,
                    scrollDirection: Axis.horizontal,
                    initialItemCount: _controller.categories.length,
                    itemBuilder: (_, index, animation) {
                      return _categoryChip(
                        _controller.categories[index],
                        animation,
                        index,
                      );
                    },
                  )
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(ProductCategory category, Animation<double> animation, int index) {
    return Padding(
      padding: EdgeInsets.only(right: index + 1 < _controller.categories.length ? 12 : 0),
      child: SlideTransition(
        position: animation.drive(Tween(begin: const Offset(1, 0), end: const Offset(0, 0))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0XFFe7e7e7),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: category.image!.contains('assets')
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                          category.image!,
                          fit: BoxFit.cover,
                        ),
                    )
                    : AspectRatio(
                      aspectRatio: 1/1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage.assetNetwork(
                            image: category.image!,
                            placeholder: 'assets/images/loading.gif',
                            fit: BoxFit.cover,
                          ),
                      ),
                    ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                category.name!.capitalize(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _foodCategoryList(Map categoryGrouped) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  categoryGrouped['category']['name'].toString().capitalize(),
                  style: const TextStyle(color: Color(0XFF292929), fontSize: 18,fontWeight: FontWeight.w500),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Row(
                  children: [
                    const Text(
                      'Ver Todo',
                      style: TextStyle(color: Color(0XFFFF8C3E), fontSize: 13.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5),
                    Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0XFFFF8C3E),
                    ),
                    child: Transform.translate(
                      offset: const Offset(0, -1),
                      child: const Icon(FlutterIcons.plus_ent, size: 15, color: Colors.white),
                    ),
                  ),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                  primary: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 240,
            child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryGrouped['products'].length,
              itemBuilder: (_, index) {
                Product product = Product.fromJson(categoryGrouped['products'][index]);
                return _productCard(product);
              },
            ),
          ),
        ]
      ),
    );
  }

  Widget _productCard(Product product) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: GestureDetector(
        onTap: () => _controller.showProductDetailModal(product),
        child: Container(
          width: 175,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0XFFF8F8F8),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 5,
                child: Container(
                  height: 25,
                  width: 25,
                  padding: const EdgeInsets.only(bottom: 1.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.redAccent.withOpacity(0.25),
                  ),
                  child: const Icon(FlutterIcons.fire_faw5s, size: 15, color: Colors.redAccent),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 105,
                      height: 105,
                      child: product.images![0].contains('assets')
                        ? Image.asset(
                            product.images![0],
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            product.images![0],
                            fit: BoxFit.contain,
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
      
                              return Transform.translate(
                                offset: const Offset(1, -2),
                                child: const ShimmerWidget(height: 70, width: 70, radius: 50),
                              );
                            },
                          ),
                    ),
                    Text(
                      product.name.capitalize(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0XFF292929),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description.capitalize(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(0XFF292929),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Q${product.price}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0XFF292929)
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(FlutterIcons.plus_fea, size: 19, color: Colors.white),
                          label: const Text(''),
                          style: OutlinedButton.styleFrom(
                            elevation: 4,
                            primary: Colors.white,
                            fixedSize: const Size(35, 35),
                            minimumSize: const Size(35, 35),
                            padding: const EdgeInsets.only(left: 8, right: 0, top: 0, bottom: 2.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            backgroundColor: Colors.black,
                            side: BorderSide.none,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
