import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'app_shell.dart';
import 'services/gemini_service.dart';

void main() {
  runApp(const CarSenseApp());
}

class CarSenseApp extends StatelessWidget {
  const CarSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final app = AppState();
        // TODO: non lasciare chiavi in chiaro in produzione.
        // Usa un backend o secret manager; qui per demo locale:
        final gemini = GeminiService(apiKey: 'INSERISCI_LA_TUA_API_KEY_GEMINI');
        app.dashboard.attachGemini(gemini);
        return app;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CarSense',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F1418),
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF2BE079),
            surface: Color(0xFF1E2A35),
          ),
        ),
        home: const AppShell(),
      ),
    );
  }
}
