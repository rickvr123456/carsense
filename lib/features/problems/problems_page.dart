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
  List<bool> expanded = [];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final dtcs = app.dtcs;
    if (expanded.length != dtcs.length) expanded = List<bool>.filled(dtcs.length, false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'PROBLEMI',
              style: TextStyle(
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF222b35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 5),
                  Text('${dtcs.length}', style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() {
                  _selectionMode = false;
                  _selected.clear();
                }),
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: dtcs.isEmpty
            ? const Center(
                child: Text(
                  'Nessun errore rilevato',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.separated(
                itemCount: dtcs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final d = dtcs[i];
                  final bool isExpanded = expanded[i];
                  final bool isSelected = _selected.contains(d.code);

                  return Card(
                    color: const Color(0xFF222b35),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.warning_amber, color: Colors.redAccent, size: 30),
                          title: Text(
                            d.title?.isNotEmpty == true ? d.title! : d.code,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_selectionMode)
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (_) {
                                    setState(() {
                                      if (isSelected) _selected.remove(d.code);
                                      else _selected.add(d.code);
                                    });
                                  }),
                              IconButton(
                                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.white70),
                                onPressed: () {
                                  setState(() {
                                    expanded[i] = !isExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                          onTap: _selectionMode
                              ? () {
                                  setState(() {
                                    if (isSelected) _selected.remove(d.code);
                                    else _selected.add(d.code);
                                  });
                                }
                              : () {
                                  setState(() {
                                    expanded[i] = !isExpanded;
                                  });
                                },
                        ),
                        if (isExpanded)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                            child: Text(
                              d.description ?? 'Descrizione in caricamento…',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: dtcs.isEmpty
          ? null
          : _selectionMode
              ? FloatingActionButton.extended(
                  onPressed: _selected.isEmpty
                      ? null
                      : () async {
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
                            app.dashboard.removeDtcCodes(_selected);
                            setState(() {
                              _selectionMode = false;
                              _selected.clear();
                            });
                          }
                        },
                  label: const Text('Cancella selezionati'),
                  icon: const Icon(Icons.delete),
                )
              : FloatingActionButton.extended(
                  onPressed: () {
                    setState(() => _selectionMode = true);
                  },
                  label: const Text('Cancella errori'),
                  icon: const Icon(Icons.cleaning_services),
                ),
    );
  }
}
