import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class LocationService {
  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  /// Searches for addresses using OpenStreetMap Nominatim with respectful user-agent
  static Future<List<AddressModel>> searchAddress(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse(
        '$nominatimBaseUrl/search?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=5&countrycodes=in',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': 'AquaPure-WaterPurifierApp/1.0 (support@aquapure.com)',
      }).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) {
          final addr = item['address'] ?? {};
          final city = addr['city'] ?? addr['town'] ?? addr['state_district'] ?? 'Bangalore';
          final state = addr['state'] ?? 'Karnataka';
          final postcode = addr['postcode'] ?? '560001';
          final displayName = item['display_name'] ?? query;

          return AddressModel(
            id: 'osm-${item['place_id']}',
            label: 'Location',
            street: displayName.toString().split(',').take(2).join(', ').trim(),
            city: city.toString(),
            state: state.toString(),
            postalCode: postcode.toString(),
            latitude: double.tryParse(item['lat']?.toString() ?? ''),
            longitude: double.tryParse(item['lon']?.toString() ?? ''),
          );
        }).toList();
      }
    } catch (e) {
      print('Location search fallback active: $e');
    }

    // Default fast offline suggestions
    return [
      AddressModel(
        id: 'fallback-1',
        label: 'Selected Address',
        street: query.isNotEmpty ? query : 'MG Road, Central Business District',
        city: 'Bangalore',
        state: 'Karnataka',
        postalCode: '560001',
        latitude: 12.9716,
        longitude: 77.5946,
      ),
    ];
  }

  /// Reverse geocodes coordinates to Address using OpenStreetMap
  static Future<AddressModel?> reverseGeocode(double lat, double lon) async {
    try {
      final uri = Uri.parse('$nominatimBaseUrl/reverse?lat=$lat&lon=$lon&format=json&addressdetails=1');
      final response = await http.get(uri, headers: {
        'User-Agent': 'AquaPure-WaterPurifierApp/1.0 (support@aquapure.com)',
      }).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addr = data['address'] ?? {};
        return AddressModel(
          id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
          label: 'Current Location',
          street: addr['road'] ?? addr['suburb'] ?? 'Detected Street',
          city: addr['city'] ?? addr['town'] ?? 'Bangalore',
          state: addr['state'] ?? 'Karnataka',
          postalCode: addr['postcode'] ?? '560001',
          latitude: lat,
          longitude: lon,
        );
      }
    } catch (e) {
      print('Reverse geocoding fallback active: $e');
    }
    return null;
  }
}
