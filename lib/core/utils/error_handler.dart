import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ErrorHandler {
  ErrorHandler._();

  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onAction();
              },
              child: Text(actionLabel),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> showNetworkError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) async {
    await showErrorDialog(
      context,
      title: 'Errore di Connessione',
      message: 'Nessuna connessione a Internet. '
          'Controlla la tua connessione e riprova.',
      actionLabel: onRetry != null ? 'Riprova' : null,
      onAction: onRetry,
    );
  }

  static Future<void> showAiError(
    BuildContext context, {
    String? details,
    VoidCallback? onRetry,
  }) async {
    final message = details != null
        ? 'Errore nell\'interpretazione dei codici OBD tramite AI.\n\n'
            'Dettagli: $details'
        : 'Si è verificato un errore durante l\'interpretazione dei codici OBD tramite AI. '
            'Le descrizioni potrebbero non essere disponibili.';

    await showErrorDialog(
      context,
      title: 'Errore AI',
      message: message,
      actionLabel: onRetry != null ? 'Riprova' : null,
      onAction: onRetry,
    );
  }

  static Future<void> showLocationError(
    BuildContext context, {
    required String message,
    VoidCallback? onOpenSettings,
  }) async {
    await showErrorDialog(
      context,
      title: 'Errore Posizione',
      message: message,
      actionLabel: onOpenSettings != null ? 'Impostazioni' : null,
      onAction: onOpenSettings,
    );
  }

  static Future<void> showGenericError(
    BuildContext context, {
    String? message,
    VoidCallback? onRetry,
  }) async {
    await showErrorDialog(
      context,
      title: 'Errore',
      message: message ?? 'Si è verificato un errore imprevisto. Riprova.',
      actionLabel: onRetry != null ? 'Riprova' : null,
      onAction: onRetry,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.info, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
