
import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';

class BorderBox extends StatelessWidget {
  const BorderBox({
    Key? key,
  required this.child,
  this.padding = const EdgeInsets.all(8),
  this.width = 50,
  this.height = 50}) : super(key: key);

  final Widget child;
  final EdgeInsets padding;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
        height: height,
        decoration: BoxDecoration(
          color: COLOR_WHITE,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: COLOR_GREY.withAlpha(40), width: 2)
        ),
      padding: padding,
        child: Center(child: child,),
    );
  }
}
