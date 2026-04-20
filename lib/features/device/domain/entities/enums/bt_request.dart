enum BtRequest {
  DowloadPreview (
    entity: "preview"
  ),
  DowloadData(
    entity: "data"
  );
  
  final String entity;

  const BtRequest({
    required this.entity
  });

}

