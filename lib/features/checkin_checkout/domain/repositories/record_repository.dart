import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';

abstract class RecordRepository {
  Future<void> saveRecord(Record record);
  Future<List<Record>> getAllRecords();
}
