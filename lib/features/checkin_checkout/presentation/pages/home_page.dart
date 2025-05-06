import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/presentation/providers/record_provider.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(recordNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros de empleados'),
      ),
      body: recordsAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(child: Text('No hay registros aún.'));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(record.timestamp);

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: FileImage(
                    File(record.photoPath),
                  ),
                ),
                title: Text(record.fullName),
                subtitle: Text('$formattedDate - ${record.type == RecordType.entry ? "Entrada" : "Salida"}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
