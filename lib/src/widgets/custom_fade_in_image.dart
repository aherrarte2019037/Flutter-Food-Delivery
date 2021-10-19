import 'package:flutter/material.dart';

class CustomFadeInImage extends StatelessWidget {
  final String image;
  final String placeholder;
  final BoxFit fit;
  final Size size;

  const CustomFadeInImage({Key? key, required this.image, required this.placeholder, required this.fit, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image.contains('assets')
      ? Image.asset(
          image,
          fit: BoxFit.cover,
        )
      : FadeInImage.assetNetwork(
          height: size.height,
          width: size.width,
          image: image,
          placeholder: placeholder,
          fit: fit,
        );
  }
  
}