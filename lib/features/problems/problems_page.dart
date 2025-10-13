import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../services/obd_service.dart';

class ProblemsPage extends StatefulWidget {
  const ProblemsPage({super.key});

  @override
  State<ProblemsPage> createState() => _ProblemsPageState();
}

class _ProblemsPageState extends State<ProblemsPage> {
  // Configura l’endpoint reale e/o chiave
  final ObdService obd = ObdService(
    baseUrl: 'https://example.com', // TODO: sostituisci con API reale
    apiKey: null, // o 'LA_TUA_API_KEY'
  );

  Future<void> _showDetails(BuildContext context, String code) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2A35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _ObdDetailsSheet(
        code: code,
        loader: () => obd.fetchDtc(code),
      ),
    );
  }

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
                    subtitle: const Text('Tocca per dettagli'),
                    onTap: () => _showDetails(context, d.code),
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

class _ObdDetailsSheet extends StatefulWidget {
  final String code;
  final Future<ObdInfo?> Function() loader;
  const _ObdDetailsSheet({required this.code, required this.loader});

  @override
  State<_ObdDetailsSheet> createState() => _ObdDetailsSheetState();
}

class _ObdDetailsSheetState extends State<_ObdDetailsSheet> {
  Future<ObdInfo?>? future;

  @override
  void initState() {
    super.initState();
    future = widget.loader();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: FutureBuilder<ObdInfo?>(
          future: future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()));
            }
            final info = snap.data;
            if (info == null) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Descrizione non disponibile',
                    style: TextStyle(color: Colors.white)),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${info.code} — ${info.title}',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 8),
                Text(info.summary,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white70)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.white54, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Le descrizioni sono indicative; verificare il veicolo per diagnosi.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
