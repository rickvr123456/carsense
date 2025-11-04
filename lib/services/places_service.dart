import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/constants/app_constants.dart';

class PlacesService {
  PlacesService(this.apiKey);

  final String apiKey;

  Future<List<Place>> getNearbyMechanics(LatLng pos) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${pos.latitude},${pos.longitude}'
        '&radius=${AppConstants.mechanicsSearchRadius}'
        '&type=car_repair'
        '&key=$apiKey';

    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) return [];
    final data = json.decode(resp.body);
    if (data['status'] != 'OK') return [];

    return (data['results'] as List)
        .map((el) => Place(
              name: el['name'],
              latLng: LatLng(
                el['geometry']['location']['lat'],
                el['geometry']['location']['lng'],
              ),
              address: el['vicinity'] ?? '',
            ))
        .toList();
  }
}

class Place {
  Place({required this.name, required this.latLng, required this.address});

  final String name;
  final LatLng latLng;
  final String address;
}
