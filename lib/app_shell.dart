import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/problems/problems_page.dart';
import 'features/chat/chat_page.dart';
import 'features/map/map_page.dart';
import 'features/history/history_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  final pages = const [
    DashboardPage(),
    ProblemsPage(),
    ChatPage(),
    MapPage(),
    HistoryPage(), // ← nuova pagina, ultima
  ];

  Color get _selectedColor => const Color(0xFF2BE079); // verde

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0F1418),
        indicatorColor: Colors.transparent,
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.speed,
                color: index == 0 ? _selectedColor : Colors.white70),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber,
                color: index == 1 ? _selectedColor : Colors.white70),
            label: 'Problemi',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy,
                color: index == 2 ? _selectedColor : Colors.white70),
            label: 'Supporto IA',
          ),
          NavigationDestination(
            icon: Icon(Icons.map,
                color: index == 3 ? _selectedColor : Colors.white70),
            label: 'Mappa',
          ),
          NavigationDestination(
            icon: Icon(Icons.history,
                color: index == 4 ? _selectedColor : Colors.white70),
            label: 'Cronologia',
          ),
        ],
      ),
    );
  }
}
