import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  static const String apikey = 'AIzaSyC__KCm_cD2b-i40AEpPqMVYHrXQusPMak';

  static Future<List<dynamic>> getAutocompleteSuggestions(String input) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/autocomplete/json?input=$input&key=${apikey}&components=country:pk'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['predictions'];
        }
      }
      return [];
    } catch (e) {
      print('Autocomplete error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/details/json?place_id=$placeId&key=${apikey}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['result'];
        }
      }
      return null;
    } catch (e) {
      print('Place details error: $e');
      return null;
    }
  }

  static Future<Map<String, double>?> getCoordinatesFromAddress(
      String address) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${apikey}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return {
            'lat': location['lat'].toDouble(),
            'lng': location['lng'].toDouble(),
          };
        }
      }
      return null;
    } catch (e) {
      print('Geocoding error: $e');
      return null;
    }
  }
}
