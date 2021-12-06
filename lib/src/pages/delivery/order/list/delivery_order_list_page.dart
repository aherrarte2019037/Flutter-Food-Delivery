import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/delivery/order/list/delivery_order_list_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:food_delivery/src/widgets/drawer/user_drawer.dart';

class DeliveryOrderListPage extends StatefulWidget {
  const DeliveryOrderListPage({Key? key}) : super(key: key);

  @override
  _DeliveryOrderListPageState createState() => _DeliveryOrderListPageState();
}

class _DeliveryOrderListPageState extends State<DeliveryOrderListPage> {
  final DeliveryOrderListController _controller = DeliveryOrderListController();

  updateView() => setState(() {});

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, updateView);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      key: _controller.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _appBar(),
      drawer: UserDrawer(drawerType: 'DELIVERY'),
      body:  Container(
        padding: const EdgeInsets.only(left: 42, right: 42),
        height: height,
        width: width,
        child: SingleChildScrollView(
          controller: _controller.scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _bannerImage(),
              const SizedBox(height: 30),
              _welcomeSection(),
              const SizedBox(height: 20),
              _searchBar(),
               const SizedBox(height: 35),
              _orderStatusChipSection(),
              const SizedBox(height: 40),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _controller.ordersGrouped.keys.length,
                separatorBuilder: (_, __) => const SizedBox(height: 40),
                itemBuilder: (_, index) {
                  if (_controller.ordersGrouped.keys.isEmpty) return const SizedBox.shrink();
                  OrderStatus status = EnumToString.fromString(OrderStatus.values, _controller.ordersGrouped.keys.toList()[index])!;

                  return _orderStatusList(status);
                },
              ),
              const SizedBox(height: 42),
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: const Offset(0, 0.5),
                child: ElevatedButton(
                  onPressed: _controller.openDrawer,
                  child: const Icon(FlutterIcons.align_left_fea, size: 26, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(2),
                    elevation: 0,
                    primary: Colors.white,
                    onPrimary: Colors.grey,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 14),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Inicio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerImage() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: AssetImage('assets/images/delivery-order-list.gif'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _welcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bienvenido,', style: TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          '${_controller.user?.firstName.capitalize() ?? ''} ${_controller.user?.lastName.capitalize() ?? ''}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0XFFf3f5f9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
              border: InputBorder.none,
              hintText: 'Buscar orden',
              hintStyle: const TextStyle(color: Color(0XFF9FA6C1), fontWeight: FontWeight.w400, fontSize: 15.5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Ink(
          decoration: ShapeDecoration(
            color: const Color(0XFFFF8C3E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          ),
          child: Transform.translate(
            offset: const Offset(0, -1),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(FlutterIcons.search1_ant, color: Colors.white),
              padding: const EdgeInsets.all(14.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _orderStatusChipSection() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado',
            style: TextStyle(color: Color(0XFF292929), fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 55,
              child: _controller.orderStatusChipsIsLoading
                ? Container(
                    padding: const EdgeInsets.all(10),
                    width: 55,
                    height: 50,
                    child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                  )
                : AnimatedList(
                    key: _controller.orderStatusListKey,
                    scrollDirection: Axis.horizontal,
                    initialItemCount: _controller.statusList.length,
                    itemBuilder: (_, index, animation) {
                      OrderStatus status = EnumToString.fromString(OrderStatus.values, _controller.statusList[index])!;

                      return _orderStatusChip(status, animation, index);
                    },
                  )
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderStatusChip(OrderStatus status, Animation<double> animation, int index) {    
    return Padding(
      padding: EdgeInsets.only(right: index + 1 < _controller.statusList.length ? 12 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
          color: const Color(0XFFF2F2F2),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () => _controller.scrollToStatus(status),
            child: SlideTransition(
              position: animation.drive(Tween(begin: const Offset(1, 0), end: const Offset(0, 0))),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            _controller.statusImages[status]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      EnumToString.convertToString(status, camelCase: true),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderStatusList(OrderStatus status) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  EnumToString.convertToString(status, camelCase: true).titleCase(),
                  style: const TextStyle(color: Color(0XFF292929), fontSize: 18,fontWeight: FontWeight.w500),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Row(
                  children: [
                    const Text(
                      'Ver Todo',
                      style: TextStyle(color: Color(0XFFFF8C3E), fontSize: 13.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5),
                    Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0XFFFF8C3E),
                    ),
                    child: Transform.translate(
                      offset: const Offset(0, -1),
                      child: const Icon(FlutterIcons.plus_ent, size: 15, color: Colors.white),
                    ),
                  ),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                  primary: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 220,
            child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _controller.ordersGrouped[EnumToString.convertToString(status).toUpperCase()]!.length,
              itemBuilder: (_, index) {
                Order order = _controller.ordersGrouped[EnumToString.convertToString(status).toUpperCase()]![index];
                return _orderCard(order);
              },
            ),
          ),
        ]
      ),
    );
  }

  Widget _orderCard(Order order) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: GestureDetector(
        onTap: () => _controller.showOrderDetailModal(order),
        child: Container(
          width: 175,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0XFFF8F8F8),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(FlutterIcons.clock_faw5, size: 12.5, color: Color(0XFF292929)),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    timeago.format(order.createdAt!).capitalize(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF292929)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                height: 52,
                width: 52,
                padding: const EdgeInsets.only(bottom: 1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: _controller.statusColors[order.status]!.withOpacity(0.2),
                ),
                child: _controller.statusIcons[order.status],
              ),
              const SizedBox(height: 13),
              Text(
                order.address?.address?.titleCase() ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0XFF292929),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cliente',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                          color: Color(0XFF292929),
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        '${order.user?.firstName.capitalize()} ${order.user?.lastName[0].capitalize()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.5,
                          color: Color(0XFF292929),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _controller.showOrderDetailModal(order),
                    icon: const Icon(FlutterIcons.more_horizontal_fea, size: 19, color: Colors.white),
                    label: const Text(''),
                    style: OutlinedButton.styleFrom(
                      elevation: 4,
                      primary: Colors.white,
                      fixedSize: const Size(35, 35),
                      minimumSize: const Size(35, 35),
                      padding: const EdgeInsets.only(left: 8, right: 0, top: 0, bottom: 2.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Colors.black,
                      side: BorderSide.none,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}