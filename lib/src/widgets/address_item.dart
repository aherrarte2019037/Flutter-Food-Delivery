import 'package:flutter/material.dart';

class AddressItem<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String name;
  final String address;
  final ValueChanged<T?> onChanged;

  const AddressItem({
    required this.value,
    required this.groupValue,
    required this.name,
    required this.address,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return Container(
      width: double.infinity,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            isSelected ? 'assets/images/location.png' : 'assets/images/location-disabled.png',
            fit: BoxFit.contain,
            height: 45,
            width: 45,
          ),
          const SizedBox(width: 18),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Color(isSelected ? 0XFFFF8C3E : 0XFFA4A9B5),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                address,
                style: const TextStyle(
                  color: Color(0XFF34353B),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Transform.translate(
            offset: const Offset(0, 10),
            child: Radio(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: const Color(0XFFFF8C3E),
            ),
          ),
        ],
      ),
    );
  }
}