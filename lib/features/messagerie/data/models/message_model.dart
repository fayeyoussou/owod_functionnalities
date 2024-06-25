import 'dart:io';

import '../../domain/entities/message.dart';

class MessageModel extends Message {
  File? media;
  bool isSender =true;
  MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.contentType,
    required super.content,
    required super.status,
    super.description,
    required super.createdAt,
    this.media
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());

    return MessageModel(
      id: json['id'],
      status: _messageStatusFromString(json['status']) ,
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      contentType: _messageContentTypeFromString(json['content_type']),
      content: json['content'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  static MessageStatus _messageStatusFromString(String status) {
    switch (status) {
      case 'notSent':
        return MessageStatus.notSent;
      case 'sent':
        return MessageStatus.sent;
      case 'read':
        return MessageStatus.read;
      default:
        throw Exception('Unknown status: $status');
    }
  }
  static MessageContentType _messageContentTypeFromString(String contentType) {
    switch (contentType) {
      case 'text':
        return MessageContentType.text;
      case 'image':
        return MessageContentType.image;
      case 'audio':
        return MessageContentType.audio;
      default:
        throw Exception('Unknown content type: $contentType');
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content_type': contentType.name,
      'status' : status.name,
      'content': content,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    MessageContentType? contentType,
    String? content,
    String? description,
    DateTime? createdAt,
    File? media,
    MessageStatus? status
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      contentType: contentType ?? this.contentType,
      content: content ?? this.content,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      media : media ?? this.media,
      status: status ?? this.status
    );
  }

  @override
  String toString() {
    return 'MessageModel{id: $id, chatId: $chatId, senderId: $senderId, contentType: $contentType, content: $content, description: $description, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}