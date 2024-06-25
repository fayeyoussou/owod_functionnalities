part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}

class MessageUploadingEvent extends MessageEvent{
  final File? media;
  final String userId;
  final String? content;
  final String? description;
  final ChatModel? chat;
  final MessageContentType contentType;

  MessageUploadingEvent({
    this.media,
    required this.userId,
    this.content,
    this.description,
    this.chat,
    required this.contentType,
  });
}
final class MessagesLoading extends MessageEvent{
  final ChatModel chatModel;
  final String userId;

  MessagesLoading({required this.chatModel, required this.userId});



}
final class ChatLoadingEvent extends MessageEvent{
  final String userId;
  ChatLoadingEvent(this.userId);
}