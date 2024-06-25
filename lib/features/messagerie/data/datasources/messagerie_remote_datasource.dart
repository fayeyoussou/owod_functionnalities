import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/server_exception.dart';
import '../../domain/entities/message.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract interface class MessagerieDatasource {

  Future<ChatModel> createMessage(MessageModel message,ChatModel? chat);
  Future<List<ChatModel>> loadChats(String userId);
  
  Future<ChatModel> loadChat(String userId,ChatModel chat);
  Future<String> uploadMessageMedia({required File audio, required String idMessage,isAudio = true});
}

class MessagerieRemoteDatasourceImpl implements MessagerieDatasource {
  final SupabaseClient supabaseClient;

  MessagerieRemoteDatasourceImpl(this.supabaseClient);
  @override
  Future<ChatModel> createMessage(MessageModel message, ChatModel? chat)  async {
    try {
      if(chat == null){
        ChatModel chatModel = ChatModel(id: null, userId: message.senderId, createdAt: DateTime.now(),messages: []);
        final chatData = (await supabaseClient.from('chats').insert(chatModel.toJson()).select()).first;
        chat = chatModel.copyWith(id: chatData['id']);
        message = message.copyWith(chatId: chat.id);
      }
      if( message.media !=null && (message.contentType == MessageContentType.audio || message.contentType == MessageContentType.image  )){

        String mediaUrl = await uploadMessageMedia(audio: message.media as File, idMessage: message.id,isAudio: message.contentType == MessageContentType.audio);
          message = message.copyWith(content: mediaUrl);
      }
      message = message.copyWith(status: MessageStatus.sent);
      final blogData = (await supabaseClient.from('messages').insert(message.toJson()).select()).first;

      chat.messages.add(message);
      return chat;

    } on PostgrestException catch (e){
      throw ServerException('PostgresException : ${e.message}');
    }
    catch(e){
      throw ServerException(e.toString());
    }
  }


  @override
  Future<ChatModel> loadChat(String userId, ChatModel chat) async {
    try {
      // Fetch the chat data
      //print('user id : $userId , chat : ${chat.id}');

      // Fetch the messages for the chat
      final messagesData = await supabaseClient
          .from('messages')
          .select()
          .eq('chat_id', chat.id as String)
          .order('created_at', ascending: true)
          .select();




      final messages = messagesData
          .map((messageJson) => MessageModel.fromJson(messageJson))
          .toList();


      chat = chat.copyWith(messages: messages);
      print(chat.messages.length);
      return chat;
    } on PostgrestException catch (e) {
      print(e.message);
      throw ServerException('PostgresException : ${e.message}');
    } catch (e) {
      print('Error : $e' );
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ChatModel>> loadChats(String userId) async {
    try {
      final chatsData = await supabaseClient
          .from('chats')
          .select()
          .eq('user_id', userId).select();
      final chats = chatsData.map((chatJson) => ChatModel.fromJson(chatJson)).toList();
      return chats;
    } on PostgrestException catch (e) {
      throw ServerException('PostgresException : ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadMessageMedia({required File audio, required String idMessage, isAudio = true}) async {
    print('upload ${isAudio ? 'audio' : 'image'}');
    await supabaseClient.storage.from(isAudio ? 'message_audio' : 'message_image').upload(idMessage, audio);
    return  supabaseClient.storage.from(isAudio ? 'message_audio' : 'message_image').getPublicUrl(idMessage);
  }

  
}