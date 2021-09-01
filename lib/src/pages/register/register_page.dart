import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/pages/register/register_controller.dart';
import 'package:food_delivery/src/utils/theme_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final RegisterController _registerController = RegisterController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _registerController.init(context);
      precacheImage(const AssetImage('assets/images/register-background.png'), context);
    });
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animationController.repeat(reverse: true, min: 0.72);
  }

  @override
  dispose() {
    _animationController.dispose();
    _registerController.disposeInputControllers();
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
                  decoration: const BoxDecoration(color: Color(0xFF062233)),
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
                        padding: const EdgeInsets.all(30),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _registerTitle(),
                            const SizedBox(height: 0),
                            Column(children: [
                              Row(
                                children: [
                                  _textFieldFirstName(),
                                  const SizedBox(width: 10),
                                  _textFieldLastName()
                                ],
                              ),
                              SizedBox(height: height * 0.023),
                              _textFieldEmail(),
                              SizedBox(height: height * 0.023),
                              _textFieldPassword(),
                              SizedBox(height: height * 0.023),
                              _textFieldConfirmPassword()
                            ]),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _registerButton(),
                                const SizedBox(height: 5),
                                _loginSection()
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerTitle() {
    return const Text(
      'Gracias por unirte!',
      style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: ThemeColors.titleColor),
    );
  }

  Widget _imageBanner() {
    return Image.asset('assets/images/register-background.png');
  }

  Widget _textFieldFirstName() {
    return Flexible(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: ThemeColors.lightPrimaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: TextField(
            focusNode: _registerController.firstNameNode,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              _registerController.fieldFocusChange(
                  context,
                  _registerController.firstNameNode,
                  _registerController.lastNameNode);
            },
            textCapitalization: TextCapitalization.words,
            controller: _registerController.firstNameInput,
            style: const TextStyle(color: Color(0XFF3C4976), fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Nombre',
              hintStyle: const TextStyle(color: Color(0XFF758CD9)),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              prefixIcon: Icon(
                FlutterIcons.md_person_ion,
                size: 23,
                color:
                    ThemeColors.getWithOpacity(ThemeColors.primaryColor, 0.8),
              ),
            ),
          )),
    );
  }

  Widget _textFieldLastName() {
    return Flexible(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: ThemeColors.lightPrimaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: TextField(
            focusNode: _registerController.lastNameNode,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              _registerController.fieldFocusChange(
                  context,
                  _registerController.lastNameNode,
                  _registerController.emailNode);
            },
            textCapitalization: TextCapitalization.words,
            controller: _registerController.lastNameInput,
            style: const TextStyle(color: Color(0XFF3C4976), fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Apellido',
              hintStyle: const TextStyle(
                  color: Color(0XFF758CD9), letterSpacing: -0.1),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              prefixIcon: Icon(
                FlutterIcons.md_person_ion,
                size: 23,
                color:
                    ThemeColors.getWithOpacity(ThemeColors.primaryColor, 0.8),
              ),
            ),
          )),
    );
  }

  Widget _textFieldEmail() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: ThemeColors.lightPrimaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          focusNode: _registerController.emailNode,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            _registerController.fieldFocusChange(
                context,
                _registerController.emailNode,
                _registerController.passwordNode);
          },
          keyboardType: TextInputType.emailAddress,
          controller: _registerController.emailInput,
          style: const TextStyle(color: Color(0XFF3C4976), fontSize: 17),
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
          focusNode: _registerController.passwordNode,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            _registerController.fieldFocusChange(
                context,
                _registerController.passwordNode,
                _registerController.confirmNode);
          },
          controller: _registerController.passwordInput,
          obscureText: true,
          style: const TextStyle(color: Color(0XFF3C4976), fontSize: 17),
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

  Widget _textFieldConfirmPassword() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: ThemeColors.lightPrimaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          textInputAction: TextInputAction.done,
          focusNode: _registerController.confirmNode,
          controller: _registerController.confirmInput,
          obscureText: true,
          style: const TextStyle(color: Color(0XFF3C4976), fontSize: 17),
          decoration: InputDecoration(
            hintText: 'Confirmar',
            hintStyle:
                const TextStyle(color: Color(0XFF758CD9), letterSpacing: -0.1),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            prefixIcon: Icon(
              FlutterIcons.md_refresh_ion,
              size: 26,
              color: ThemeColors.getWithOpacity(ThemeColors.primaryColor, 0.8),
            ),
          ),
        ));
  }

  Widget _registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          transform: Matrix4.translationValues(-1, 0, 0),
          child: const Text(
            'Crear Cuenta',
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
            onPressed: _registerController.verifyRegisterData,
            style: ElevatedButton.styleFrom(
              primary: const Color(0XFF435bc3),
              shape: const CircleBorder(),
              fixedSize: const Size(72, 72),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 32,
            ),
          ),
        )
      ],
    );
  }

  Widget _loginSection() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          _registerController.goToLoginPage();
        },
        child: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            color: Color(0XFF9B81FF),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        style: TextButton.styleFrom(
            elevation: 0,
            primary: const Color(0XFF9B81FF),
            backgroundColor: const Color(0XFFF1EEFF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            side: const BorderSide(color: Color(0XFF9B81FF)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      ),
    );
  }

}
