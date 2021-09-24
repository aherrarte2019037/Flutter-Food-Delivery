import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:food_delivery/src/widgets/image_picker_dialog.dart';

class RegisterController {
  BuildContext? context;
  late User user;
  final UserProvider _userProvider = UserProvider();
  TextEditingController firstNameInput = TextEditingController();
  TextEditingController lastNameInput = TextEditingController();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController confirmInput = TextEditingController();
  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmNode = FocusNode();

  void init(BuildContext context) {
    this.context = context;
  }

  void goToLoginPage() {
    Navigator.pushNamedAndRemoveUntil(context!, 'login', (route) => false);
  }

  void verifyRegisterData() async {
    if(requestFocusInputs()) return;

    if(!EmailValidator.validate(emailInput.text)) {
      CustomSnackBar.showError(context, 'Aviso', 'Correo inválido');
      return;
    }

    if(passwordInput.text != confirmInput.text) {
      CustomSnackBar.showError(context, 'Aviso', 'Contraseñas no coinciden');
      return;
    }

    if(passwordInput.text.length < 6) {
      CustomSnackBar.showError(context, 'Aviso', 'Contraseña con minímo 6 caracteres');
      return;
    }

    if (!passwordInput.text.contains(RegExp(r'[0-9]'))) {
      CustomSnackBar.showError(context, 'Aviso', 'Contraseña con al menos 1 dígito');
      return;
    }

    if (!passwordInput.text.contains(RegExp(r'[a-z]')) || !!passwordInput.text.contains(RegExp(r'[A-Z]'))) {
      CustomSnackBar.showError(context, 'Aviso', 'Contraseña debe contener letras');
      return;
    }

    user = User(
      email: emailInput.text.trim(),
      password: passwordInput.text.trim(),
      firstName: firstNameInput.text.trim(),
      lastName: lastNameInput.text.trim()
    );

    ImagePickerDialog.show(context: context!, callback: register);
  }

  void register() async {
    Stream? stream = await _userProvider.register(user, ImagePickerDialog.file);
    stream?.listen((res) {
      ResponseApi response = ResponseApi.fromJson(jsonDecode(res));

      if (response.success == true) {
        ImagePickerDialog.hide();
        goToLoginPage();
        CustomSnackBar.showSuccess(context, 'Registro exitoso','bienvenido ${response.data?['firstName']}');

      } else {
        ImagePickerDialog.hide();
        CustomSnackBar.showError(context, 'Aviso', response.message!);
      }
    });
  }

  bool requestFocusInputs() {
    if(firstNameInput.text.isEmpty) {
      firstNameNode.requestFocus();
      return true;

    } else if(lastNameInput.text.isEmpty) {
      lastNameNode.requestFocus();
      return true;

    } else if(emailInput.text.isEmpty) {
      emailNode.requestFocus();
      return true;

    } else if(passwordInput.text.isEmpty) {
      passwordNode.requestFocus();
      return true;

    } else if(confirmInput.text.isEmpty) {
      confirmNode.requestFocus();
      return true;
    }

    return false;
  }
  
  void fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);  
  }

  void disposeInputControllers() {
    firstNameInput.dispose();
    lastNameInput.dispose();
    emailInput.dispose();
    passwordInput.dispose();
    confirmInput.dispose();
  }

}
