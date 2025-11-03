import 'package:flutter/material.dart';
import '../../services/error_history_service.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/error_handler.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

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
        title: const Text(AppStrings.errorHistory),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            color: AppColors.error,
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(AppStrings.clearAllHistory),
                  content: const Text(AppStrings.confirmClearHistory),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text(AppStrings.no),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(AppStrings.yes),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await _service.clearHistory();
                await _load();
                if (context.mounted) {
                  ErrorHandler.showSuccess(
                    context,
                    message: 'Cronologia cancellata con successo',
                  );
                }
              }
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : entries.isEmpty
              ? const Center(child: Text(AppStrings.noErrorsRecorded))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final e = entries[i];
                    final date = DateFormatter.parseIso8601(e['timestamp']) ??
                        DateTime.now();
                    return ListTile(
                      leading: const Icon(Icons.warning_amber,
                          color: AppColors.warning),
                      title: Text(e['code']),
                      subtitle: Text(DateFormatter.formatShortDateTime(date)),
                    );
                  },
                ),
    );
  }
}
