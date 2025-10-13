import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informazioni'),
        backgroundColor: const Color(0xFF0F1418),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'CarSense',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'CarSense è un emulatore OBD-II che simula la connessione alla presa diagnostica del veicolo per mostrare valori in tempo reale come RPM, velocità, tensione batteria e temperatura liquido di raffreddamento.',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              'La funzione di scansione genera casualmente codici DTC (es. P0340) per testare i flussi di diagnosi senza hardware reale; i codici vengono poi elencati nella schermata Problemi.',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              'Sono disponibili anche una schermata di supporto con assistente IA e una mappa basata su Google Maps, che verranno integrate progressivamente.',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
