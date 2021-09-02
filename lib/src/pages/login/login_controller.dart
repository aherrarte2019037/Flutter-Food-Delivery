import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/utils/role_redirect.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:email_validator/email_validator.dart';

class LoginController {
  BuildContext? context;
  late Function updateView;
  bool isLoading = false;
  final UserProvider _userProvider = UserProvider();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();

  void init(BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView = updateView;
    _userProvider.init(context);
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, 'register');
  }

  void goToProductListPage() {
    Navigator.pushNamedAndRemoveUntil(context!, 'client/products/list', (route) => false);
  }

  void login() async {
    if (requestFocusInputs()) return;
    String email = emailInput.text.trim();
    String pass = passwordInput.text.trim();

    if (!EmailValidator.validate(email)) {
      CustomSnackBar.showError(context, 'Aviso', 'Correo inválido, intenta de nuevo');
      return;
    }

    isLoading = true;
    updateView();

    ResponseApi? response = await _userProvider.login(email, pass);
    isLoading = false;

    if (response?.success == true) {
      final User user = User.fromJson(response?.data);
      SharedPref.save('user', user);
      SharedPref.save('token', response!.data['token']);
      RoleRedirect.redirect(user.roles!, context!);
      
    } else {
      CustomSnackBar.showError(context, 'Aviso', response!.message!);
      updateView();
    }
  }

  bool requestFocusInputs() {
    if (emailInput.text.isEmpty) {
      emailNode.requestFocus();
      return true;

    } else if (passwordInput.text.isEmpty) {
      passNode.requestFocus();
      return true;
    }

    return false;
  }

  void disposeInputControllers() {
    emailInput.dispose();
    passwordInput.dispose();
  }

  void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  
}
