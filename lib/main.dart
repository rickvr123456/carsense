import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_shell.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  runApp(const ProviderScope(child: CarSenseApp()));
}

class CarSenseApp extends StatefulWidget {
  const CarSenseApp({super.key});

  @override
  State<CarSenseApp> createState() => _CarSenseAppState();
}

class _CarSenseAppState extends State<CarSenseApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
        title: 'CarSense',
        theme: AppTheme.darkTheme,
        home: SplashScreen(
          onFinished: () {
            setState(() => _showSplash = false);
          },
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    return MaterialApp(
      title: 'CarSense',
      theme: AppTheme.darkTheme,
      home: const AppShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}
