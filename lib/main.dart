import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/core/database/app_database.dart';
import 'package:final_project/features/checkin_checkout/data/datasources/local_datasource.dart';
import 'package:final_project/features/checkin_checkout/data/repositories/record_repository_impl.dart';
import 'package:final_project/features/checkin_checkout/presentation/pages/home_page.dart';
import 'package:final_project/features/checkin_checkout/presentation/pages/register_page.dart';
import 'package:final_project/features/checkin_checkout/presentation/providers/record_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await AppDatabase.instance.database;
  final localDataSource = RecordLocalDataSource(db: db);
  final repository = RecordRepositoryImpl(localDataSource: localDataSource);

  runApp(
    ProviderScope(
      overrides: [
        recordRepositoryProvider.overrideWithValue(repository),
      ],
      child: const RegistroApp(),
    ),
  );
}

class RegistroApp extends StatelessWidget {
  const RegistroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Empleados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}
