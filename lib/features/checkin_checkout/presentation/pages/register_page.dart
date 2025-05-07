import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:final_project/features/checkin_checkout/domain/entities/record.dart';
import 'package:final_project/features/checkin_checkout/presentation/providers/record_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  File? _imageFile;
  final _nameController = TextEditingController();
  RecordType _selectedType = RecordType.entry;
  bool _isProcessing = false;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      final tempFile = File(picked.path);

      final inputImage = InputImage.fromFile(tempFile);
      final options = FaceDetectorOptions(
        enableContours: false,
        enableClassification: false,
      );
      final faceDetector = FaceDetector(options: options);
      final faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();

      if (faces.isNotEmpty) {
        setState(() {
          _imageFile = tempFile;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se detectó una persona en la imagen.'),
          ),
        );
      }
    }
  }

  Future<void> _saveRecord() async {
    if (_imageFile == null || _nameController.text.isEmpty) return;

    setState(() => _isProcessing = true);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await _imageFile!.copy('${appDir.path}/$fileName');

    final record = Record(
      fullName: _nameController.text.trim(),
      photoPath: savedImage.path,
      timestamp: DateTime.now(),
      type: _selectedType,
    );

    try {
      await ref.read(recordNotifierProvider.notifier).addRecord(record);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageFile != null)
              Image.file(_imageFile!, height: 200)
            else
              ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar foto'),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            const SizedBox(height: 16),
            DropdownButton<RecordType>(
              value: _selectedType,
              items: const [
                DropdownMenuItem(
                  value: RecordType.entry,
                  child: Text('Entrada'),
                ),
                DropdownMenuItem(value: RecordType.exit, child: Text('Salida')),
              ],
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _saveRecord,
              icon: const Icon(Icons.save),
              label: const Text('Guardar registro'),
            ),
          ],
        ),
      ),
    );
  }
}
