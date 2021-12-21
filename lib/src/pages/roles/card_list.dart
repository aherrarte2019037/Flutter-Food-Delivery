import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/role_model.dart';
import 'package:food_delivery/src/pages/roles/roles_controller.dart';

class CardListWidget extends StatefulWidget {
  final List<Role> roles;

  const CardListWidget({Key? key, required this.roles}) : super(key: key);

  @override
  _CardListWidgetState createState() => _CardListWidgetState();
}

class _CardListWidgetState extends State<CardListWidget> {
  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      precacheImage(const AssetImage('assets/images/client-role.png'), context);
      precacheImage(const AssetImage('assets/images/delivery-role.png'), context);
      precacheImage(const AssetImage('assets/images/restaurant-role.png'), context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 12),
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 35,
                );
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.roles.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: RolesController.getColorsByRole(widget.roles[index])['lightColor'],
                    boxShadow: [
                      BoxShadow(
                        color: RolesController.getColorsByRole(widget.roles[index])['lightColor']!.withOpacity(0.4),
                        spreadRadius: 0.1,
                        blurRadius: 7,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:AssetImage(widget.roles[index].image))),
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
                            padding: const EdgeInsets.only(right: 3, top: 1),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  RolesController.selectButton(widget.roles[index]);
                                });
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                backgroundColor: (() {
                                  if (RolesController.buttonsSelected[widget.roles[index].name]) return Colors.white;
                                  return RolesController.getColorsByRole(widget.roles[index])['darkColor'];
                                }()),
                              ),
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    RolesController.buttonsSelected[widget.roles[index].name]? 'Seleccionado':'Seleccionar',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      color: RolesController.getColorsByRole(widget.roles[index])['lightColor'],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(FlutterIcons.check_fea,
                                      color: RolesController.getColorsByRole(widget.roles[index])['lightColor'])
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
                                color: RolesController.getColorsByRole(widget.roles[index])['darkColor'],
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  RolesController.getTextRoleByRole(widget.roles[index]),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  RolesController.getIconsByRole(widget.roles[index])[0],
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
                                    RolesController.getIconsByRole(widget.roles[index])[1],
                                    color: RolesController.getColorsByRole(widget.roles[index])['lightColor'],
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
                                    RolesController.getIconsByRole(widget.roles[index])[2],
                                    color: RolesController.getColorsByRole(widget.roles[index])['lightColor'],
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
                                    RolesController.getIconsByRole(widget.roles[index])[3],
                                    color: RolesController.getColorsByRole(widget.roles[index])['lightColor'],
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
              }),
        ),
      ),
    );
  }
}
