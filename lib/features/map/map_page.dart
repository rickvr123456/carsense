import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../services/places_service.dart';
import '../../riverpod_providers.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/error_handler.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});
  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
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
      loading = true;
      error = null;
    });
    try {
      // Permessi e posizione
      final perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        setState(() {
          error = 'Permesso posizione negato';
          loading = false;
        });
        if (mounted) {
          ErrorHandler.showLocationError(
            context,
            message:
                'L\'app necessita dei permessi di localizzazione per mostrare le officine vicine. '
                'Abilita i permessi nelle impostazioni del dispositivo.',
            onOpenSettings: () {
              // Potremmo aprire le impostazioni con un package come app_settings
              ErrorHandler.showInfo(context,
                  message: 'Vai in Impostazioni > App > CarSense > Permessi');
            },
          );
        }
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      myPosition = LatLng(pos.latitude, pos.longitude);

      final service = ref.read(placesServiceProvider);
      mechanics = await service.getNearbyMechanics(myPosition!);

      setState(() {
        loading = false;
      });
    } on LocationServiceDisabledException {
      setState(() {
        error = 'Servizi di localizzazione disabilitati';
        loading = false;
      });
      if (mounted) {
        ErrorHandler.showLocationError(
          context,
          message: 'I servizi di localizzazione sono disabilitati. '
              'Abilitali nelle impostazioni del dispositivo per continuare.',
        );
      }
    } on TimeoutException {
      setState(() {
        error = 'Timeout nel recupero della posizione';
        loading = false;
      });
      if (mounted) {
        ErrorHandler.showGenericError(
          context,
          message:
              'Timeout nel recupero della posizione GPS. Assicurati di essere all\'aperto e riprova.',
          onRetry: _prepareMap,
        );
      }
    } catch (e) {
      setState(() {
        error = 'Errore caricamento mappa: ${e.toString()}';
        loading = false;
      });
      if (mounted) {
        // Check if it's a network error
        if (e.toString().contains('SocketException') ||
            e.toString().contains('Failed host lookup')) {
          ErrorHandler.showNetworkError(context, onRetry: _prepareMap);
        } else {
          ErrorHandler.showGenericError(
            context,
            message: 'Errore nel caricamento della mappa: ${e.toString()}',
            onRetry: _prepareMap,
          );
        }
      }
    }
  }

  Set<Marker> _mk() {
    final set = <Marker>{};
    if (myPosition != null) {
      set.add(Marker(
        markerId: const MarkerId('me'),
        position: myPosition!,
        infoWindow: const InfoWindow(title: AppStrings.myLocation),
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
        appBar: AppBar(title: const Text(AppStrings.nearbyMechanics)),
        body: const LoadingIndicator(message: 'Caricamento mappa...'),
      );
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.nearbyMechanics)),
        body: ErrorDisplay(
          message: error!,
          onRetry: _prepareMap,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.nearbyMechanics)),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: myPosition!, zoom: 13),
        markers: _mk(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (c) => mapController = c,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _prepareMap,
        tooltip: AppStrings.reloadMechanics,
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
