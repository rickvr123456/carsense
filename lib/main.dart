import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'app_shell.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file from rootBundle
  try {
    final envContent = await rootBundle.loadString('.env');
    // Parse .env content manually and populate dotenv.env
    final lines = envContent.split('\n');
    for (final line in lines) {
      if (line.isNotEmpty && !line.startsWith('#')) {
        final parts = line.split('=');
        if (parts.length == 2) {
          dotenv.env[parts[0]] = parts[1];
        }
      }
    }
  } catch (e) {
    // .env not found - continue without it
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
