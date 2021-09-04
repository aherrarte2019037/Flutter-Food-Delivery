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
  Map<String, TextEditingController> controllers = {
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
    if(response == null || !response.success!) return [];
  
    List<ProductCategory> latest = response.data;

    return latest;
  }

  void createCategory() {
    if (controllers['name']!.text.isEmpty || controllers['description']!.text.isEmpty) {
      CustomSnackBar.showError(context, 'Aviso', 'Ingresa todos los datos');
      return;
    }

    ProductCategory category = ProductCategory(
      name: controllers['name']!.text.trim(),
      description: controllers['descriprion']!.text.trim()
    );

    print(category.toJson());
  }

}