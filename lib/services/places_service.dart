import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  final String apiKey;
  PlacesService(this.apiKey);

  Future<List<Place>> getNearbyMechanics(LatLng pos) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${pos.latitude},${pos.longitude}'
        '&radius=20000'
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
  final String name;
  final LatLng latLng;
  final String address;
  Place({required this.name, required this.latLng, required this.address});
}
