import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/user_model.dart';
import 'package:food_delivery/src/utils/shared_pref.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/widgets/drawer/user_drawer_controller.dart';

class UserDrawer extends StatefulWidget {
  final String drawerType;

  UserDrawer({Key? key, required this.drawerType}) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final UserDrawerController _drawerController = UserDrawerController();

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _drawerController.init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _drawer();
  }

  Widget _drawer() {
    return Drawer(
      child: Material(
        color: const Color(0XFF496FD6),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 35),
          child: FutureBuilder(
            future: _getUser(),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                User user = snapshot.data;
                return Column(
                  children: [
                    _profileSection(user),
                    Expanded(
                      child: ListView.separated(
                        primary: false,
                        itemCount: _drawerController.getDrawerItems(user, widget.drawerType).length,
                        separatorBuilder: (_,__) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (_, int index) {
                          return _drawerItem(
                            title: _drawerController.getDrawerItems(user, widget.drawerType)[index]['title'],
                            icon: _drawerController.getDrawerItems(user, widget.drawerType)[index]['icon'],
                            route: _drawerController.getDrawerItems(user, widget.drawerType)[index]['route'],
                          );
                        },
                      ),
                    ),
                    if (user.roles!.length > 1) ...[
                      _drawerItem(title: 'Roles', icon: FlutterIcons.md_grid_ion, route: 'roles'),
                      const Spacer(),
                    ],
                    _buttonLogout(),
                  ],
                );
              }

              return const Text('No Hay Datos');
            },
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({required String title, required IconData icon, required String route}) {
    return ListTile(
      onTap: () {
        _drawerController.drawerItemNavigate(route);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      hoverColor: Colors.white,
    );
  }

  Widget _buttonLogout() {
    return ElevatedButton(
      onPressed: () {
        SharedPref.logOut();
        Future.delayed(const Duration(milliseconds: 180), () {
          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
        primary: Colors.white,
        onPrimary: const Color(0XFF496FD6),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Cerrar Sesión',
            style: TextStyle(
              color: Color(0XFF496FD6),
              fontSize: 14.5
            ),
          ),
          const Icon(FlutterIcons.md_arrow_forward_ion, color: Color(0XFF496FD6))
        ],
      ),
    );
  }

  Widget _profileSection(User user) {
    return Container(
      height: 152,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0XFF324D94).withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 70,
                width: 70,
                child: user.image!.contains('assets')
                  ? Image.asset(
                      user.image!,
                      fit: BoxFit.cover,
                    )
                  : FadeInImage.assetNetwork(
                      height: 70,
                      width: 70,
                      image: user.image!,
                      placeholder: 'assets/images/loading.gif',
                      fit: BoxFit.cover,
                    ),
                ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName.capitalize()} ${user.lastName.capitalize()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
        _profileChip()
        ],
      ),
    );
  }

  Widget _profileChip() {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7, right: 10, left: 13.5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            FlutterIcons.shopping_cart_faw,
            color: Colors.white,
            size: 16,
          ),
          const Text(
            'Compras Realizadas',
            style: TextStyle(color: Colors.white),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: const Center(
              child: Text(
                '1',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> _getUser() async {
    User user = User.fromJson(await SharedPref.read('user'));
    return user;
  }

}
