
import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';

class RecordModel extends Record {
  RecordModel({
    super.id,
    required super.fullName,
    required super.photoPath,
    required super.timestamp,
    required super.type,
  });

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      id: map['id'] as int?,
      fullName: map['full_name'] as String,
      photoPath: map['photo_path'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      type: map['type'] == 'entry' ? RecordType.entry : RecordType.exit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'photo_path': photoPath,
      'timestamp': timestamp.toIso8601String(),
      'type': type == RecordType.entry ? 'entry' : 'exit',
    };
  }
}
