part of 'message_bloc.dart';

@immutable
sealed class MessageState {}

final class MessageInitialState extends MessageState {}

final class MessageFailureState extends MessageState{
  final String message;

  MessageFailureState(this.message);

}

final class MessageSuccessState extends MessageState{
  final ChatModel chatModel;

  MessageSuccessState(this.chatModel);
}
final class ChatSuccessState extends MessageState{
  final  List<Chat> chats;

  ChatSuccessState(this.chats);
}

final class MessageLoadingState extends MessageState{}
