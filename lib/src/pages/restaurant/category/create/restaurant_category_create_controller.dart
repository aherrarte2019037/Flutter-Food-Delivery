import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/product_category_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/providers/product_category_provider.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';

class RestaurantCategoryCreateController {
  late BuildContext context;
  late Function updateView;
  ProductCategoryProvider categoryProvider = ProductCategoryProvider();
  List latestCategories = [];
  Map<String, TextEditingController> textFieldControllers = {
    'name': TextEditingController(),
    'description' : TextEditingController(),
  };

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

  void createCategory() {
    if (textFieldControllers['name']!.text.isEmpty || textFieldControllers['description']!.text.isEmpty) {
      CustomSnackBar.showError(context, 'Aviso', 'Ingresa todos los datos');
      return;
    }

    ProductCategory category = ProductCategory(
      name: textFieldControllers['name']!.text.trim(),
      description: textFieldControllers['descriprion']!.text.trim()
    );

    print(category.toJson());
  }

}