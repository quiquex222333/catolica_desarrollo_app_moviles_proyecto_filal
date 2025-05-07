import 'dart:io';

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
          final filtered = records
              .where((r) => r.fullName.toLowerCase().trim() == fullName.toLowerCase().trim())
              .toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('No hay registros para esta persona.'));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final record = filtered[index];
              final formatted = DateFormat('dd/MM/yyyy HH:mm').format(record.timestamp);

              return ListTile(
                leading: CircleAvatar(backgroundImage: FileImage(File(record.photoPath))),
                title: Text(record.type == RecordType.entry ? 'Entrada' : 'Salida'),
                subtitle: Text(formatted),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
