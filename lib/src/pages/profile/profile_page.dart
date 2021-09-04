import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery/src/utils/current_user_role.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/pages/profile/profile_controller.dart';
import 'package:food_delivery/src/utils/string_extension.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _profileController = ProfileController();

  updateView() {
    setState(() => {});
  }

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _profileController.init(context, updateView);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          height: height - 120,
          width: width,
          color: Colors.white,
          padding: EdgeInsets.only(left: 42, right: 42, top: height * 0.02),
          child: Column(
            children: [
              SizedBox(height: height * 0.03),
              _profileController.userProfile == null
                ? const SizedBox.shrink()
                : Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _profilePhoto(_profileController.userProfile!.image!),
                          _joinedText(_profileController.userProfile!.createdAt!)
                        ],
                      ),
                      const SizedBox(height: 30),
                      _nameText(_profileController.userProfile!.firstName, _profileController.userProfile!.lastName),
                      SizedBox(height: height * 0.05),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textField(label: 'Nombre', controller: _profileController.controllers['firstName']!),
                            _textField(label: 'Apellido', controller: _profileController.controllers['lastName']!),
                            _textField(label: 'Correo Electrónico', controller: _profileController.controllers['email']!),
                            SizedBox(height: height * 0.015),
                            _editButton()
                          ],
                        ),
                      )
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _profileController.goBack,
              child: const Icon(Icons.arrow_back_rounded, size: 30, color: Colors.black),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(2),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            const Text(
              'Perfil De Usuario',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 2),
              child: ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.more_horiz, size: 30, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(2),
                  elevation: 0,
                  primary: Colors.white,
                  onPrimary: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePhoto(String image) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 145,
            width: 145,
            child: image.contains('assets')
                ? Image.asset(
                    image,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.assetNetwork(
                    height: 70,
                    width: 70,
                    image: image,
                    placeholder: 'assets/images/loading.gif',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: ElevatedButton(
            onPressed: _profileController.showImageDialog,
            child: const Icon(FlutterIcons.edit_ent, size: 20, color: Colors.white),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(54, 54),
              elevation: 0,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              primary: Colors.black,
              onPrimary: Colors.white,
              side: const BorderSide(color: Colors.white, width: 3.5),
            ),
          ),
        ),
      ],
    ); 
  }

  Widget _joinedText(DateTime dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Se unió',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          timeago.format(dateTime).capitalize(),
          style: const TextStyle(
            color: Color(0XFF282828),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget _nameText(String firsName, String lastName) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firsName,
              style: const TextStyle(
                  fontSize: 38,
                  color: Color(0XFF292929),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              lastName,
              style: const TextStyle(
                  fontSize: 38,
                  color: Color(0XFF292929),
                  fontWeight: FontWeight.w500,
                  height: 1.05),
            ),
          ],
        ),
          Column(
            children: [
              const SizedBox(height: 5),
              _profileController.userProfile!.roles!.length > 1
                ? const Padding(
                  padding: EdgeInsets.only(top: 9),
                  child: Text(
                    'Rol actual',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                )
                : const SizedBox.shrink(),
              Chip(
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                avatar: Transform.translate(
                  offset: const Offset(0, -2),
                  child: const Icon(Icons.check_rounded),
                ),
                label: Text(
                  CurrentUserRole.getCurrentRole().roleFormat(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black, width: 1.5),
                elevation: 0,
                shadowColor: Colors.grey[60],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textField({ required String label, required TextEditingController controller }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0XFF838383), fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          readOnly: _profileController.isEditing ? false : true,
          controller: controller,
          cursorColor: Colors.grey,
          style: const TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0XFFC7C7C7), width: 1),
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0XFF525252), width: 1),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _editButton() {
    return Container(
      height: 60,
      child: ElevatedButton(
        onPressed: _profileController.editUser,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _profileController.isEditing ? 'Confirmar' : 'Editar',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(bottom: _profileController.isEditing ? 4 : 3),
              child: _profileController.editIsLoading
                ? Container(
                  width: 20,
                  height: 20,
                  child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : Icon(
                  _profileController.isEditing
                    ? FlutterIcons.md_checkmark_ion
                    : FlutterIcons.edit_ent,
                  size: _profileController.isEditing
                    ? 28
                    : 22,
                  ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          primary: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(
            fontSize: 16.5, letterSpacing: 0.5, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

}