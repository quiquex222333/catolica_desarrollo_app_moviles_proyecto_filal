import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/presentation/pages/historial_page.dart';
import 'package:final_project/features/checkin_checkout/presentation/providers/record_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String searchQuery = '';
  DateTime? selectedDate;

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(recordNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registros de empleados')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nombre',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() => searchQuery = value.toLowerCase().trim());
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'Filtrando: todas las fechas'
                          : 'Fecha: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Elegir fecha'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: recordsAsync.when(
              data: (records) {
                final filtered =
                    records.where((r) {
                      final matchesName = r.fullName.toLowerCase().contains(
                        searchQuery,
                      );
                      final matchesDate =
                          selectedDate == null ||
                          isSameDay(r.timestamp, selectedDate!);
                      return matchesName && matchesDate;
                    }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron registros.'),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final record = filtered[index];
                    final formattedDate = DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(record.timestamp);

                    return ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => _RecordDetailDialog(record: record),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: FileImage(File(record.photoPath)),
                        ),
                      ),

                      title: Text(record.fullName),
                      subtitle: Text(
                        '$formattedDate - ${record.type == RecordType.entry ? "Entrada" : "Salida"}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => HistorialPage(fullName: record.fullName),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (e, st) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/register'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RecordDetailDialog extends StatelessWidget {
  final Record record;

  const _RecordDetailDialog({required this.record});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(record.timestamp);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(File(record.photoPath), height: 200),
            ),
            const SizedBox(height: 12),
            Text(
              record.fullName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(formattedDate),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                record.type == RecordType.entry ? 'Entrada' : 'Salida',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor:
                  record.type == RecordType.entry ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
