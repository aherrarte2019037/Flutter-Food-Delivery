import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key? key}) : super(key: key);

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
        padding:
            const EdgeInsets.only(top: 70, left: 42, right: 42, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topSection(),
            _columnSpace(),
            _profileSection(),
            _columnSpace(),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0XFF879EF3),
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0XFFC1CEFF),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 8), // changes position of shadow
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
                            image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/restaurant-role.png'),
                                fit: BoxFit.cover)),
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
                                const Text(
                                  'Seleccionada',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    color: Color(0XFF7C93E6),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  FlutterIcons.check_fea,
                                  color: Color(0XFF879EF3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 165,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: const Color(0XFF5D78D4),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Restaurante',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(
                                Icons.restaurant_menu,
                                size: 24,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
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
                                child: const Icon(
                                  FlutterIcons.chart_donut_mco,
                                  color: Color(0XFF879EF3),
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  FlutterIcons.ios_build_ion,
                                  color: Color(0XFF879EF3),
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  FlutterIcons.food_variant_mco,
                                  color: Color(0XFF879EF3),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            _columnSpace(),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0XFF39CBDE),
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0XFFADE3EC),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 8), // changes position of shadow
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
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/client-role.png'),
                                fit: BoxFit.cover)),
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
                              onPrimary: const Color(0XFF39CBDE),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Seleccionada',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    color: Color(0XFF39CBDE),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  FlutterIcons.check_fea,
                                  color: Color(0XFF39CBDE),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 165,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: const Color(0XFF12A6B9),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Cliente',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(
                                Icons.shopping_cart,
                                size: 23,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
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
                                child: const Icon(
                                  FlutterIcons.attach_money_mdi,
                                  color: Color(0XFF39CBDE),
                                  size: 26,
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white,
                                ),
                                child: Container(
                                  transform:
                                      Matrix4.translationValues(0, -1.5, 0),
                                  child: const Icon(
                                    FlutterIcons.shopping_bag_faw,
                                    size: 20,
                                    color: Color(0XFF39CBDE),
                                  ),
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  FlutterIcons.person_mdi,
                                  size: 25,
                                  color: Color(0XFF39CBDE),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            _columnSpace(),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0XFF39B4DE),
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0XFFACE5F9),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 8), // changes position of shadow
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
                            image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/delivery-role.png'),
                                fit: BoxFit.cover)),
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
                              onPrimary: const Color(0XFF39B4DE),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Seleccionada',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    color: Color(0XFF39B4DE),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  FlutterIcons.check_fea,
                                  color: Color(0XFF39B4DE),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 165,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: const Color(0XFF1294C3),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Repartidor',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(
                                Icons.delivery_dining,
                                size: 26,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
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
                                child: const Icon(
                                  FlutterIcons.ios_alarm_ion,
                                  color: Color(0XFF39B4DE),
                                  size: 26,
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white,
                                ),
                                child: Container(
                                  transform:
                                      Matrix4.translationValues(1, -1, 0),
                                  child: const Icon(
                                    FlutterIcons.pin_ent,
                                    size: 20,
                                    color: Color(0XFF39B4DE),
                                  ),
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  FlutterIcons.shopping_bag_ent,
                                  size: 22,
                                  color: Color(0XFF39B4DE),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            _columnSpace(),
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

Widget _columnSpace() {
  return const SizedBox(height: 35);
}
