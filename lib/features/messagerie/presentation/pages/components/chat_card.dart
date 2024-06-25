import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/theme/theme.dart';
import '../../../domain/entities/chat.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chat,
    required this.press,
  });
  String formatDateWithTime(DateTime date) {
    final now = DateTime.now();
    final formatterDate = DateFormat('dd/MM');
    final formatterDateTime = DateFormat('dd/MM/yyyy HH:mm');
    final formatterTime = DateFormat('HH:mm');

    // Calculate the difference in days between now and the input date
    int differenceInDays = now.difference(date).inDays;

    // Check if the date is today
    if (differenceInDays == 0) {
      return 'today ${formatterTime.format(date)}';
    }
    // Check if the date is yesterday
    else if (differenceInDays == 1) {
      return 'yesterday ${formatterTime.format(date)}';
    }
    // If the date is within the same year but not today or yesterday
    else if (date.year == now.year) {
      return '${formatterDate.format(date)} ${formatterTime.format(date)}';
    }
    // If the date is in a different year
    else {
      return formatterDateTime.format(date);
    }
  }
  final Chat chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.defaultPadding, vertical: AppTheme.defaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/user_5.png'),
                ),
                if (true)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: AppPalette.gradient1,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.userId,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat.id??'',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(formatDateWithTime(chat.createdAt)),
            ),
          ],
        ),
      ),
    );
  }
}
