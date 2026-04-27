enum Role {
  General (
    entity: "general"
  ),

  Therapist (
    entity: "therapist"
  );

  final String entity;

  const Role({
    required this.entity
  });
}