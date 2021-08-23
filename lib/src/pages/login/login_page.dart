import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/login/login_controller.dart';
import 'package:food_delivery/src/utils/theme_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool isChecked = true;
  final LoginController _loginController = LoginController();
  late AnimationController _animationController;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return const Color(0XFF23EBA0);
    }
    return const Color(0XFF23EBA0);
  }

  updateView() {
    setState(() => {});
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _loginController.init(context, updateView);
    });
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animationController.repeat(reverse: true, min: 0.72);
  }

  @override
  dispose() {
    _animationController.dispose();
    _loginController.disposeInputControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SafeArea(
          top: false,
          child: Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF060633),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _imageBanner(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 33, left: 32, right: 32, bottom: 30),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _loginTitle(),
                            Column(children: [
                              _textFieldEmail(),
                              SizedBox(height: height * 0.02),
                              _textFieldPassword(),
                              _rememberSection(),
                            ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _loginButton(),
                                const SizedBox(
                                  height: 10,
                                ),
                                _registerSection()
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginTitle() {
    return const Text(
      'Bienvenido!',
      style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: ThemeColors.titleColor),
    );
  }

  Widget _imageBanner() {
    return Image.asset('assets/images/login-background.png');
  }

  Widget _textFieldEmail() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: ThemeColors.lightPrimaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          focusNode: _loginController.emailNode,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            _loginController.fieldFocusChange(
                context, _loginController.emailNode, _loginController.passNode);
          },
          keyboardType: TextInputType.emailAddress,
          controller: _loginController.emailInput,
          style: const TextStyle(color: Color(0XFF3C4976), fontSize: 18),
          decoration: InputDecoration(
            hintText: 'Correo electrónico',
            hintStyle:
                const TextStyle(color: Color(0XFF758CD9), letterSpacing: -0.1),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            prefixIcon: Icon(
              FlutterIcons.md_mail_ion,
              size: 23,
              color: ThemeColors.getWithOpacity(ThemeColors.primaryColor, 0.8),
            ),
          ),
        ));
  }

  Widget _textFieldPassword() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: ThemeColors.lightPrimaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          textInputAction: TextInputAction.done,
          focusNode: _loginController.passNode,
          obscureText: true,
          controller: _loginController.passwordInput,
          style: const TextStyle(color: Color(0XFF3C4976), fontSize: 18),
          decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle:
                const TextStyle(color: Color(0XFF758CD9), letterSpacing: -0.1),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            prefixIcon: Icon(
              FlutterIcons.md_lock_ion,
              size: 26,
              color: ThemeColors.getWithOpacity(ThemeColors.primaryColor, 0.8),
            ),
          ),
        ));
  }

  Widget _rememberSection() {
    return Container(
        width: double.infinity,
        transform: Matrix4.translationValues(-10, 0, 0),
        child: Row(
          children: [
            Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: isChecked,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  shape: const CircleBorder(),
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                )),
            Container(
                transform: Matrix4.translationValues(-6, 1, 0),
                child: const Text('Recordarme',
                    style: TextStyle(color: Color(0XFF23EBA0), fontSize: 15))),
            Expanded(
              child: Container(
                  transform: Matrix4.translationValues(8, 1, 0),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Olvidaste tu contraseña?",
                      style: TextStyle(color: Color(0XFF2A3660), fontSize: 15),
                    ),
                  )),
            )
          ],
        ));
  }

  Widget _loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          transform: Matrix4.translationValues(-1, 0, 0),
          child: const Text(
            'Iniciar Sesión',
            style: TextStyle(
                color: Color(0XFF435bc3),
                fontSize: 19,
                fontWeight: FontWeight.w700),
          ),
        ),
        ScaleTransition(
          scale: _animationController,
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: _loginController.login,
            style: ElevatedButton.styleFrom(
              primary: const Color(0XFF435bc3),
              shape: const CircleBorder(),
              fixedSize: const Size(75, 75),
            ),
            child: _loginController.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.arrow_forward_rounded,
                    size: 32,
                  ),
          ),
        )
      ],
    );
  }

  Widget _registerSection() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          _loginController.goToRegisterPage();
        },
        child: const Text(
          'Crear Cuenta',
          style: TextStyle(
              color: Color(0XFF9B81FF),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        style: TextButton.styleFrom(
            elevation: 0,
            primary: const Color(0XFF9B81FF),
            backgroundColor: const Color(0XFFF1EEFF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            side: const BorderSide(color: Color(0XFF9B81FF)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
      ),
    );
  }
}
