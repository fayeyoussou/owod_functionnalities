import 'package:owod_functionnalities/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../features/messagerie/data/models/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/show_snackbar.dart';
import '../../../data/models/chat_model.dart';
import '../../bloc/message_bloc.dart';
import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatefulWidget {
  const Body({super.key, this.chat});

  final ChatModel? chat;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {


  ChatModel? chatmodel ;
  @override
  void initState() {
    final authState = context.read<AuthBloc>().state;
    print(widget.chat);
    if(widget.chat != null && authState is AuthSuccess ) {
      context.read<MessageBloc>().add(MessagesLoading(
          chatModel: widget.chat as ChatModel, userId: authState.user.id));
    }
    super.initState();
  }
  // @override
  // void dispose() {
  //   final authState = context.read<AuthBloc>().state;
  //   if(authState is AuthSuccess ) {
  //     context.read<MessageBloc>().add(ChatLoadingEvent(authState.user.id));
  //   }
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: BlocListener<MessageBloc, MessageState>(
              listener: (context, state) {
                if(state is MessageSuccessState){
                  setState(() {
                    chatmodel = state.chatModel;
                  });
                } else if(state is MessageFailureState){
                  showSnackBar(context, state.message);
                }
              },
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
                child: ListView.builder(
                  itemCount: chatmodel== null ? 0 : chatmodel?.messages
                      .length,
                  itemBuilder: (context, index) =>
                  chatmodel== null
                      ? Container()
                      : Message(
                      message: chatmodel?.messages[index] as MessageModel),
                ),
              ),
            )),
        const ChatInputField(),
      ],
    );
  }
}
