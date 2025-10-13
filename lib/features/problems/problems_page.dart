import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';

class ProblemsPage extends StatefulWidget {
  const ProblemsPage({super.key});
  @override
  State<ProblemsPage> createState() => _ProblemsPageState();
}

class _ProblemsPageState extends State<ProblemsPage> {
  bool _selectionMode = false;
  final Set<String> _selected = {};

  void _enterSelectionMode() {
    setState(() {
      _selectionMode = true;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selected.clear();
    });
  }

  void _toggle(String code) {
    setState(() {
      if (_selected.contains(code)) {
        _selected.remove(code);
      } else {
        _selected.add(code);
      }
    });
  }

  Future<void> _confirmAndDelete() async {
    if (_selected.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conferma cancellazione'),
        content: Text('Sei sicuro di voler cancellare ${_selected.length} errore(i)?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sì')),
        ],
      ),
    );

    if (confirmed == true) {
      final dashboard = context.read<AppState>().dashboard;
      dashboard.removeDtcCodes(_selected);
      _exitSelectionMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final dtcs = app.dtcs;

    if (dtcs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Problemi')),
        body: const Center(child: Text('Nessun errore rilevato')),
        floatingActionButton: null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Problemi'),
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _exitSelectionMode,
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: dtcs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final d = dtcs[i];
            final selected = _selectionMode && _selected.contains(d.code);
            return ListTile(
              leading: Icon(
                Icons.error_outline,
                color: selected ? Colors.green : Colors.orangeAccent,
              ),
              title: Text(d.code),
              subtitle: const Text('Tocca per dettagli'),
              trailing: _selectionMode
                  ? Checkbox(
                      value: selected,
                      onChanged: (_) => _toggle(d.code),
                      activeColor: Colors.orangeAccent,
                    )
                  : null,
              onTap: _selectionMode ? () => _toggle(d.code) : () {
                // Qui puoi aprire il bottom sheet per i dettagli, se implementato
              },
            );
          },
        ),
      ),
      floatingActionButton: _selectionMode
          ? FloatingActionButton.extended(
              onPressed: _confirmAndDelete,
              label: const Text('Cancella selezionati'),
              icon: const Icon(Icons.delete),
            )
          : FloatingActionButton.extended(
              onPressed: _enterSelectionMode,
              label: const Text('Cancella errori'),
              icon: const Icon(Icons.cleaning_services),
            ),
    );
  }
}
