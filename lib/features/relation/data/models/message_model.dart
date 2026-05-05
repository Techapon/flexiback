import 'package:flexiback/features/relation/domain/entities/message_entity.dart';

import '../mappers/get_message_type.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    super.id,
    super.sender,
    required super.recipient,
    required super.type,
    required super.content,
    super.send_at,

    super.isMine
  });

  factory MessageModel.fromMap(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      sender: json['sender_id'],
      recipient: json['recipient_id'],
      type: getMessageType(json['type']),
      content: json['content'],
      send_at: json['created_at'] != null ? DateTime.parse(json['created_at']).toLocal() : null,
      isMine: null
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      sender: entity.sender,
      recipient: entity.recipient,
      type: entity.type,
      content: entity.content,
      send_at: entity.send_at,
      isMine: null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': sender,
      'recipient_id': recipient,
      'type': type.entity,
      'content': content,
      'created_at': send_at?.toIso8601String(),
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      sender: sender,
      recipient: recipient,
      type: type,
      content: content,
      send_at: send_at,
      isMine: isMine
    );
  }
}
