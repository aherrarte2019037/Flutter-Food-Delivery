import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/pages/roles/card_list.dart';
import 'package:food_delivery/src/pages/roles/roles_controller.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key? key}) : super(key: key);

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final RolesController _rolesController = RolesController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _rolesController.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 50, left: 42, right: 42, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _topSection(_rolesController),
            FutureBuilder(
              future: _rolesController.getUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  _rolesController.defaultButtonSelected(snapshot.data.roles);
                  return Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.06),
                        _profileSection(user: snapshot.data),
                        CardListWidget(roles: snapshot.data.roles),
                        SizedBox(height: height * 0.02),
                      ],
                    ),
                  );
                }
                return const Text('No Hay Datos');
              },
            ),
            _continueButton(_rolesController)
          ],
        ),
      ),
    );
  }
}

Widget _topSection(RolesController _roleController) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _backButton(_roleController),
      const Text(
        'Escoje un rol',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      _moreButton()
    ],
  );
}

Widget _backButton(RolesController _roleController) {
  return Transform.translate(
    offset: const Offset(-20, 0),
    child: ElevatedButton(
      onPressed: _roleController.logOut,
      child: const Icon(
        Icons.arrow_back_rounded,
        size: 30,
        color: Colors.black,
      ),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(2),
          fixedSize: const Size(48, 48),
          elevation: 0,
          primary: Colors.white,
          onPrimary: Colors.grey,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    ),
  );
}

Widget _moreButton() {
  return Transform.translate(
    offset: const Offset(20, 0),
    child: ElevatedButton(
      onPressed: () {},
      child: const Icon(
        Icons.more_horiz,
        size: 30,
        color: Colors.black,
      ),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(2),
          fixedSize: const Size(48, 48),
          elevation: 0,
          primary: Colors.white,
          onPrimary: Colors.grey,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    ),
  );
}

Widget _profileSection({required User user}) {
  return Container(
    width: double.infinity,
    height: 70,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(user.image!),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  RolesController.getRolesFormated(user),
                  style: const TextStyle(
                    color: Color(0XFF424C69),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    ),
  );
}

Widget _continueButton(RolesController _roleController) {
  return Container(
    height: 60,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        _roleController.goToSelectedPage();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Continuar', style: TextStyle(color: Colors.white)),
          const Icon(Icons.arrow_forward_rounded)
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
