import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/error_history_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ErrorHistoryService _service = ErrorHistoryService();
  List<Map<String, dynamic>> entries = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _service.getHistory();
    setState(() {
      entries = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronologia Errori'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Cancella tutta la cronologia'),
                  content: const Text('Sei sicuro di voler cancellare tutti i record?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sì')),
                  ],
                ),
              );
              if (confirmed == true) {
                await _service.clearHistory();
                _load();
              }
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : entries.isEmpty
              ? const Center(child: Text('Nessun errore registrato'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final e = entries[i];
                    final date = DateTime.parse(e['timestamp']);
                    return ListTile(
                      leading: const Icon(Icons.warning_amber, color: Colors.orange),
                      title: Text(e['code']),
                      subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(date)),
                    );
                  },
                ),
    );
  }
}
