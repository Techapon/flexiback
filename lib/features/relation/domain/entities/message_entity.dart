import 'package:flexiback/features/relation/domain/enums/message_enums.dart';

class MessageEntity {
  final String? id;
  final String? sender;
  final String recipient;
  final MessageType type;
  final String content;
  final DateTime? send_at;

  bool? isMine;

  MessageEntity({
    this.id,
    this.sender,
    required this.recipient,
    required this.type,
    required this.content,
    this.send_at,

    this.isMine
  });
}