import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';

class WorkedHoursResult {
  final Duration daily;
  final Duration weekly;
  final Duration monthly;

  WorkedHoursResult({
    required this.daily,
    required this.weekly,
    required this.monthly,
  });
}

class CalculateWorkedHours {
  WorkedHoursResult calculate(List<Record> allRecords, String fullName) {
    final now = DateTime.now();

    Duration sumFor(
      DateTime Function(DateTime) startOf,
      DateTime Function(DateTime) endOf,
    ) {
      final rangeStart = startOf(now);
      final rangeEnd = endOf(now);

      final userRecords =
          allRecords
              .where(
                (r) =>
                    r.fullName.toLowerCase().trim() ==
                        fullName.toLowerCase().trim() &&
                    r.timestamp.isAfter(rangeStart) &&
                    r.timestamp.isBefore(rangeEnd),
              )
              .toList()
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      Duration total = Duration.zero;

      for (int i = 0; i < userRecords.length - 1; i++) {
        final current = userRecords[i];
        final next = userRecords[i + 1];

        if (current.type == RecordType.entry && next.type == RecordType.exit) {
          total += next.timestamp.difference(current.timestamp);
          i++; // saltar al siguiente par
        }
      }

      return total;
    }

    return WorkedHoursResult(
      daily: sumFor(
        (d) => DateTime(d.year, d.month, d.day),
        (d) => DateTime(d.year, d.month, d.day + 1),
      ),
      weekly: sumFor(
        (d) => d.subtract(Duration(days: d.weekday - 1)), // lunes
        (d) => d.add(Duration(days: 8 - d.weekday)), // domingo +1
      ),
      monthly: sumFor(
        (d) => DateTime(d.year, d.month),
        (d) => DateTime(d.year, d.month + 1),
      ),
    );
  }
}
