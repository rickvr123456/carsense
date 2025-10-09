import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Mappa')),
      body: const Center(
        child: Text('Mappa Google - verrà integrata con google_maps_flutter'),
      ),
    );
  }
}
