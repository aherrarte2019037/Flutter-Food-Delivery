import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditCardFormatter extends TextInputFormatter {
  final String mask;

  CreditCardFormatter({
    required this.mask,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isNotEmpty) {
      if(newValue.text.length > oldValue.text.length) {
        if(newValue.text.length > mask.length) return oldValue;
        if(newValue.text.length < mask.length && mask[newValue.text.length - 1].codeUnitAt(0) == 45) {
          return TextEditingValue(
            text: '${oldValue.text} ${newValue.text.substring(newValue.text.length-1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}