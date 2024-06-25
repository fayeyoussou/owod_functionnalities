import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/server_exception.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messagerie_repository.dart';
import '../datasources/messagerie_remote_datasource.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class MessagerieRepositoryImpl implements MessagerieRepository {
  final MessagerieDatasource datasource;

  MessagerieRepositoryImpl(this.datasource);
  @override
  Future<Either<Failure, ChatModel>> loadChat(String userId, ChatModel chatId)  async{
    try{
      ChatModel chatModel = await datasource.loadChat(userId,chatId);
      return right(chatModel);
    } on ServerException catch( e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ChatModel>>> loadChats(String userId) async {
    try{
      List<ChatModel> chatModel = await datasource.loadChats(userId);
      return right(chatModel);
    } on ServerException catch( e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ChatModel>> uploadMessage({File? media, required String userId, String? content, String? description, ChatModel ? chat, required MessageContentType contentype}) async {
    try{

      ChatModel chatModel = await datasource.createMessage(MessageModel(description : description,media : media ,status : MessageStatus.notSent,id: const Uuid().v1(), chatId: chat?.id ?? '' , senderId: userId, contentType: contentype, content: content??'', createdAt: DateTime.now()), chat);
      return right(chatModel);
    } on ServerException catch( e){
      return left(Failure(e.message));
    }
  }


}