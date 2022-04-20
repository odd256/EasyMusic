/*
 * @Creator: Odd
 * @Date: 2022-04-20 14:32:00
 * @LastEditTime: 2022-04-20 16:07:54
 * @FilePath: \flutter_easymusic\lib\global_widgets\custom_shimmer.dart
 */
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomShimmer.rectangular(
      {this.width = double.infinity, required this.height, Key? key})
      : shapeBorder = const RoundedRectangleBorder(),
        super(key: key);

  const CustomShimmer.circle(
      {this.width = double.infinity, required this.height, Key? key})
      : shapeBorder = const CircleBorder(),
        super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!);
}
