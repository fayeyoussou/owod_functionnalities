import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owod_functionnalities/core/common/widgets/side_menu.dart';
import 'package:owod_functionnalities/core/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/chat_model.dart';
import '../bloc/message_bloc.dart';
import 'components/body.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key,this.chat});
  final ChatModel? chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            BackButton(),
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/user_2.png"),
            ),
            SizedBox(width: AppTheme.defaultPadding * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Youssoupha FAYE",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Active 3m ago",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),


      ),
      body:  Body(chat: chat,),
    );
  }


}
