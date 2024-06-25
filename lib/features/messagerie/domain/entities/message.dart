import 'package:equatable/equatable.dart';

enum MessageContentType { text, image, audio }

enum MessageStatus {notSent,sent,read}

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final MessageContentType contentType;
  final String content;
  final String? description;
  final DateTime createdAt;
  final MessageStatus status;

  const Message({
    required this.status,
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.contentType,
    required this.content,
    this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}