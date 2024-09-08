import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather/services/base_class.dart';

class LocationService{

  static Future<http.Response> getLocationWiseWeatherData(double latitude, double longitude, String hourlyTemperature) async {
    try {
      var response = await http.get(
        Uri.parse('${BaseClass.API_BASE_URL}?latitude=$latitude&longitude=$longitude&hourly=$hourlyTemperature'),
      );
      if (response.statusCode == 200) {
        print('The API response is ${response.body}');
        return response;
      } else {
        throw Exception('Failed to load weather data');
      }
    } on Exception catch (e) {
      print(e.toString());
      throw Exception('Failed to load weather data: $e');
    }
  }


}