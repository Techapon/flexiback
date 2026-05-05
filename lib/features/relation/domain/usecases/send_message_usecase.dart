import 'package:flexiback/features/relation/domain/entities/message_entity.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class SendMessageUsecase {
  final RelationRepository repository;

  SendMessageUsecase(this.repository);

  Future<void> call(MessageEntity message) async {
    return await repository.sendMessage(message);
  }
}
