import '../../../../../core/theme/app_pallete.dart';
import '../../../../../features/messagerie/data/models/message_model.dart';
import '../../../../../features/messagerie/domain/entities/message.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'video_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;
  static const kDefaultPadding =  AppTheme.defaultPadding;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(MessageModel message) {
      switch (message.contentType) {
        case MessageContentType.text:
          return TextMessage(message: message);
        case MessageContentType.audio:
          return AudioMessage(message: message);
        case MessageContentType.image:
          return  VideoMessage(messageModel: message,);
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage("assets/images/user_2.png"),
            ),
            const SizedBox(width: kDefaultPadding / 2),
          ],
          messageContaint(message),
          if (message.isSender) MessageStatusDot(status: message.status)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.notSent:
          return AppPalette.errorColor;
        case MessageStatus.sent:
          return Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1);
        case MessageStatus.read:
          return AppPalette.gradient1;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: AppTheme.defaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.notSent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
