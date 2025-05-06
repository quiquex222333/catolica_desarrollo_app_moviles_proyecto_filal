import 'package:final_project/features/checkin_checkout/data/models/record_model.dart';
import 'package:sqflite/sqflite.dart';

class RecordLocalDataSource {
  final Database db;

  RecordLocalDataSource({required this.db});

  Future<void> insertRecord(RecordModel record) async {
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecordModel>> getAllRecords() async {
    final result = await db.query(
      'records',
      orderBy: 'timestamp DESC',
    );

    return result.map((map) => RecordModel.fromMap(map)).toList();
  }
}
