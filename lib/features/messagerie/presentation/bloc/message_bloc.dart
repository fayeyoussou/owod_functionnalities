import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/chat_model.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/create_message.dart';
import '../../domain/usecases/load_chat.dart';
import '../../domain/usecases/load_chat_list.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final CreateMessage _createMessage;
  final LoadChat _loadChat;

  final LoadChatList _loadChatList;

  MessageBloc(
      {required CreateMessage createMessage, required LoadChat loadChat,required LoadChatList loadChatList})
      : _createMessage = createMessage,
        _loadChat = loadChat,
        _loadChatList = loadChatList,
        super(MessageInitialState()) {
    on<MessageEvent>((event, emit) async {
      if (!emit.isDone) {
        emit(MessageLoadingState());
      }
    });
    on<MessageUploadingEvent>(_uploadMessage);
    on<MessagesLoading>(_loadMessage);
    on<ChatLoadingEvent>(_loadChats);
  }

  void _loadMessage(MessagesLoading event, Emitter<MessageState> emit) async {
    var res = await _loadChat(LoadChatParams(chatModel: event.chatModel, userId: event.userId));
      res.fold(
            (fail) => emit(MessageFailureState(fail.message)),
            (success) => emit(MessageSuccessState(success)),
      );

  }
  void _loadChats(ChatLoadingEvent event, Emitter<MessageState> emit) async {
    var res = await _loadChatList(LoadChatListParams(event.userId));

      res.fold(
            (fail) {
              emit(MessageFailureState(fail.message));
            },
            (success) {
              emit(ChatSuccessState(success));
            }
      );

  }

  void _uploadMessage(
      MessageUploadingEvent event, Emitter<MessageState> emit) async {
    var result = await _createMessage(
      CreateMessageParams(
        media: event.media,
        userId: event.userId,
        content: event.content,
        description: event.description,
        chat: event.chat,
        contentType: event.contentType,
      ),
    );


      result.fold(
        (fail)  {
          emit(MessageFailureState(fail.message));
        },
        (success) {
          emit(MessageSuccessState(success));
        },
      );

  }
}
