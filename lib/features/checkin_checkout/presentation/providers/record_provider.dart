import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/domain/usecases/save_record.dart';
import 'package:final_project/features/checkin_checkout/domain/repositories/record_repository.dart';

class RecordNotifier extends StateNotifier<AsyncValue<List<Record>>> {
  final RecordRepository repository;
  final SaveRecord saveRecord;

  RecordNotifier({
    required this.repository,
    required this.saveRecord,
  }) : super(const AsyncValue.loading()) {
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      final records = await repository.getAllRecords();
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addRecord(Record record) async {
    try {
      await saveRecord(record);
      _loadRecords();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// --- Proveedores ---

final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  throw UnimplementedError();
});

final saveRecordProvider = Provider<SaveRecord>((ref) {
  return SaveRecord(ref.watch(recordRepositoryProvider));
});

final recordNotifierProvider =
    StateNotifierProvider<RecordNotifier, AsyncValue<List<Record>>>((ref) {
  return RecordNotifier(
    repository: ref.watch(recordRepositoryProvider),
    saveRecord: ref.watch(saveRecordProvider),
  );
});
