import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/places_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const String apiKey = 'AIzaSyCRPNZQrtQDBZzjc5pkQYvAMqfASEwmyfc'; // inserisci la tua chiave qui

  GoogleMapController? mapController;
  LatLng? myPosition;
  List<Place> mechanics = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _prepareMap();
  }

  Future<void> _prepareMap() async {
    setState(() {
      loading = true; error = null;
    });
    try {
      // Permessi e posizione
      LocationPermission perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        setState(() { error = 'Permesso posizione negato.'; loading = false; });
        return;
      }
      Position pos = await Geolocator.getCurrentPosition();
      myPosition = LatLng(pos.latitude, pos.longitude);
      final service = PlacesService(apiKey);
      mechanics = await service.getNearbyMechanics(myPosition!);
      setState(() { loading = false; });
    } catch (e) {
      setState(() { error = 'Errore caricamento mappa.'; loading = false; });
    }
  }

  Set<Marker> _mk() {
    final set = <Marker>{};
    if (myPosition != null) {
      set.add(Marker(
        markerId: const MarkerId('me'),
        position: myPosition!,
        infoWindow: const InfoWindow(title: 'La mia posizione'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    }
    for (final el in mechanics) {
      set.add(Marker(
        markerId: MarkerId(el.name),
        position: el.latLng,
        infoWindow: InfoWindow(title: el.name, snippet: el.address),
      ));
    }
    return set;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mappa')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mappa')),
        body: Center(child: Text(error!)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Meccanici vicino a te')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: myPosition!, zoom: 13),
        markers: _mk(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (c) => mapController = c,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _prepareMap,
        child: const Icon(Icons.refresh),
        tooltip: 'Ricarica officine',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
