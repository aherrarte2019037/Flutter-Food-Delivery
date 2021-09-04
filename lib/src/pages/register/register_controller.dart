import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class RegisterController {
  BuildContext? context;
  bool isLoading = false;
  late XFile? pickedFile;
  File? imageFile;
  late User user;
  late StateSetter _selectImageSetState;
  late StateSetter _buttonNoneSetState;
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

    user = User(
      email: emailInput.text.trim(),
      password: passwordInput.text.trim(),
      firstName: firstNameInput.text.trim(),
      lastName: lastNameInput.text.trim()
    );

    showImageDialog();
  }

  void showImageDialog() {
    Widget buttonGallery = IconsOutlineButton(
      onPressed: () {
        selectImage(ImageSource.gallery);
      },
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      text: 'Galería',
      iconData: Icons.image,
      color: const Color(0XFF735FDC),
      textStyle: const TextStyle(color: Colors.white, fontSize: 14.5),
      iconColor: Colors.white,
    );

    Widget buttonCamera = IconsOutlineButton(
      onPressed: () {
        selectImage(ImageSource.camera);
      },
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      text: 'Cámara',
      iconData: Icons.camera_rounded,
      color: Colors.indigoAccent,
      textStyle: const TextStyle(color: Colors.white, fontSize: 14.5),
      iconColor: Colors.white,
    );

    Widget buttonNone = StatefulBuilder(
      builder: (_, setState) {
        _buttonNoneSetState = setState;
        return OutlinedButton(
          onPressed: isLoading ? () {} : () {register(withImage: false);},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isLoading == true) ...[
                Container(
                  width: 15,
                  height: 15,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey,
                  ),
                ),
              ] else ...[
                const Icon(Icons.cancel_rounded, color: Colors.grey, size: 22),
              ],
              SizedBox(width: isLoading ? 10 : 5),
              const Text(
                'Ninguna',
                style: TextStyle(color: Colors.grey, fontSize: 14.5),
              )
            ],
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0XFFD7D7D7)),
            padding: const EdgeInsets.only(left: 16, right: 24, top: 9, bottom: 9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );

    Dialogs.bottomMaterialDialog(
      msg: 'Escoje una opción para subir tu foto',
      msgStyle: const TextStyle(fontSize: 16, color: Color(0XFF525252), height: 0.5),
      dialogShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      title: 'Foto De Perfil',
      titleStyle: const TextStyle(
        fontSize: 18,
        height: 1.8,
        fontWeight: FontWeight.w500
      ),
 
      context: context!,
      actions: [
        Container(
          height: 75,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: buttonGallery
        ),
        Container(
          height: 75,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: buttonCamera
        ),
        Container(
          height: 75,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: buttonNone
        ),
      ],
    );
  }

  void selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().pickImage(source: imageSource);
    if(pickedFile != null) imageFile = File(pickedFile!.path);

    if(imageFile == null) return;

    Dialogs.bottomMaterialDialog(
      msg: 'Podrás cambiar la imagen en tu perfil',
      msgStyle: const TextStyle(fontSize: 16, color: Color(0XFF525252), height: 0.5),
      dialogShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      title: '¿Estás seguro?',
      titleStyle: const TextStyle(
        fontSize: 18,
        height: 1.8,
        fontWeight: FontWeight.w500
      ),
      isDismissible: false,
      context: context!,
      actions: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 75,
                height: 75,
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatefulBuilder(
                  builder: (_, setState) {
                    _selectImageSetState = setState;
                    return OutlinedButton(
                      onPressed: isLoading? (){} : register,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (isLoading == true) ...[
                            Container(
                              width: 15,
                              height: 15,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ] else ...[
                            const Icon(Icons.check_rounded, color: Colors.white, size: 22),
                          ],
                          SizedBox(width: isLoading? 10 : 5),
                          const Text(
                            'Aceptar',
                            style: TextStyle(color: Colors.white, fontSize: 14.5),
                          )
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.only(left: 16, right: 24, top: 9, bottom: 9),
                        backgroundColor: const Color(0XFF735FDC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context!);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.close_rounded,
                        color: Colors.grey,
                        size: 22,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.5
                        ),
                      )
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 14, right: 22, top: 9.5, bottom: 9.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            )  
          ],
        )
      ],
    );
  }

  void register({ bool withImage = true }) async {
    isLoading = true;
    if (!withImage) _buttonNoneSetState(() => {});
    if (withImage) _selectImageSetState(() => {});

    Stream? stream = await _userProvider.register(user, imageFile);
    stream?.listen((res) {
      ResponseApi response = ResponseApi.fromJson(jsonDecode(res));
      isLoading = false;

      if (!withImage) _buttonNoneSetState(() => {});
      if (withImage) _selectImageSetState(() => {});

      if (response.success == true) {
        goToLoginPage();
        CustomSnackBar.showSuccess(context, 'Registro exitoso','bienvenido ${response.data?['firstName']}');

      } else {
        if (!withImage) {
          Navigator.pop(context!);

        } else {
          Navigator.pop(context!);
          Navigator.pop(context!);
        }
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
