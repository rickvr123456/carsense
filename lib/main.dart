import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'app_shell.dart';
import 'services/gemini_service.dart';
import 'services/ai_chat_service.dart';

void main() {
  runApp(const CarSenseApp());
}

class CarSenseApp extends StatelessWidget {
  const CarSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Il tuo AppState con aggancio del GeminiService per i DTC
        ChangeNotifierProvider(
          create: (_) {
            final app = AppState();
            final gemini = GeminiService(
              apiKey:
                  'AIzaSyBO9nCSYlXMYVbtV8Pe8-_JoSZiivGm17A', // Sostituire con chiave reale
              modelName: 'gemini-2.5-flash', // O altro modello abilitato
            );
            app.dashboard.attachGemini(gemini);
            debugPrint('[Main] GeminiService inizializzato.');
            return app;
          },
        ),

        // NEW: Provider della chat AI (indipendente dai DTC)
        ChangeNotifierProvider(
          create: (_) => AiChatService(
            apiKey:
                'AIzaSyBO9nCSYlXMYVbtV8Pe8-_JoSZiivGm17A', // usa la stessa chiave o una variabile
            modelName:
                'gemini-2.5-flash', // assicurati che sia abilitato; puoi usare lo stesso della dashboard
          ),
        ),
      ],
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
