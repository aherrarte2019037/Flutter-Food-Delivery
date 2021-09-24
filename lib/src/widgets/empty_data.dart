import 'package:flutter/material.dart';

class EmpyData extends StatelessWidget {
  final double height;
  final double imageHeight;
  final double width;
  final double imageWidth;
  final String text;

  const EmpyData({ required this.height, required this.width, required this.text, required this.imageHeight, required this.imageWidth });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(-6, 0),
            child: Container(
              width: imageWidth,
              height: imageHeight,
              child: Image.asset(
                'assets/images/empty-image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}