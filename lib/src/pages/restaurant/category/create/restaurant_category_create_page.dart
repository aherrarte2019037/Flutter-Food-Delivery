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
      bottomNavigationBar: _createButton(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(left: 42, right: 42),
        child: Container(
          height: height - 186,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              _latestCategories(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _textFieldName(),
                    SizedBox(height: height * 0.06),
                    _textFieldDescription()
                  ],
                ),
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
            ElevatedButton(
              onPressed: _controller.goBack,
              child: const Icon(Icons.arrow_back_rounded, size: 30, color: Colors.black),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(2),
                elevation: 0,
                shadowColor: Colors.transparent,
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
                  shadowColor: Colors.transparent,
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
            'Últimas categorías',
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
              child: _controller.latestCategoriesIsLoading
              ? Container(
                    padding: const EdgeInsets.all(10),
                    width: 55,
                    height: 50,
                    child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                )
              : _controller.latestCategories.isNotEmpty
                ? AnimatedList(
                    key: _controller.categoriesListKey,
                    scrollDirection: Axis.horizontal,
                    initialItemCount: _controller.latestCategories.length,
                    itemBuilder: (_, index, animation) {
                      return _categoryChip(
                        _controller.latestCategories[index],
                        animation,
                        index
                      );
                    },
                  )
                : AnimatedList(
                    scrollDirection: Axis.horizontal,
                    initialItemCount: 1,
                    itemBuilder: (_, index, animation) {
                      return _categoryChip(
                        ProductCategory(
                          name: 'No hay categorías recientes',
                          image: 'assets/images/product-category-image.png',
                        ),
                        animation,
                        index
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
      padding: EdgeInsets.only(right: index + 1 < _controller.latestCategories.length ? 12 : 0),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
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

  Widget _textFieldName() {
    return TextField(
      controller: _controller.textFieldControllers['name'],
      autofocus: false,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: const TextStyle(color: Color(0XFF7e7e7e), fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Nombre De Categoría',
        hintStyle: const TextStyle(color: Color(0XFF494949), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFC7C7C7), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFF525252), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _textFieldDescription() {
    return TextField(
      autofocus: false,
      textInputAction: TextInputAction.done,
      controller: _controller.textFieldControllers['description'],
      minLines: 3,
      maxLines: 3,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Descripción',
        labelStyle: const TextStyle(color: Color(0XFF7e7e7e), fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Descripción Breve',
        hintStyle: const TextStyle(color: Color(0XFF494949), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFC7C7C7), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFF525252), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _createButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: _controller.createCategoryIsLoading ? () {} : _controller.verifyCategoryData,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Añadir', style: TextStyle(color: Colors.white)),
              Padding(
                padding: EdgeInsets.only(bottom: _controller.createCategoryIsLoading ? 4 : 3),
                child: _controller.createCategoryIsLoading
                  ? Container(
                      width: 20,
                      height: 20,
                      child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                  : const Icon(FlutterIcons.edit_ent, size: 22),
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