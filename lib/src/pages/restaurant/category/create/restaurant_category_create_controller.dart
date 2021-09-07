import 'dart:convert';
import 'dart:io';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/providers/product_category_provider.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:food_delivery/src/widgets/image_picker_dialog.dart';

class RestaurantCategoryCreateController {
  late BuildContext context;
  late Function updateView;
  final GlobalKey<AnimatedListState> categoriesListKey = GlobalKey();
  ProductCategoryProvider categoryProvider = ProductCategoryProvider();
  List<ProductCategory> latestCategories = [];
  bool createCategoryIsLoading = false;
  Map<String, TextEditingController> textFieldControllers = {
    'name': TextEditingController(),
    'description' : TextEditingController(),
  };
  ProductCategory category = ProductCategory();

  void init(BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView = updateView;
    latestCategories = await getLatestCategories();
    updateView();
  }

  void goBack() {
    Navigator.pop(context);
  }

  Future<List<ProductCategory>> getLatestCategories() async {
    ResponseApi? response = await categoryProvider.getLatestCategories();
  
    List<ProductCategory> categories = response?.data ?? [];
  
    return categories;
  }

  void verifyCategoryData() {
    if (textFieldControllers['name']!.text.isEmpty || textFieldControllers['description']!.text.isEmpty) {
      CustomSnackBar.showError(context, 'Aviso', 'Ingresa todos los datos');
      return;
    }

    category = ProductCategory(
      name: textFieldControllers['name']!.text.trim().capitalize(),
      description: textFieldControllers['description']!.text.trim().capitalize()
    );

    ImagePickerDialog.show(context: context, callback: createCategory);
  }

  void createCategory({File? file }) async {
    Stream? stream = await categoryProvider.createCategory(category, file);
    stream?.listen((res) {
      ResponseApi response = ResponseApi.fromJson(jsonDecode(res));

      if (response.success == true) {
        ImagePickerDialog.hide();
        CustomSnackBar.showSuccess(context, 'Felicidades','Categoría ${response.data['name']} creada');
        ProductCategory categoryCreated = ProductCategory.fromJson(response.data);
        categoriesListKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 500));
        latestCategories.insert(0, categoryCreated);
        updateView();

      } else {
        ImagePickerDialog.hide();
        CustomSnackBar.showError(context, 'Aviso', response.message!);
      }
    });
  }

}