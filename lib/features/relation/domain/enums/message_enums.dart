enum MessageType {
  message(
    entity : 'message'
  );

  final String entity;

  const MessageType({
    required this.entity
  });
}