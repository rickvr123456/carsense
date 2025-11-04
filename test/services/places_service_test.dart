import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/services/places_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group('PlacesService Tests', () {
    late PlacesService placesService;
    const testApiKey = 'test_api_key_AIzaSyCRPNZQrtQDBZzjc5pkQYvAMqfASEwmyfc';

    setUp(() {
      placesService = PlacesService(testApiKey);
    });

    test('PlacesService should initialize with API key', () {
      expect(placesService, isNotNull);
      expect(placesService.apiKey, testApiKey);
    });

    test('Place model should store all fields correctly', () {
      final place = Place(
        name: 'Officina Test',
        latLng: const LatLng(45.4642, 9.1900),
        address: 'Via Test 123, Milano',
      );

      expect(place.name, 'Officina Test');
      expect(place.latLng.latitude, 45.4642);
      expect(place.latLng.longitude, 9.1900);
      expect(place.address, 'Via Test 123, Milano');
    });
  });
}
