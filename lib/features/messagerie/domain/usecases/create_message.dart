import 'dart:io';


import 'package:fpdart/src/either.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/chat_model.dart';
import '../entities/message.dart';
import '../repositories/messagerie_repository.dart';

class CreateMessage implements UseCase<ChatModel, CreateMessageParams> {
  final MessagerieRepository messagerieRepository;

  CreateMessage(this.messagerieRepository);

  @override
  Future<Either<Failure, ChatModel>> call(CreateMessageParams params) async {

    return await messagerieRepository.uploadMessage(userId: params.userId,  contentype: params.contentType,media: params.media,content: params.content,description: params.description,chat: params.chat);
  }
}

class CreateMessageParams {
  final File? media;
  final String userId;
  final String? content;
  final String? description;
  final ChatModel? chat;
  final MessageContentType contentType;

  CreateMessageParams({
    this.media,
    required this.userId,
    this.content,
    this.description,
    this.chat,
    required this.contentType,
  });
}
