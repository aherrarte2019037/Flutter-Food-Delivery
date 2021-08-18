import 'package:flutter/material.dart';

class ThemeColors {
  static const Color primaryColor = Color( 0xFF314abd );
  static const Color lightPrimaryColor = Color( 0xFFF4F6FE );
  static const Color titleColor = Color( 0xFF4E66D0 );

  static getWithOpacity( Color color, double opacity ) {
    int red = color.red;
    int green = color.green;
    int blue = color.blue;
    return Color.fromRGBO(red, green, blue, opacity);
  }
}