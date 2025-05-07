import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/domain/repositories/record_repository.dart';

class SaveRecord {
  final RecordRepository repository;

  SaveRecord(this.repository);

  Future<void> call(Record record) async {
    final records = await repository.getAllRecords();

    // Solo registros de esta persona, ordenados por fecha ascendente
    final userRecords = records
        .where((r) => r.fullName.toLowerCase().trim() == record.fullName.toLowerCase().trim())
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (userRecords.isNotEmpty) {
      final last = userRecords.last;

      if (last.type == record.type) {
        if (record.type == RecordType.entry) {
          throw Exception('Ya se registró una entrada, debe marcar salida antes de una nueva entrada.');
        } else {
          throw Exception('Ya se registró una salida, debe marcar entrada antes de una nueva salida.');
        }
      }
    } else {
      // Si no hay registros y es salida: error
      if (record.type == RecordType.exit) {
        throw Exception('No puede marcar salida sin una entrada previa.');
      }
    }

    await repository.saveRecord(record);
  }
}
