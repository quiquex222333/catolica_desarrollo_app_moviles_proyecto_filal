import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/domain/repositories/record_repository.dart';

class SaveRecord {
  final RecordRepository repository;

  SaveRecord(this.repository);

  Future<void> call(Record record) async {
    await repository.saveRecord(record);
  }
}
