import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/chat_model.dart';
import '../entities/message.dart';

abstract interface class MessagerieRepository {
  Future<Either<Failure, ChatModel>> uploadMessage({
    File? media,
    required String userId,
    String? content,
    String? description,
    ChatModel? chat,
    required MessageContentType contentype,
  });

  Future<Either<Failure, List<ChatModel>>> loadChats(String userId);

  Future<Either<Failure, ChatModel>> loadChat(String userId, ChatModel chatId);
}

/**
 * required super.id,
    required super.chatId,
    required super.senderId,
    required super.contentType,
    required super.content,
    super.description,
    required super.createdAt,
    this.media
 */
