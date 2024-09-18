import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/services/base_class.dart';

class TrackParcel {
  static Future<Map<String, dynamic>?> trackCustomerDetails(String mobileNumber) async {
    try {
      final url = Uri.parse('${BaseClass.PARCEL_TRACK_API}?phone=$mobileNumber');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('The API response is ${response.body}');
        return data;  // Return the parsed JSON data
      } else {
        print('Failed to track parcel. Status code: ${response.statusCode}');
        return null;  // Return null for failed status codes
      }
    } catch (e) {
      print(e.toString());
      return null;  // Return null in case of exception
    }
  }
}
