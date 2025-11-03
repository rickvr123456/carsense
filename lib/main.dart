import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_shell.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file (won't fail if not found)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env not found or failed to load - continue without it
  }

  runApp(const ProviderScope(child: CarSenseApp()));
}

class CarSenseApp extends StatelessWidget {
  const CarSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarSense',
      theme: AppTheme.darkTheme,
      home: const AppShell(),
    );
  }
}
