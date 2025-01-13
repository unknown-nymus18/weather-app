import 'package:flutter/material.dart';
import 'package:weather_app/components/blur.dart';

class WeatherCard extends StatelessWidget {
  final String weather;
  final String windSpeed;
  final String temp;
  final String humidity;
  final String time;
  const WeatherCard({
    super.key,
    required this.weather,
    required this.windSpeed,
    required this.temp,
    required this.humidity,
    required this.time,
  });

  Widget getWeatherPicture(String weather) {
    if (weather == 'Clear') {
      return SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'lib/assets/images/sun.png',
            ),
            Text(
              weather,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    if (weather == 'Clouds') {
      return SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'lib/assets/images/cloudy.png',
            ),
            Text(
              weather,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    if (weather == 'Rain') {
      return SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'lib/assets/images/rainy.png',
            ),
            Text(
              weather,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          children: [
            Image.asset(
              'lib/assets/images/sun.png',
            ),
            Text(
              weather,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Blur(
      sigmaX: 10,
      sigmaY: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            getWeatherPicture(weather),
            Text('Temp: $temp k'),
            Text('Wind Speed: $windSpeed m/s'),
            Text('Humidity: $humidity%'),
          ],
        ),
      ),
    );
  }
}
