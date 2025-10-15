import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import 'dashboard_state.dart';
import '../info/info_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa lo stato condiviso AppState per permettere alle altre pagine di leggere i DTC
    final appState = context.read<AppState>();
    return ChangeNotifierProvider.value(
      value: appState.dashboard,
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<DashboardState>(
      builder: (context, state, _) {
        final connected = state.connected;
        return Scaffold(
          backgroundColor: const Color(0xFF0F1418),
          appBar: AppBar(
            title: const Text('CarSense'),
            centerTitle: true,
            backgroundColor: const Color(0xFF0F1418),
            elevation: 0,
            actions: [
              IconButton(
                tooltip: 'Informazioni',
                icon:
                    const Icon(Icons.info_outline_rounded, color: Colors.green),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const InfoPage()),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _MetricsCard(
                  rpm: connected ? '${state.rpm}' : '----',
                  speed: connected ? '${state.speed}' : '----',
                  battery: connected ? '${state.batteryV}' : '----',
                  coolant: connected ? '${state.coolantC}' : '----',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (connected) {
                            state.rescan();
                          } else {
                            state.toggleConnectionAndScan();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2BE079),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.cable_rounded),
                        label: Text(
                            connected ? 'Scansiona' : 'Connetti e scansiona'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Dot(connected ? Colors.greenAccent : Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  connected ? 'CONNESSO' : 'NON CONNESSO',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                if (connected)
                  Text(
                    state.dtcs.isEmpty
                        ? 'Nessun errore rilevato'
                        : '${state.dtcs.length} errori rilevati',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricsCard extends StatelessWidget {
  final String rpm, speed, battery, coolant;
  const _MetricsCard({
    required this.rpm,
    required this.speed,
    required this.battery,
    required this.coolant,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile(IconData icon, String value, String label) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF2BE079), size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: tile(Icons.speed, rpm, 'RPM')),
              const SizedBox(width: 12),
              Expanded(child: tile(Icons.memory, speed, 'km/h')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: tile(Icons.battery_charging_full_rounded, battery,
                      'V - Batteria')),
              const SizedBox(width: 12),
              Expanded(
                  child: tile(Icons.thermostat, coolant,
                      '°C Liquido di raffreddamento')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
