import 'package:flutter/material.dart';
import 'dart:convert'; // Import this to use jsonDecode
import 'package:weather/services/location_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final double latitude = 52.52;
  final double longitude = 13.13;
  List<String> hourlyTimes = [];
  List<String> hourlyWeather = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  void _getWeatherData() async {
    try {
      final response = await LocationService.getLocationWiseWeatherData(
          latitude, longitude, '');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          hourlyTimes = List<String>.from(data['hourly']['time']);
          
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      _showError('An error occurred: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hourlyTimes.isNotEmpty
            ? _weatherData()
            : _emptyScreen(),
      ),
    );
  }


  Widget _emptyScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
            'https://9to5mac.com/wp-content/uploads/sites/6/2024/06/weather-outage.jpg?quality=82&strip=all&w=1600'),
        SizedBox(height: 20),
        Text('No weather data available. Please try again later.',
            textAlign: TextAlign.center),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _getWeatherData, // Retry fetching data
          child: Text('Retry'),
        ),
      ],
    );
  }


  Widget _weatherData() {
    if (hourlyTimes.isEmpty || hourlyWeather.isEmpty) {
      return _emptyScreen(); // Display an empty screen if there's no data
    }

    return ListView.builder(
      itemCount: hourlyTimes.length,
      itemBuilder: (context, index) {
        // Check if index is within the bounds of the lists
        if (index < hourlyTimes.length && index < hourlyWeather.length) {
          return ListTile(
            title: Text(hourlyTimes[index]),
            subtitle: Text(hourlyWeather[index]),
          );
        } else {
          // Handle the case where the lists are not synchronized
          return const ListTile(
            title: Text('Invalid data'),
            subtitle: Text('Please try again later.'),
          );
        }
      },
    );
  }
}
