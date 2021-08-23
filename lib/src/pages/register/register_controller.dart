import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';

class RegisterController {
  BuildContext? context;
  late Function updateView;
  bool isLoading = false;
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

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
    _userProvider.init(context);
  }

  void goToLoginPage() {
    Navigator.pop(context!);
  }

  void register() async {
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

    User user = User(
      email: emailInput.text.trim(),
      password: passwordInput.text.trim(),
      firstName: firstNameInput.text.trim(),
      lastName: lastNameInput.text.trim()
    );
    isLoading = true;
    updateView();

    ResponseApi? response = await _userProvider.register(user);
    isLoading = false;

    if(response?.success == true) {
      goToLoginPage();
      CustomSnackBar.showSuccess(context, 'Registro exitoso', 'bienvenido ${response?.data?['firstName']}');
    
    } else {
      updateView();
      CustomSnackBar.showError(context, 'Aviso', response!.message!);
    }
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
