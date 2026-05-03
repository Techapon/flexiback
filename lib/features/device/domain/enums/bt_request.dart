enum BtRequest {
  DowloadPreview (
    method: "p",
    start: "<PREVIEW_START>",
    end: "<PREVIEW_END>"
  ),
  DowloadData(
    method: "f",
    start: "<FULL_START>",
    end: "<FULL_END>"
  ),
  Calibrate(
    method: 'c'
  ),
  Reset(
    method: 'r'
  );
  
  final String method;
  
  final String? start;
  final String? end;

  const BtRequest({
    required this.method,
    this.start,
    this.end,
  });

}

