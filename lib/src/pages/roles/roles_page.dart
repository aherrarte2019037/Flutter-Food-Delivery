import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        padding: const EdgeInsets.only(top: 70, left: 42, right: 42, bottom: 50),
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
              ),
            ),
            _columnSpace(),
            Expanded(
              flex: 1,
              child: Container(
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
              ),
            ),
            _columnSpace(),
            Expanded(
              flex: 1,
              child: Container(
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
                      'https://images.unsplash.com/photo-1621290558426-f2c5e19cfac7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80'),
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
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Cliente • Delivery',
                  style: TextStyle(
                    color: Color(0XFFFD9176),
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
        elevation: 4.5,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        primary: const Color(0XFF030303),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(
          fontSize: 16.5,
          letterSpacing: 0.65,
          fontWeight: FontWeight.w500
        )
      ),
    ),
  );
}

Widget _columnSpace() {
  return const SizedBox(height: 40);
}
