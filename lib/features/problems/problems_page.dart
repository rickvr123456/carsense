import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../riverpod_providers.dart';
import '../../core/utils/error_handler.dart';
import '../../core/models/dtc.dart';

class ProblemsPage extends ConsumerWidget {
  const ProblemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final dtcs = app.dtcs;
    final selectionMode = ref.watch(problemsSelectionModeProvider);
    final selected = ref.watch(problemsSelectedDtcsProvider);
    final expandedMap = ref.watch(problemsExpandedListProvider);

    final currentDtcCodes = dtcs.map((d) => d.code).toList();
    if (expandedMap.length != dtcs.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final newMap = <String, bool>{};
        for (final code in currentDtcCodes) {
          newMap[code] = expandedMap[code] ?? false;
        }
        newMap.removeWhere((code, _) => !currentDtcCodes.contains(code));
        ref.read(problemsExpandedListProvider.notifier).state = newMap;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (selectionMode)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () {
                  ref.read(problemsSelectionModeProvider.notifier).state =
                      false;
                  ref.read(problemsSelectedDtcsProvider.notifier).state = {};
                },
              ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF222b35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber,
                      color: Colors.orange, size: 20),
                  const SizedBox(width: 5),
                  Text('${dtcs.length}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const Spacer(),
            if (dtcs.isNotEmpty &&
                !selectionMode &&
                _hasUninterpretedDtcs(dtcs))
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3660EF),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  app.dashboard.retryAiDescription();
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Riprova AI', style: TextStyle(fontSize: 12)),
              ),
            const SizedBox(width: 8),
            if (dtcs.isNotEmpty && !selectionMode)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  ref.read(problemsSelectionModeProvider.notifier).state =
                      true;
                  ref.read(problemsSelectedDtcsProvider.notifier).state = {};
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
                  final isExpanded = expandedMap[d.code] ?? false;
                  final isSelected = selected.contains(d.code);

                  return AnimatedContainer(
                    key: ValueKey(d.code),
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? const Color(0xFF233246)
                          : const Color(0xFF222b35),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        if (isExpanded)
                          const BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                      ],
                      border: Border.all(
                        color: Colors.black12,
                        width: isExpanded ? 2 : 1.1,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: selectionMode
                              ? () {
                                  if (isSelected) {
                                    final newSet = Set<String>.from(selected);
                                    newSet.remove(d.code);
                                    ref
                                        .read(problemsSelectedDtcsProvider
                                            .notifier)
                                        .state = newSet;
                                  } else {
                                    final newSet = Set<String>.from(selected);
                                    newSet.add(d.code);
                                    ref
                                        .read(problemsSelectedDtcsProvider
                                            .notifier)
                                        .state = newSet;
                                  }
                                }
                              : () {
                                  final newMap =
                                      Map<String, bool>.from(expandedMap);
                                  newMap[d.code] = !isExpanded;
                                  ref
                                      .read(problemsExpandedListProvider
                                          .notifier)
                                      .state = newMap;
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFF232B37),
                                  radius: 20,
                                  child: Icon(Icons.warning,
                                      color: Colors.orange, size: 27),
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
                                if (selectionMode)
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (_) {
                                      if (isSelected) {
                                        final newSet =
                                            Set<String>.from(selected);
                                        newSet.remove(d.code);
                                        ref
                                            .read(
                                                problemsSelectedDtcsProvider
                                                    .notifier)
                                            .state = newSet;
                                      } else {
                                        final newSet =
                                            Set<String>.from(selected);
                                        newSet.add(d.code);
                                        ref
                                            .read(
                                                problemsSelectedDtcsProvider
                                                    .notifier)
                                            .state = newSet;
                                      }
                                    },
                                  ),
                                if (!selectionMode)
                                  Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.white70,
                                    size: 26,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 33, right: 14, top: 8, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (d.title != null && d.title!.isNotEmpty)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                if (d.description != null &&
                                    d.description!.isNotEmpty)
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
                                if ((d.description == null ||
                                        d.description!.isEmpty) &&
                                    (d.title == null || d.title!.isEmpty))
                                  const Text('Descrizione in caricamento…',
                                      style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF3660EF),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 19, vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(19),
                                        ),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(aiInitialPromptProvider
                                                .notifier)
                                            .state =
                                            'Ho un problema con il codice ${d.code}: ${d.title ?? ''}. ${d.description ?? ''}. Puoi aiutarmi a capire la causa e la possibile soluzione?';
                                        ref
                                            .read(navigationIndexProvider
                                                .notifier)
                                            .state = 2;
                                      },
                                      child: const Text(
                                        'Chiedi all\'IA',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.5,
                                            color: Colors.white),
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
      floatingActionButton: dtcs.isEmpty || !selectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: selected.isEmpty
                  ? null
                  : () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Conferma cancellazione'),
                          content: Text(
                              'Sei sicuro di voler cancellare ${selected.length} errore(i)?'),
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
                      if (confirmed == true && context.mounted) {
                        final count = selected.length;
                        app.dashboard.removeDtcCodes(selected);
                        ref.read(problemsSelectionModeProvider.notifier).state =
                            false;
                        ref.read(problemsSelectedDtcsProvider.notifier).state =
                            {};
                        if (context.mounted) {
                          ErrorHandler.showSuccess(
                            context,
                            message:
                                '$count errore(i) cancellato(i) con successo',
                          );
                        }
                      }
                    },
              label: const Text('Cancella selezionati'),
              icon: const Icon(Icons.delete),
            ),
    );
  }

  bool _hasUninterpretedDtcs(List<Dtc> dtcs) {
    return dtcs.any((d) => d.title == null || d.title!.isEmpty);
  }
}
