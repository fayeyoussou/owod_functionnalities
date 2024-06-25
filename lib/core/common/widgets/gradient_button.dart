import 'package:owod_functionnalities/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {super.key, required this.message, required this.onPressed});
  final String message;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: const LinearGradient(
              colors: [AppPalette.gradient1, AppPalette.gradient2],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppPalette.transparentColor,
            fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 55),
            shadowColor: AppPalette.transparentColor),
        child: Text(
          message,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
