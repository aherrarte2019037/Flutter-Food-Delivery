import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerWidget({required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[200]!,
        direction: ShimmerDirection.ttb,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            width: width,
            height: height,
            color: Colors.grey[400]!,
          ),
        ),
      ),
    );
  }
}