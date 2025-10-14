import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';

class ProblemsPage extends StatefulWidget {
  const ProblemsPage({super.key});
  @override
  State<ProblemsPage> createState() => _ProblemsPageState();
}

class _ProblemsPageState extends State<ProblemsPage> {
  List<bool> expanded = [];
  bool _selectionMode = false;
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final dtcs = app.dtcs;
    if (expanded.length != dtcs.length) {
      expanded = List<bool>.filled(dtcs.length, false);
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PROBLEMI:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(246, 153, 1, 1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${dtcs.length}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => setState(() {
                  _selectionMode = false;
                  _selected.clear();
                }),
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: dtcs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final d = dtcs[i];
            final bool isExpanded = expanded[i];
            final bool isSelected = _selectionMode && _selected.contains(d.code);

            return Card(
              color: const Color(0xFF222b35),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.warning_rounded,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                    title: Text(
                      d.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
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
                            },
                            activeColor: Colors.orangeAccent,
                          ),
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.white60,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.description ?? 'Descrizione non disponibile',
                            style: const TextStyle(
                              color: Color(0xFF2BE079),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            d.detail ?? "Dettagli in arrivo...",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'monospace',
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {}, // Futura integrazione IA
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF3660ef),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 0),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                              ),
                              child: const Text('Chiedi all\'IA', style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ],
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
                            final dashboard = context.read<AppState>().dashboard;
                            dashboard.removeDtcCodes(_selected);
                            setState(() {
                              _selected.clear();
                              _selectionMode = false;
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
