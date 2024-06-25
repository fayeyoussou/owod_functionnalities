import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owod_functionnalities/core/common/cubits/menu/menu_cubit.dart';
import 'package:owod_functionnalities/core/theme/app_pallete.dart';
import 'package:owod_functionnalities/core/utils/show_snackbar.dart';
import 'package:owod_functionnalities/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:owod_functionnalities/features/messagerie/data/models/chat_model.dart';

import '../../../../core/common/widgets/filled_outline_button.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/common/widgets/side_menu.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/message_bloc.dart';
import 'components/chat_card.dart';
import 'message_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String userId = '';

  @override
  void initState() {
    final authState = context.read<AuthBloc>().state;
    if(authState is AuthSuccess ) {
      userId = authState.user.id;
      context.read<MessageBloc>().add(ChatLoadingEvent(authState.user.id));
    }
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:  SideMenu(scaffoldKey: _scaffoldKey,),
      appBar: AppBar(

        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/messages');
              },
              icon: const Icon(Icons.add_comment_outlined))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(AppTheme.defaultPadding, 0,
                AppTheme.defaultPadding, AppTheme.defaultPadding),
            color: AppPalette.gradient1,
            child: Row(
              children: [
                FillOutlineButton(press: () {}, text: "Recent Message"),
                const SizedBox(width: AppTheme.defaultPadding),
                FillOutlineButton(
                  press: () {},
                  text: "Active",
                  isFilled: false,
                ),
              ],
            ),
          ),
          BlocConsumer<MessageBloc, MessageState>(
            listener: (context, state) {
              if(state is MessageFailureState){
                showSnackBar(context, state.message,AppPalette.errorColor);
              }else if(state is MessageSuccessState){
                context.read<MessageBloc>().add(ChatLoadingEvent(userId));
              }
            },
            builder: (context, state) {
              if(state is ChatSuccessState ){
                final chats = state.chats;
                return Expanded(
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) => ChatCard(
                      chat: chats[index],
                      press: () => Navigator.of(context).pushNamed('/messages',
                        arguments: chats[index],)
                    ),
                  ),
                );
              }
              else {
                return const Loader();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(ChatListScreen oldWidget) {
    print('call didUpdate');
  }
  @override
  void didChangeDependencies() {
    print('call change');
    super.didChangeDependencies();
  }
}
