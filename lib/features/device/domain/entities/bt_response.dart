enum BtResponse {
  end (
    entity: "<end>"
  ),
  newLine(
    entity: "\n"
  );
  
  final String entity;

  const BtResponse({
    required this.entity
  });

}

