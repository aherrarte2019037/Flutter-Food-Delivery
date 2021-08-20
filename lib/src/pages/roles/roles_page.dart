import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/role_model.dart';
import 'package:food_delivery/src/pages/roles/roles_controller.dart';
import 'package:logger/logger.dart';

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
        padding:
            const EdgeInsets.only(top: 60, left: 42, right: 42, bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _topSection(),
            _profileSection(),
            FutureBuilder(
              future: _rolesController.getUserRoles(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  List<Role> roles = snapshot.data;
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 40,
                      );
                    },
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: roles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _roleCard(roles[index]);
                    },
                  );
                }
                return const Text('no tiene data');
              },
            ),
            const SizedBox(height: 0),
            _continueButton()
          ],
        ),
      ),
    );
  }
}

Widget _topSection() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _backButton(),
      const Text(
        'Escoje un rol',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      _moreButton()
    ],
  );
}

Widget _roleCard(Role role) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: RolesController.getColorsByRole(role)['lightColor'],
      boxShadow: [
        BoxShadow(
          color: RolesController.getColorsByRole(role)['lightColor']!
              .withOpacity(0.45),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 8), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(32),
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: AssetImage(role.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 165,
              height: 40,
              padding: const EdgeInsets.only(right: 4, top: 1),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                  primary: Colors.white,
                  onPrimary: const Color(0XFF879EF3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Seleccionada',
                      style: TextStyle(
                        fontSize: 14.5,
                        color:
                            RolesController.getColorsByRole(role)['lightColor'],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      FlutterIcons.check_fea,
                      color:
                          RolesController.getColorsByRole(role)['lightColor'],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 165,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: RolesController.getColorsByRole(role)['darkColor'],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    RolesController.getTextRoleByRole(role),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    RolesController.getIconsByRole(role)[0],
                    size: 24,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 165,
              transform: Matrix4.translationValues(0, -2, 0),
              padding: const EdgeInsets.only(right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Icon(
                      RolesController.getIconsByRole(role)[1],
                      color:
                          RolesController.getColorsByRole(role)['lightColor'],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Icon(
                      RolesController.getIconsByRole(role)[2],
                      color:
                          RolesController.getColorsByRole(role)['lightColor'],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Icon(
                      RolesController.getIconsByRole(role)[3],
                      color:
                          RolesController.getColorsByRole(role)['lightColor'],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget _backButton() {
  return Transform.translate(
    offset: const Offset(-20, 0),
    child: ElevatedButton(
      onPressed: () {},
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    ),
  );
}

Widget _profileSection() {
  return Container(
    width: double.infinity,
    height: 70,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1621290558426-f2c5e19cfac7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80'),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Angel Herrarte',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Cliente • Delivery',
                  style: TextStyle(
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

Widget _continueButton() {
  return Container(
    height: 60,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(
              fontSize: 16.5, letterSpacing: 0.5, fontWeight: FontWeight.w500)),
    ),
  );
}