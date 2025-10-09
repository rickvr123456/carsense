import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';

class ProblemsPage extends StatelessWidget {
  const ProblemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final dtcs = app.dtcs;
    return Scaffold(
      appBar: AppBar(title: const Text('Problemi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: dtcs.isEmpty
            ? const Center(child: Text('Nessun errore rilevato'))
            : ListView.separated(
                itemCount: dtcs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final d = dtcs[i];
                  return ListTile(
                    leading: const Icon(Icons.error_outline,
                        color: Colors.orangeAccent),
                    title: Text(d.code),
                    subtitle:
                        Text(d.description ?? 'Descrizione non disponibile'),
                  );
                },
              ),
      ),
      floatingActionButton: dtcs.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => app.clearDtc(),
              label: const Text('Cancella codici'),
              icon: const Icon(Icons.cleaning_services),
            ),
    );
  }
}
