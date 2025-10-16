import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/problems/problems_page.dart';
// CAMBIA QUI: usa la nuova pagina AI
import 'features/ai/ai_chat_page.dart';
import 'features/map/map_page.dart';
import 'features/history/history_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  static const Color _selectedColor = Color(0xFF2BE079);

  final pages = const [
    DashboardPage(),
    ProblemsPage(),
    AiChatPage(), // <<— deve essere questa se hai importato ai_chat_page.dart
    MapPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF0F1418),
          indicatorColor: Colors.transparent,
          labelTextStyle:
              MaterialStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                color: _selectedColor,
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            );
          }),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: _selectedColor);
            }
            return const IconThemeData(color: Colors.white70);
          }),
        ),
      ),
      child: Scaffold(
        body: pages[index],
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF0F1418),
          indicatorColor: Colors.transparent,
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.speed), label: 'Dashboard'),
            NavigationDestination(
                icon: Icon(Icons.warning_amber), label: 'Problemi'),
            NavigationDestination(icon: Icon(Icons.smart_toy), label: 'AI'),
            NavigationDestination(icon: Icon(Icons.map), label: 'Mappa'),
            NavigationDestination(
                icon: Icon(Icons.history), label: 'Cronologia'),
          ],
        ),
      ),
    );
  }
}
