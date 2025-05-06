class Record {
  final int? id;
  final String fullName;
  final String photoPath;
  final DateTime timestamp;
  final RecordType type;

  Record({
    this.id,
    required this.fullName,
    required this.photoPath,
    required this.timestamp,
    required this.type,
  });
}

enum RecordType {
  entry,
  exit,
}
