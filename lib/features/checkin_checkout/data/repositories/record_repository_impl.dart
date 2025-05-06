import 'package:final_project/features/checkin_checkout/data/datasources/local_datasource.dart';
import 'package:final_project/features/checkin_checkout/data/models/record_model.dart';
import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/domain/repositories/record_repository.dart';

class RecordRepositoryImpl implements RecordRepository {
  final RecordLocalDataSource localDataSource;

  RecordRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveRecord(Record record) async {
    final model = RecordModel(
      id: record.id,
      fullName: record.fullName,
      photoPath: record.photoPath,
      timestamp: record.timestamp,
      type: record.type,
    );
    await localDataSource.insertRecord(model);
  }

  @override
  Future<List<Record>> getAllRecords() async {
    return await localDataSource.getAllRecords();
  }
}
