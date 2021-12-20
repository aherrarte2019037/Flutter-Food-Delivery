import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/pages/client/payment/list/client_payment_list_controller.dart';
import 'package:food_delivery/src/widgets/payment_card_item.dart';

class ClientPaymentListPage extends StatefulWidget {
  const ClientPaymentListPage({Key? key}) : super(key: key);

  @override
  _ClientPaymentListPageState createState() => _ClientPaymentListPageState();
}

class _ClientPaymentListPageState extends State<ClientPaymentListPage> {
  final _controller = ClientPaymentListController();

  void updateView() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      Address address = ModalRoute.of(context)?.settings.arguments as Address;
      _controller.init(context, updateView, address);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      bottomNavigationBar: _payButton(),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 42, right: 42),
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                _bannerImage(),
                const SizedBox(height: 35),
                _paymentMethodList(),
                const SizedBox(height: 15),
              ],
            ),
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
              onPressed: _controller.goBack,
              child: const Icon(Icons.arrow_back_rounded,
                  size: 30, color: Colors.black),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(2),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            const Text(
              'Método de pago',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(2),
                shadowColor: Colors.transparent,
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child:
                  const Icon(Icons.more_horiz, size: 30, color: Colors.black),
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
          image: AssetImage('assets/images/client-payment-list.gif'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _paymentMethodList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Métodos de pago',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Selecciona una opción',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF999999),
                  ),
                ),
              ],
            ),
            _addPaymentCardButton(),
          ],
        ),
        const SizedBox(height: 32),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _controller.paymentCards.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (_, index) => PaymentCardItem(
            value: _controller.paymentCards[index].createdAt.toString(),
            groupValue: _controller.paymentCardSelected,
            card: _controller.paymentCards[index],
            onChanged: _controller.paymentCardItemChanged(),
          ),
        ),
      ],
    );
  }

  Widget _addPaymentCardButton() {
    return OutlinedButton.icon(
      onPressed: _controller.addPaymentCard,
      label: const Text(
        'Añadir',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
      icon: const Icon(Icons.add_rounded, color: Colors.white, size: 23),
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        side: const BorderSide(style: BorderStyle.none),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        padding: const EdgeInsets.only(top: 11.5, bottom: 11.5, left: 16, right: 23),
      ),
    );
  }

  Widget _payButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42, top: 20),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: _controller.pay,
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            primary: Colors.black.withOpacity(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: const TextStyle(
              fontSize: 16.5,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Finalizar Compra', style: TextStyle(color: Colors.white)),
              const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Icon(FlutterIcons.shopping_bag_ent, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
