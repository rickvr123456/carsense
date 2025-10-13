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
              'CarSense è un’applicazione pensata per tutti gli appassionati di motori che intendono approcciarsi al mondo  della meccanica in maniera semplice ma non superficiale. ',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              'Attraverso la scansione della centralina tramite presa OBD2, CarHealth restituirà una panoramica completa di tutti gli errori riportati dalla centralina della propria autovettura, con una spiegazione dettagliata dell’errore, delle probabili cause e delle possibili soluzioni. ',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              'Inoltre, è integrata un’intelligenza artificiale che aiuta l’utente nella comprensione del problema, e che è in grado di rispondere alle richieste dell’utente riguardo eventuali dubbi sul proprio veicolo',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
