import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/domain/repositories/record_repository.dart';

class SaveRecord {
  final RecordRepository repository;

  SaveRecord(this.repository);

  Future<void> call(Record record) async {
    final records = await repository.getAllRecords();

    final today = DateTime.now();
    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    final todayRecords = records.where((r) =>
        isSameDay(r.timestamp, today) &&
        r.fullName.toLowerCase().trim() == record.fullName.toLowerCase().trim());

    final hasEntry = todayRecords.any((r) => r.type == RecordType.entry);
    final hasExit = todayRecords.any((r) => r.type == RecordType.exit);

    if (record.type == RecordType.exit && !hasEntry) {
      throw Exception('No se puede registrar salida sin una entrada previa.');
    }

    if (record.type == RecordType.entry && hasEntry) {
      throw Exception('Ya se ha registrado una entrada hoy.');
    }

    if (record.type == RecordType.exit && hasExit) {
      throw Exception('Ya se ha registrado una salida hoy.');
    }

    await repository.saveRecord(record);
  }
}

