import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:search_choices/search_choices.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/pages/restaurant/product/create/restaurant_product_create_controller.dart';

class RestaurantProductCreatePage extends StatefulWidget {
  const RestaurantProductCreatePage({Key? key}) : super(key: key);

  @override
  _RestaurantProductCreatePageState createState() => _RestaurantProductCreatePageState();
}

class _RestaurantProductCreatePageState extends State<RestaurantProductCreatePage> {
  final RestaurantProductCreateController _controller = RestaurantProductCreateController();

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
      body: Container(
        padding: const EdgeInsets.only(bottom: 30, left: 42, right: 42),
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: SingleChildScrollView(
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
                      image: AssetImage('assets/images/create-product.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _latestProducts(),
                const SizedBox(height: 35),
                _textFieldName(),
                const SizedBox(height: 35),
                _textFieldPrice(),
                const SizedBox(height: 35),
                _dropDownCategories(),
                const SizedBox(height: 35),
                _textFieldDescription(),
                const SizedBox(height: 20),
                _uploadImageButton(),
                const SizedBox(height: 20),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 2,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return _uploadedCardImage();
                  },
                ),
              ],
            ),
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
              child: const Icon(Icons.arrow_back_rounded,
                  size: 30, color: Colors.black),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(2),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            const Text(
              'Crear Producto',
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
                child:
                    const Icon(Icons.more_horiz, size: 30, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(2),
                  elevation: 0,
                  primary: Colors.white,
                  onPrimary: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _latestProducts() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Últimos Productos',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 55,
              child: _controller.latestProductsIsLoading
                ? Container(
                    padding: const EdgeInsets.all(10),
                    width: 55,
                    height: 50,
                    child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                  )
                : _controller.latestProducts.isNotEmpty
                    ? AnimatedList(
                        key: _controller.productsListKey,
                        scrollDirection: Axis.horizontal,
                        initialItemCount: _controller.latestProducts.length,
                        itemBuilder: (_, index, animation) {
                          return _productChip(
                            _controller.latestProducts[index],
                            animation,
                            index,
                          );
                        },
                      )
                    : AnimatedList(
                        scrollDirection: Axis.horizontal,
                        initialItemCount: 1,
                        itemBuilder: (_, index, animation) {
                          return _productChip(
                            Product(
                              name: 'No hay productos recientes',
                              description: '',
                              price: 0,
                              images: [
                                'assets/images/product-category-image.png'
                              ],
                            ),
                            animation,
                            index,
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productChip(Product product, Animation<double> animation, int index) {
    return Padding(
      padding: EdgeInsets.only(right: index + 1 < _controller.latestProducts.length ? 12 : 0),
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
                  child: product.images![0].contains('assets')
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            product.images![0],
                            fit: BoxFit.cover,
                          ),
                        )
                      : AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage.assetNetwork(
                              image: product.images![0],
                              placeholder: 'assets/images/loading.gif',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                product.name.capitalize(),
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
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: const TextStyle(color: Color(0XFF7e7e7e), fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Nombre De Producto',
        hintStyle: const TextStyle(color: Color(0XFF494949), fontSize: 16),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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

  Widget _textFieldPrice() {
    return TextField(
      controller: _controller.textFieldControllers['price'],
      keyboardType: TextInputType.number,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Precio',
        labelStyle: const TextStyle(color: Color(0XFF7e7e7e), fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Precio De Producto',
        hintStyle: const TextStyle(color: Color(0XFF494949), fontSize: 16),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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

  Widget _dropDownCategories() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0XFFC7C7C7), width: 1),
          ),
          child: SearchChoices.single(
            underline: Container(
              height: 1.0,
              decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            ),
            buildDropDownDialog: (titleBar, searchBar, list, closeButton, dropDownContext) {
              return Card(
                elevation: 0,
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  height: 220,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          height: 105,
                          child: Column(
                            children: [
                              list,
                            ],
                          ),
                        ),
                      ),
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
            items: _controller.categoryItems,
            icon: const Icon(FlutterIcons.chevron_down_evi, color: Color(0XFF232323), size: 30),
            autofocus: false,
            value: 1,
            padding: 5,
            hint: const Padding(
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text('Seleccionar'),
            ),
            style: const TextStyle(color: Color(0XFF494949), fontSize: 17),
            onChanged: (value) {},
            dialogBox: false,
            menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
            isExpanded: true,
            iconEnabledColor: const Color(0XFFe7e7e7),
            displayClearIcon: false,
          ),
        ),
        Positioned(
          top: -7,
          left: 17,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.white,
            child: const Text(
              'Categoría',
              style: TextStyle(color: Color(0XFF7e7e7e), fontSize: 12.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldDescription() {
    return TextField(
      controller: _controller.textFieldControllers['description'],
      textInputAction: TextInputAction.done,
      minLines: 3,
      maxLines: 3,
      cursorColor: const Color(0XFF3a3a3a),
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Descripción',
        labelStyle: const TextStyle(color: Color(0XFF7e7e7e), fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Descripción Breve',
        hintStyle: const TextStyle(color: Color(0XFF494949), fontSize: 16),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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

  Widget _uploadImageButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      label: const Text(' Subir Imagen', style: TextStyle(color: Colors.white)),
      icon: const Icon(FlutterIcons.upload_cloud_fea,
          color: Colors.white, size: 18),
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        side: const BorderSide(style: BorderStyle.none),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
    );
  }

  Widget _uploadedCardImage() {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Dismissible(
          key: GlobalKey(),
          onDismissed: (direction) {},
          child: Container(
            height: 74,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.red.shade400, Colors.orange.shade300],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 51,
                      height: 51,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        FlutterIcons.file_image_outline_mco,
                        color: Colors.red.withOpacity(0.85),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'image1.png',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '5.8 MB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  width: 51,
                  height: 51,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/client-role.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
