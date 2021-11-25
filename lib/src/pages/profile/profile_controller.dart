import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class ProfileController {
  File? imageFile;
  bool isEditing = false;
  bool editIsLoading = false;
  bool editImageIsLoading = false;
  UserProvider userProvider = UserProvider();
  late StateSetter selectImageSetState;
  late BuildContext context;
  late Function updateView;
  User? userProfile;
  late XFile? pickedFile;
  Map<String, TextEditingController> controllers = {
    'firstName': TextEditingController(),
    'lastName' : TextEditingController(),
    'email'    : TextEditingController(),
  };

  void init(BuildContext context, Function updateView) async {
    this.context = context;
    this.updateView = updateView;
    userProfile = await getUser();
    controllers['firstName']!.text = userProfile!.firstName;
    controllers['lastName']!.text = userProfile!.lastName;
    controllers['email']!.text = userProfile!.email;
    updateView();
  }

  void goBack() {
    Navigator.pop(context);
  }

  Future getUser() async {
    User user = User.fromJson(await SharedPref.read('user'));
    return user;
  }

  void editUser() async {
    if (controllers['firstName']!.text.isEmpty || controllers['lastName']!.text.isEmpty || controllers['email']!.text.isEmpty) {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: 'Ingresa todos los datos');
      return;
    }

    if (!EmailValidator.validate(controllers['email']!.text)) {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: 'Correo inválido');
      return;
    }

    isEditing = !isEditing;
    updateView();
    if(isEditing) return;

    editIsLoading = true;
    Map editedData = {};
    controllers.forEach((key, value) {
      if(value.text != userProfile!.toJson()[key]) editedData[key] = value.text;
    });

    ResponseApi? response = await userProvider.edit(userProfile!.id!, editedData);

    if (response?.success == true) {
      CustomSnackBar.showSuccess(context: context, title: 'Perfil Editado', message: 'Se editaron los datos');
      userProfile = User.fromJson(response!.data);
      SharedPref.save('user', userProfile);
      isEditing = false;
      editIsLoading = false;
      updateView();
      
    } else {
      editIsLoading = false;
      isEditing = true;
      updateView();
      CustomSnackBar.showError(context: context, title: 'Aviso', message: response?.message ?? 'Error al editar usuario');
    }
  }

  void editProfileImage() async {
    editImageIsLoading = true;
    selectImageSetState(() => {});

    Stream? stream = await userProvider.editProfileImage(userProfile!.id!, imageFile);
    stream!.listen((res) {
      ResponseApi response = ResponseApi.fromJson(jsonDecode(res));
      editImageIsLoading = false;
      selectImageSetState(() => {});

      if (response.success == true) {
        userProfile = User.fromJson(response.data);
        SharedPref.save('user', userProfile);
        updateView();
        Navigator.pop(context);
        Navigator.pop(context);

      } else {
        CustomSnackBar.showError(context: context, title: 'Aviso', message: response.message!);
      }
    });
  }

  void showImageDialog() {
    Widget buttonGallery = IconsOutlineButton(
      onPressed: () => selectImage(ImageSource.gallery),
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      text: 'Galería',
      iconData: Icons.image,
      color: const Color(0XFF735FDC),
      textStyle: const TextStyle(color: Colors.white, fontSize: 14.5),
      iconColor: Colors.white,
    );

    Widget buttonCamera = IconsOutlineButton(
      onPressed: () => selectImage(ImageSource.camera),
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      text: 'Cámara',
      iconData: Icons.camera_rounded,
      color: Colors.indigoAccent,
      textStyle: const TextStyle(color: Colors.white, fontSize: 14.5),
      iconColor: Colors.white,
    );

    Widget buttonCancel = OutlinedButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cancel_rounded, color: Colors.grey, size: 22),
          const SizedBox(width: 5),
          const Text('Cerrar', style: TextStyle(color: Colors.grey, fontSize: 14.5))
        ],
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0XFFD7D7D7)),
        padding: const EdgeInsets.only(left: 16, right: 24, top: 9, bottom: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Dialogs.bottomMaterialDialog(
      context: context,
      title: 'Foto De Perfil',
      titleStyle: const TextStyle(fontSize: 18, height: 1.8, fontWeight: FontWeight.w500),
      msg: 'Escoje una opción para subir tu foto',
      msgStyle: const TextStyle(fontSize: 16, color: Color(0XFF525252), height: 0.5),
      dialogShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
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
          child: buttonCancel
        ),
      ],
    );
  }

  void selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().pickImage(source: imageSource, imageQuality: 40);
    if(pickedFile != null) imageFile = File(pickedFile!.path);

    if(imageFile == null) return;

    Dialogs.bottomMaterialDialog(
      msg: 'Podrás cambiar la imagen después',
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
      context: context,
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
                    selectImageSetState = setState;
                    return OutlinedButton(
                      onPressed: editImageIsLoading ? () {} : editProfileImage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (editImageIsLoading == true) ...[
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
                          SizedBox(width: editImageIsLoading? 10 : 5),
                          const Text('Aceptar', style: TextStyle(color: Colors.white, fontSize: 14.5))
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
                  onPressed: () => Navigator.pop(context),
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

}