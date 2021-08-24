import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/pages/client/product/list/client_product_list_controller.dart';

class ClientProductListPage extends StatefulWidget {
  const ClientProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ClientProductListPage> {
  final ClientProductListController _productListController =
      ClientProductListController();

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _productListController.init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userDrawer(),
    );
  }

  Widget _userDrawer() {
    return SafeArea(
      top: false,
      child: Drawer(
        child: Material(
          color: const Color(0XFF496FD6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 60),
                _profileSection(),
                const SizedBox(height: 20),
                _drawerItem(title: 'Perfil', icon: FlutterIcons.md_person_ion),
                const SizedBox(height: 20),
                _drawerItem(title: 'Ajustes', icon: FlutterIcons.setting_ant),
                const SizedBox(height: 20),
                _drawerItem(title: 'Compras', icon: FlutterIcons.shopping_cart_faw),
                const SizedBox(height: 10),
                _drawerItem(title: 'Roles', icon: FlutterIcons.md_apps_ion),
                const SizedBox(height: 20),
                _drawerItem(title: 'Notificaciones', icon: FlutterIcons.bell_mco),
                const Spacer(),
                _buttonLogout(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({required String title, required IconData icon}) {
    return ListTile(
      onTap: () {},
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
      onPressed: _productListController.logOut,
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

  Widget _profileSection() {
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
            Flexible(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1/1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1621290558426-f2c5e19cfac7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80'),
                    ),
                  ),
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
                    const Text(
                      'Angel Herrarte',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'angelherrarte3@gmail.com',
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

}
