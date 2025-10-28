import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_shell.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env file, but continue if missing (providers will handle empty keys)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('[Main] Warning: .env file not found or failed to load. Using empty API keys.');
  }

  // Riverpod providers will read .env themselves
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
