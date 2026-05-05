import 'package:flexiback/features/relation/domain/enums/message_enums.dart';

MessageType getMessageType(String message) {
  if (message == MessageType.message.entity) {
    return MessageType.message;
  }

  return MessageType.message;
}