import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/widget_function.dart';


class AddTradeButton extends StatelessWidget {
  const AddTradeButton({
    Key? key,
  required this.text,
  required this.icon,
  required this.width,
  required this.onPressed}) : super(key: key);

  final String text;
  final IconData icon;
  final double width;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: FlatButton(
        color: COLOR_DARK_BLUE,
        splashColor: COLOR_WHITE.withAlpha(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, color: COLOR_WHITE,),
            addHorizontalSpace(10),
            Text(text, style: TextStyle(color: COLOR_WHITE),)
          ],
        ),
      ),
    );
  }
}
