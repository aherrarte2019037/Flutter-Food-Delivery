import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/pages/client/product/list/client_product_list_controller.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
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
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      _controller.init(context, updateView);
      _controller.addCategoriesToList();
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
        child: Column(
          children: [
            const SizedBox(height: 6),
            _bannerImage(),
            const SizedBox(height: 35),
            _searchBar(),
            const SizedBox(height: 28),
            _categoriesChipSection(),
            const SizedBox(height: 28),
            _foodCategoryList()
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
              hintStyle: const TextStyle(color: Color(0XFF9FA6C1), fontWeight: FontWeight.w400),
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
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
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

  Widget _foodCategoryList() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Bebidas',
                  style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w500),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              height: 200,
              child: _controller.productsIsLoading
                ? Container(
                    padding: const EdgeInsets.all(10),
                    width: 55,
                    height: 50,
                    child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                  )
                : AnimatedList(
                    scrollDirection: Axis.horizontal,
                    initialItemCount: 2,
                    itemBuilder: (_, index, animation) => _productCard(),
                  )
            ),
          ),
        ]
      ),
    );
  }

  Widget _productCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Container(
        height: 200,
        width: 165,
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(28)
        ),
      ),
    );
  }

}
