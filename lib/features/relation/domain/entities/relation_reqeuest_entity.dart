class RelationReqeuestEntity {
  final String id;
  final String requesterId;
  final String recipientId;
  final String requesterRole;
  final DateTime createAt;

  RelationReqeuestEntity({
    required this.id,
    required this.requesterId,
    required this.recipientId,
    required this.requesterRole,
    required this.createAt,
  });

  @override
  String toString() {
    return "id : $id \n requester : $requesterId \n recipient : $recipientId \n requesterRole : $requesterRole";
  }

}