import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/models/product_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/utils/form_utils.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/providers/product_category_provider.dart';
import 'package:food_delivery/src/providers/product_provider.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:food_delivery/src/widgets/image_picker_dialog.dart';

class RestaurantProductCreateController {
  late BuildContext context;
  late Function updateView;
  late Product product;
  final ProductProvider productProvider = ProductProvider();
  final ProductCategoryProvider categoryProvider = ProductCategoryProvider();
  final GlobalKey<AnimatedListState> productsListKey = GlobalKey();
  final scrollController = ScrollController();
  Map<String, TextEditingController> textFieldControllers = {
    'name': TextEditingController(),
    'price': TextEditingController(),
    'calories': TextEditingController(),
    'description': TextEditingController(),
    'category': TextEditingController(),
  };
  bool latestProductsIsLoading = false;
  bool createProductIsLoading = false;
  List<Product> latestProducts = [];
  List<DropdownMenuItem> categoryItems = [];
  List<File> images = [];
  
  void init(BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView = updateView;
    latestProducts = await getLatestProducts();
    categoryItems = (await getCategories()).map(
      (ProductCategory c) {
        return DropdownMenuItem(
          child: Text(
            c.name!.capitalize(),
            style: const TextStyle(fontSize: 17, color: Colors.black),
          ),
          value: c.name,
        );
      },
    ).toList();
    updateView();
  }

  Future<List<Product>> getLatestProducts() async {
    latestProductsIsLoading = true;
    updateView();

    ResponseApi? response = await productProvider.getLatestProducts();
    List<Product> latestProducts = response?.data ?? [];

    latestProductsIsLoading = false;
    updateView();

    return latestProducts;
  }

  Future<List<ProductCategory>> getCategories() async {
    List<ProductCategory> categories = await categoryProvider.getAll();
    return categories;
  }

  void goBack() {
    Navigator.pop(context);
  }

  Future createProduct() async{
    if (!FormUtils.formFilled(textFieldControllers)) {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: 'Ingresa todos los datos');
      return;
    }

    product = Product(
      name       : textFieldControllers['name']!.text,
      price      : int.parse(textFieldControllers['price']!.text),
      calories   : int.parse(textFieldControllers['calories']!.text),
      category   : textFieldControllers['category']!.text,
      description: textFieldControllers['description']!.text
    );
    createProductIsLoading = true;
    updateView();

    Stream? stream = await productProvider.createProduct(product, images);
    stream?.listen((res) {
      ResponseApi response = ResponseApi.fromJson(jsonDecode(res));
    
      if (response.success == true) {
        CustomSnackBar.showSuccess(context: context, title: 'Felicidades', message: 'Producto creado');
        Product productCreated = Product.fromJson(response.data);
        latestProducts.insert(0, productCreated);
        productsListKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
        createProductIsLoading = false;
        FormUtils.resetForm(textFieldControllers);
        updateView();
        
      } else {
        createProductIsLoading = false;
        CustomSnackBar.showError(context: context, title: 'Aviso', message: response.message!);
        updateView();
      }
    });
  }  

  void uploadImage() async {
    if(images.length == 4) {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: 'Máximo 4 imágenes');
      return;
    }
    File image = await ImagePickerDialog.showWithoutCallback(context);
    images.add(image);
    double scrollTo = scrollController.position.maxScrollExtent + (images.length > 1 ? 94 : 74);
    scrollController.animateTo(scrollTo, duration: const Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
    updateView();
  }

  void dismissImage(DismissDirection direction, File image) => images.remove(image);

}
