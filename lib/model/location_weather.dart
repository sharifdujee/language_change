import 'dart:convert';

WeatherData homeConsultantFromJson(String str) => WeatherData.fromJson(json.decode(str));

String homeConsultantToJson(WeatherData data) => json.encode(data.toJson());

class WeatherData {
  double latitude;
  double longitude;
  double generationtimeMs;
  int utcOffsetSeconds;
  String timezone;
  String timezoneAbbreviation;
  double elevation;
  HourlyUnits hourlyUnits;
  Hourly hourly;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.hourlyUnits,
    required this.hourly,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
    latitude: json["latitude"]?.toDouble() ?? 0.0,
    longitude: json["longitude"]?.toDouble() ?? 0.0,
    generationtimeMs: json["generationtime_ms"]?.toDouble() ?? 0.0,
    utcOffsetSeconds: json["utc_offset_seconds"] ?? 0,
    timezone: json["timezone"] ?? '',
    timezoneAbbreviation: json["timezone_abbreviation"] ?? '',
    elevation: json["elevation"]?.toDouble() ?? 0.0,
    hourlyUnits: HourlyUnits.fromJson(json["hourly_units"] ?? {}),
    hourly: Hourly.fromJson(json["hourly"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "hourly_units": hourlyUnits.toJson(),
    "hourly": hourly.toJson(),
  };
}

class Hourly {
  List<String> time;
  List<double> temperature2M;

  Hourly({
    required this.time,
    required this.temperature2M,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      // Handle null values by providing an empty list if the field is null
      time: json["time"] != null ? List<String>.from(json["time"].map((x) => x)) : [],
      temperature2M: json["temperature_2m"] != null ? List<double>.from(json["temperature_2m"].map((x) => x?.toDouble() ?? 0.0)) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "time": List<dynamic>.from(time.map((x) => x)),
    "temperature_2m": List<dynamic>.from(temperature2M.map((x) => x)),
  };
}



class HourlyUnits {
  String time;
  String temperature2M;

  HourlyUnits({
    required this.time,
    required this.temperature2M,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"] ?? '',
    temperature2M: json["temperature_2m"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,
  };
}
