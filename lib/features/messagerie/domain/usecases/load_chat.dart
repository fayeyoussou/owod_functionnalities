
import 'package:fpdart/src/either.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/chat_model.dart';
import '../repositories/messagerie_repository.dart';

class LoadChat implements UseCase<ChatModel,LoadChatParams> {
  final MessagerieRepository messagerieRepository;

  LoadChat(this.messagerieRepository);

  @override
  Future<Either<Failure, ChatModel>> call(LoadChatParams params) async {
    return await messagerieRepository.loadChat(params.userId, params.chatModel);
  }


}

class LoadChatParams {
  final ChatModel chatModel;
  final String userId;

  LoadChatParams({required this.chatModel, required this.userId});
}