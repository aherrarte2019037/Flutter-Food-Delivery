import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class ImagePickerDialog {
  static late Function _callback;
  static late BuildContext _context;
  static late XFile? _pickedFile;
  static File? file;
  static final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  static void show({required BuildContext context, required Function callback}) {
    _context = context;
    _callback = callback;
    FocusScope.of(context).unfocus();

    Widget buttonGallery = IconsOutlineButton(
      onPressed: () => _selectImage(ImageSource.gallery),
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      text: 'Galería',
      iconData: Icons.image,
      color: const Color(0XFF735FDC),
      textStyle: const TextStyle(color: Colors.white, fontSize: 14.5),
      iconColor: Colors.white,
    );

    Widget buttonCamera = IconsOutlineButton(
      onPressed: () => _selectImage(ImageSource.camera),
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      text: 'Cámara',
      iconData: Icons.camera_rounded,
      color: Colors.indigoAccent,
      textStyle: const TextStyle(color: Colors.white, fontSize: 14.5),
      iconColor: Colors.white,
    );

    Widget buttonNone = ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (_, value, ___) {
        return OutlinedButton(
          onPressed: value == true
            ? () {}
            : () {
              _startLoading();
              _callback();
            },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (value == true) ...[
                Container(
                  width: 15,
                  height: 15,
                  child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                ),
              ] else ...[
                const Icon(Icons.cancel_rounded, color: Colors.grey, size: 22),
              ],
              SizedBox(width: value == true ? 10 : 5),
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
      context: _context,
      actions: [
        Container(
          height: 75,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: buttonGallery,
        ),
        Container(
          height: 75,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: buttonCamera
        ),
        Container(
          height: 75,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: buttonNone,
        ),
      ],
    );
  }

  static void _selectImage(ImageSource imageSource) async {
    _pickedFile = await ImagePicker().pickImage(source: imageSource, imageQuality: 40);
    if(_pickedFile != null) file = File(_pickedFile!.path);

    if(file == null) return;

    Widget buttonCancel = OutlinedButton(
      onPressed: () => Navigator.pop(_context),
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
            style: TextStyle(color: Colors.grey, fontSize: 14.5),
          )
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.only(left: 14, right: 22, top: 9.5, bottom: 9.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Widget buttonAccept = ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (_, value, ___) {
        return OutlinedButton(
          onPressed: value == true 
            ? () {} 
            : () {
              _startLoading();
              _callback();
            },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (value == true) ...[
                Container(
                  width: 16,
                  height: 16,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ] else ...[
                const Icon(Icons.check_rounded, color: Colors.white, size: 22),
              ],
              SizedBox(width: value == true ? 10 : 5, height: value == true ? 22 : 0,),
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
    );

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
      context: _context,
      actions: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 75,
                height: 75,
                child: Image.file(
                  file!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonAccept,
                const SizedBox(width: 20),
                buttonCancel,
              ],
            )  
          ],
        )
      ],
    );
  }

  static Future<File> showWithoutCallback(BuildContext context) async {
    _context = context;
    Completer<File> fileCompleter = Completer();
    FocusScope.of(context).unfocus();

    Widget buttonGallery = IconsOutlineButton(
      onPressed: () => _selectImageWithoutCallback(ImageSource.gallery, fileCompleter),
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      text: 'Galería',
      iconData: Icons.image,
      color: const Color(0XFF735FDC),
      textStyle: const TextStyle(color: Colors.white, fontSize: 14.5),
      iconColor: Colors.white,
    );

    Widget buttonCamera = IconsOutlineButton(
      onPressed: () => _selectImageWithoutCallback(ImageSource.camera, fileCompleter),
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

    return fileCompleter.future;
  }

  static void _selectImageWithoutCallback(ImageSource imageSource, Completer fileCompleter) async {
    _pickedFile = await ImagePicker().pickImage(source: imageSource, imageQuality: 40);
    if(_pickedFile == null ) return;
  
    File imageFile = File(_pickedFile!.path);

    Widget buttonCancel = OutlinedButton(
      onPressed: () {
        _pickedFile = null;
        file = null;
        Navigator.pop(_context);
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
            style: TextStyle(color: Colors.grey, fontSize: 14.5),
          )
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.only(left: 14, right: 22, top: 9.5, bottom: 9.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  
    Widget buttonAccept = OutlinedButton(
      onPressed: () {
        _pickedFile = null;
        file = null;
        fileCompleter.complete(imageFile);
        Navigator.pop(_context); 
        Navigator.pop(_context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.check_rounded, color: Colors.white, size: 22),
          const SizedBox(
            width: 5,
          ),
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
  
    Dialogs.bottomMaterialDialog(
      msg: 'Luego podrás cambiar la imagen',
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
      context: _context,
      actions: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 75,
                height: 75,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonAccept,
                const SizedBox(width: 20),
                buttonCancel,
              ],
            )  
          ],
        )
      ],
    );
  }

  static void _startLoading() {
    _isLoading.value = true;
  }

  static void _stopLoading() {
    _isLoading.value = false;
  }

  static void hide() {
    _stopLoading();

    if(file == null) {
      Navigator.pop(_context);
    
    } else {
      Navigator.pop(_context);
      Navigator.pop(_context);
    }

    _pickedFile = null;
    file = null;
  }

}