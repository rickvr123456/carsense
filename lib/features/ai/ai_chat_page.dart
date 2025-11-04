import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../riverpod_providers.dart';
import '../../core/utils/error_handler.dart';
import '../../core/theme/app_colors.dart';

class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController _scroll = ScrollController();
  bool _hasProcessedInitialPrompt = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(aiChatServiceProvider);
    final initialPrompt = ref.watch(aiInitialPromptProvider);

    // Process initial prompt only once
    if (initialPrompt != null && !_hasProcessedInitialPrompt) {
      _hasProcessedInitialPrompt = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await chat.send(initialPrompt);
        // Clear the prompt after sending
        ref.read(aiInitialPromptProvider.notifier).state = null;
      });
    }

    // Show error dialog if error occurred
    if (chat.lastError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (chat.lastError == 'Nessuna connessione a Internet') {
          ErrorHandler.showNetworkError(context);
        } else if (chat.lastError!.contains('Timeout')) {
          ErrorHandler.showGenericError(
            context,
            message: 'La richiesta ha impiegato troppo tempo. Riprova.',
          );
        } else {
          ErrorHandler.showAiError(
            context,
            details: chat.lastError,
          );
        }
        chat.lastError = null; // Clear after showing
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Supporto IA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: chat.sending
                  ? null
                  : () {
                      chat.reset(savePrevious: false);
                      _hasProcessedInitialPrompt = false;
                    },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Nuova Chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _MessagesList(controller: _scroll),
          ),
          if (chat.lastError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(chat.lastError!,
                  style: const TextStyle(color: Colors.redAccent)),
            ),
          SafeArea(
            top: false,
            child: _InputBar(
              controller: _ctrl,
              focusNode: _focus,
              onSend: (text) async {
                if (text.trim().isEmpty) return;
                _ctrl.clear();
                await ref.read(aiChatServiceProvider).send(text);
                _focus.requestFocus();
                await Future.delayed(const Duration(milliseconds: 50));
                if (_scroll.hasClients) {
                  _scroll.animateTo(
                    0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesList extends ConsumerWidget {
  final ScrollController controller;
  const _MessagesList({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(aiChatServiceProvider);
    final items = chat.history.reversed.toList();

    return ListView.builder(
      controller: controller,
      reverse: true,
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final m = items[i];
        final isUser = m.role == 'user';
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 540),
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF2BE079) : const Color(0xFF233246),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
            ),
            child: m.isLoading && !isUser
                ? const Row(children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Sta scrivendo...',
                        style: TextStyle(color: Colors.white70)),
                  ])
                : SelectableText(
                    m.text,
                    style: TextStyle(
                      color: isUser ? Colors.black : Colors.white,
                      fontSize: 15,
                      height: 1.25,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _InputBar extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<void> Function(String text) onSend;

  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(aiChatServiceProvider);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: const BoxDecoration(
        color: Color(0xFF1B222A),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: chat.sending ? null : (v) => onSend(v),
              decoration: const InputDecoration(
                hintText: 'Chiedi qualsiasi cosa…',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Color(0xFF222b35),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: chat.sending
                ? null
                : () async {
                    final text = controller.text;
                    if (text.trim().isEmpty) return;
                    await onSend(text);
                  },
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Invia'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3660EF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
