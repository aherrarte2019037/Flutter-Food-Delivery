import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/pages/restaurant/category/create/restaurant_category_create_controller.dart';

class RestaurantCategoryCreatePage extends StatefulWidget {
  const RestaurantCategoryCreatePage({ Key? key }) : super(key: key);

  @override
  _RestaurantCategoryCreatePageState createState() => _RestaurantCategoryCreatePageState();
}

class _RestaurantCategoryCreatePageState extends State<RestaurantCategoryCreatePage> {
  final RestaurantCategoryCreateController _controller = RestaurantCategoryCreateController();

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
      backgroundColor: Colors.white,
      appBar: _appBar(),
      bottomNavigationBar: _editButton(),
      body: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.only(left: 42, right: 42),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/create-category.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _latestCategories()
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
                padding: const EdgeInsets.all(2),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            const Text(
              'Crear Categoría',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 2),
              child: ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.more_horiz, size: 30, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(2),
                  elevation: 0,
                  primary: Colors.white,
                  onPrimary: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _latestCategories() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ultimas categorias',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),   
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 55,
              child: _controller.latestCategories.isNotEmpty
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _controller.latestCategories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      return _categoryChip(_controller.latestCategories[index]);
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (_, __) => _categoryChip(
                      ProductCategory(
                        name: 'No hay categorías recientes',
                        image: 'assets/images/product-category-image.png',
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(ProductCategory category) {
    return Container(
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
                ? Image.asset(
                    category.image!,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.assetNetwork(
                    image: category.image!,
                    placeholder: 'assets/images/loading.gif',
                    fit: BoxFit.cover,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            category.name!.capitalize(),
            style: const TextStyle(
              color: Color(0XFF0e0e0e),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _editButton() {
    return Padding(
      padding: const EdgeInsets.all(42),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Añadir', style: TextStyle(color: Colors.white)),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(FlutterIcons.edit_ent, size: 22),
              )
            ],
          ),
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
        ),
      ),
    );
  }
  
}