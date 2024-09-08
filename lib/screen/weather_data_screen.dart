import 'package:flutter/material.dart';
import 'package:weather/model/location_weather.dart';

class WeatherDataScreen extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDataScreen({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location: ${weatherData.latitude}, ${weatherData.longitude}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Timezone: ${weatherData.timezone} (${weatherData.timezoneAbbreviation})',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Elevation: ${weatherData.elevation} meters',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hourly Forecast:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Ensure both lists are not empty before attempting to display data
            weatherData.hourly.time.isNotEmpty && weatherData.hourly.temperature2M.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: weatherData.hourly.time.length,
                itemBuilder: (context, index) {
                  // Ensure the index is within the valid range for both lists
                  if (index < weatherData.hourly.temperature2M.length) {
                    final time = weatherData.hourly.time[index];
                    final temperature = weatherData.hourly.temperature2M[index];

                    return Card(
                      child: ListTile(
                        title: Text('Time: $time'),
                        subtitle: Text(
                          'Temperature: $temperature °C',
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(); // Return an empty widget if index is out of range
                  }
                },
              ),
            )
                : const Text(
              'No hourly forecast data available.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
