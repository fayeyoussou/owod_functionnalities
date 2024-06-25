import 'package:owod_functionnalities/core/theme/app_pallete.dart';
import 'package:owod_functionnalities/core/theme/theme.dart';
import 'package:owod_functionnalities/features/messagerie/data/models/message_model.dart';
import 'package:flutter/material.dart';


class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final MessageModel? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: MediaQuery.of(context).platformBrightness == Brightness.dark
      //     ? Colors.white
      //     : Colors.black,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.defaultPadding * 0.75,
        vertical: AppTheme.defaultPadding  / 2,
      ),
      decoration: BoxDecoration(
        color: AppPalette.gradient1.withOpacity(message!.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message!.content,
        style: TextStyle(
          color: message!.isSender
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}
