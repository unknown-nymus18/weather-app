import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/components/blur.dart';
import 'package:weather_app/components/weather_card.dart';
import 'package:weather_app/secrets.dart';

class WeatherPage extends StatelessWidget {
  final String city;
  void Function()? addCity;
  void Function()? removeCity;
  WeatherPage(
      {super.key,
      required this.city,
      required this.addCity,
      required this.removeCity});

  Future getWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$API_KEY&units=metrics';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to load weather data');
    }
  }

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(city),
        centerTitle: true,
        backgroundColor: Colors.white70,
        actions: [
          IconButton(
            onPressed: addCity,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: removeCity,
            icon: const Icon(CupertinoIcons.minus),
          )
        ],
      ),
      body: FutureBuilder(
          future: getWeather(city),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List lists = snapshot.data['list'];
              // print(lists[0]);

              return Column(
                children: [
                  Blur(
                    sigmaX: 10,
                    sigmaY: 10,
                    child: Container(
                      // color: Colors.blue,
                      width: double.infinity,
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lists[0]['dt_txt'].toString().substring(10),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getWeatherPicture(
                                  lists[0]['weather'][0]['main'],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Temp: ${lists[0]['main']['temp'].toString()} k',
                                    ),
                                    Text(
                                        'Wind speed: ${lists[0]['wind']['speed'].toString()} m/s'),
                                    Text(
                                        'Humidity: ${lists[0]['main']['humidity'].toString()}%'),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: lists.length - 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, i) {
                        String temp = lists[i + 1]['main']['temp'].toString();
                        String humidity =
                            lists[i + 1]['main']['humidity'].toString();
                        String weather = lists[i + 1]['weather'][0]['main'];
                        String windSpeed =
                            lists[i + 1]['wind']['speed'].toString();

                        String dateTime = lists[i + 1]['dt_txt'];
                        String time = dateTime.substring(10, dateTime.length);
                        return Padding(
                          padding: (i + 1) % 2 != 0
                              ? const EdgeInsets.only(left: 10)
                              : const EdgeInsets.only(right: 10),
                          child: WeatherCard(
                            weather: weather,
                            windSpeed: windSpeed,
                            temp: temp,
                            humidity: humidity,
                            time: time,
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: Text("Nothing was found"),
            );
          }),
    );
  }
}
