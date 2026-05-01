enum DotStatus {
  good (
    entity: "good"
  ),

  bad (
    entity: "bad"
  );

  final String entity;

  const DotStatus({
    required this.entity
  }); 
}