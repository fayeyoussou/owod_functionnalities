import 'package:fpdart/src/either.dart';
import 'package:owod_functionnalities/core/error/failure.dart';
import 'package:owod_functionnalities/core/usecase/usecase.dart';
import 'package:owod_functionnalities/features/messagerie/domain/entities/chat.dart';
import 'package:owod_functionnalities/features/messagerie/domain/repositories/messagerie_repository.dart';

class LoadChatList implements UseCase<List<Chat>,LoadChatListParams>{
  final MessagerieRepository messagerieRepository;

  LoadChatList( this.messagerieRepository);
  @override
  Future<Either<Failure, List<Chat>>> call(LoadChatListParams params) async {
    return await messagerieRepository.loadChats(params.userId);
  }

}

class LoadChatListParams {
  final String userId;

  LoadChatListParams(this.userId);
}