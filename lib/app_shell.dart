import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'riverpod_providers.dart';
import 'core/theme/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/widgets/fullscreen_loading.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/problems/problems_page.dart';
import 'features/ai/ai_chat_page.dart';
import 'features/map/map_page.dart';
import 'features/history/history_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final pages = const [
    DashboardPage(),
    ProblemsPage(),
    AiChatPage(),
    MapPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final isScanning = appState.dashboard.isScanning;
    final index = ref.watch(navigationIndexProvider);

    return Stack(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: AppColors.surface,
              indicatorColor: Colors.transparent,
              labelTextStyle:
                  WidgetStateProperty.resolveWith<TextStyle>((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  );
                }
                return const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                );
              }),
              iconTheme:
                  WidgetStateProperty.resolveWith<IconThemeData>((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: AppColors.primary);
                }
                return const IconThemeData(color: Colors.white70);
              }),
            ),
          ),
          child: Scaffold(
            body: pages[index],
            bottomNavigationBar: NavigationBar(
              backgroundColor: AppColors.surface,
              indicatorColor: Colors.transparent,
              selectedIndex: index,
              onDestinationSelected: isScanning
                  ? null
                  : (i) => ref.read(navigationIndexProvider.notifier).state = i,
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.speed),
                    label: AppStrings.navDashboard),
                NavigationDestination(
                    icon: Icon(Icons.warning_amber),
                    label: AppStrings.navProblems),
                NavigationDestination(
                    icon: Icon(Icons.smart_toy), label: AppStrings.navAi),
                NavigationDestination(
                    icon: Icon(Icons.map), label: AppStrings.navMap),
                NavigationDestination(
                    icon: Icon(Icons.history),
                    label: AppStrings.navHistory),
              ],
            ),
          ),
        ),
        if (isScanning)
          const FullscreenLoadingOverlay(
            message: 'Scansione in corso...',
            subtitle: 'Interpretazione codici OBD tramite AI',
          ),
      ],
    );
  }
}
