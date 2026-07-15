import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProviDireccion {
  Future<String?> getDireccion(double lat, double lng) async {
    try {
      // 1. Intentar con OpenStreetMap (Nominatim)
      final nominatimUri = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}",
      );

      final osmResponse = await http.get(
        nominatimUri,
        headers: {
          'User-Agent': 'TuApp/1.0', // Recomendado por Nominatim
        },
      );

      if (osmResponse.statusCode == 200) {
        final osmData = json.decode(osmResponse.body);
        if (osmData['display_name'] != null) {
          return osmData['display_name'];
        }
      } else {
        print('Error OSM: ${osmResponse.statusCode}');
      }
    } catch (e) {
      print('Error con OSM: $e');
    }

    // 2. Si OSM falla, usar Google
    try {
      final googleUri = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng= ${lat},${lng}&key=${Platform.isAndroid ? dotenv.env['apiKeyMapAndroid'] : dotenv.env['apiKeyMapIos']}",
      );

      final googleResponse = await http.get(googleUri);

      if (googleResponse.statusCode == 200) {
        final googleData = json.decode(googleResponse.body);
        if (googleData['status'] == 'OK' &&
            googleData['results'] != null &&
            googleData['results'].isNotEmpty) {
          return googleData['results'][0]['formatted_address'];
        }
      } else {
        print('Error Google: ${googleResponse.statusCode}');
      }
    } catch (e) {
      print('Error con Google Maps: $e');
    }

    // Si todo falla
    return 'SIN NOMBRES';
  }

  /*Future<String> getDireccion(lat, lng) async {
    try {
      var url = Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=" +
              lat +
              "," +
              lng +
              "&key=");
      print("object url" + url.toString());
      print(url.toString());
      var response = await http.get(url);
      var json = convert.json.decode(response.body);
      print(json);
      var results = json['results'][0]['formatted_address'];
      return results;
    } catch (e) {
      return 'try Catch';
    }
  }*/
}
