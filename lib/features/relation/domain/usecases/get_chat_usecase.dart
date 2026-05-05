import 'package:flexiback/features/relation/domain/entities/message_entity.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class GetChatUsecase {
  RelationRepository repo;

  GetChatUsecase(this.repo);

  Stream<List<MessageEntity>> call(String targetUser) {
    return repo.getRealtimeChat(targetUser);
  }
}