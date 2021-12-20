import 'package:flutter/material.dart';

class FormUtils {

  static bool formFilled(Map<String, TextEditingController> form) {
    for (var controller in form.values) {
      if(controller.text.isEmpty) return false;
    }

    return true;
  }

  static void resetForm(Map<String, TextEditingController> form) {
    for (var controller in form.values) {
      controller.clear();
    }
  }

}