import 'dart:io';

import 'package:final_project/features/checkin_checkout/domain/usecases/calculate_worked_hours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/presentation/providers/record_provider.dart';

class HistorialPage extends ConsumerWidget {
  final String fullName;

  const HistorialPage({super.key, required this.fullName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(recordNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Historial de $fullName')),
      body: recordsAsync.when(
        data: (records) {
          final filtered =
              records
                  .where(
                    (r) =>
                        r.fullName.toLowerCase().trim() ==
                        fullName.toLowerCase().trim(),
                  )
                  .toList()
                ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          if (filtered.isEmpty) {
            return const Center(
              child: Text('No hay registros para esta persona.'),
            );
          }

          final summary = CalculateWorkedHours().calculate(records, fullName);

          String formatDuration(Duration d) {
            final h = d.inHours;
            final m = d.inMinutes.remainder(60);
            return '${h}h ${m}m';
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumen de horas trabajadas',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Hoy: ${formatDuration(summary.daily)}'),
                        Text('Esta semana: ${formatDuration(summary.weekly)}'),
                        Text('Este mes: ${formatDuration(summary.monthly)}'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final record = filtered[index];
                    final formatted = DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(record.timestamp);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: FileImage(File(record.photoPath)),
                      ),
                      title: Text(
                        record.type == RecordType.entry ? 'Entrada' : 'Salida',
                      ),
                      subtitle: Text(formatted),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, st) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text(
                    'Ocurrió un error al cargar los registros.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.toString().replaceAll('Exception: ', ''),
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
