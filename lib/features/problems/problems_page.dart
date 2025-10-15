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
            if (_selectionMode)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () {
                  setState(() {
                    _selectionMode = false;
                    _selected.clear();
                  });
                },
              ),
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
            const Spacer(),
            if (dtcs.isNotEmpty && !_selectionMode)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  setState(() {
                    _selectionMode = true;
                    _selected.clear();
                  });
                },
                child: const Text(
                  'Cancella errori',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        automaticallyImplyLeading: false,
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

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isExpanded ? const Color(0xFF233246) : const Color(0xFF222b35),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        if (isExpanded)
                          BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                      border: Border.all(
                        color: isExpanded ? const Color(0xFF2BE079) : Colors.black12,
                        width: isExpanded ? 2 : 1.1,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: _selectionMode
                              ? () {
                                  setState(() {
                                    if (isSelected)
                                      _selected.remove(d.code);
                                    else
                                      _selected.add(d.code);
                                  });
                                }
                              : () {
                                  setState(() {
                                    expanded[i] = !isExpanded;
                                  });
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFF232B37),
                                  radius: 20,
                                  child: Icon(Icons.warning, color: Colors.redAccent, size: 27),
                                ),
                                const SizedBox(width: 18),
                                Text(
                                  d.code,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.15,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const Spacer(),
                                if (_selectionMode)
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (_) {
                                      setState(() {
                                        if (isSelected)
                                          _selected.remove(d.code);
                                        else
                                          _selected.add(d.code);
                                      });
                                    },
                                  ),
                                if (!_selectionMode)
                                  Icon(
                                    isExpanded ? Icons.expand_less : Icons.expand_more,
                                    color: Colors.white70,
                                    size: 26,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(left: 33, right: 14, top: 8, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (d.title != null && d.title!.isNotEmpty)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '\u2022 ',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF2BE079),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          d.title!,
                                          style: const TextStyle(
                                            color: Color(0xFF2BE079),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (d.title != null && d.title!.isNotEmpty)
                                  const SizedBox(height: 5),
                                if (d.description != null && d.description!.isNotEmpty)
                                  SelectableText(
                                    d.description!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontFamily: 'monospace',
                                      height: 1.22,
                                      letterSpacing: 0,
                                    ),
                                    maxLines: 5,
                                  ),
                                if ((d.description == null || d.description!.isEmpty) &&
                                    (d.title == null || d.title!.isEmpty))
                                  const Text('Descrizione in caricamento…', style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF3660EF),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(19),
                                        ),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Richiesta inviata all\'IA per maggiori dettagli...'),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Chiedi all\'IA',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Colors.white),
                                      ),
                                    ),
                                  ],
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
      floatingActionButton: dtcs.isEmpty || !_selectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _selected.isEmpty
                  ? null
                  : () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Conferma cancellazione'),
                          content: Text(
                              'Sei sicuro di voler cancellare ${_selected.length} errore(i)?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('No')),
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Sì')),
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
            ),
    );
  }
}
