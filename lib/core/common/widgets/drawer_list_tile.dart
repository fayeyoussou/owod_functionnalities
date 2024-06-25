import 'package:flutter/material.dart';
import 'package:owod_functionnalities/core/theme/app_pallete.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  final Icon icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Padding(
        padding: const EdgeInsets.only(right : 8.0),
        child: icon,
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppPalette.gradient3),
      ),
    );
  }
}