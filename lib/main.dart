import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import './HourlyForecastItem.dart';
import './AdditionalInformationItem.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherApp();
  }
}

class _WeatherApp extends State<WeatherApp> {
  double temp = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   CurrentWeather();
  // }

  Future<Map<String, dynamic>> CurrentWeather(String cityName) async {
    try {
      // String cityName = "Coimbatore";
      final openWeatherAPIKey = '48afe1b85a99cba0eae5c2c677090e9c';
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey",
        ),
      );
      final data = jsonDecode(res.body);
      if (int.parse(data['cod']) != 200) {
        throw ('Unexpected error occurred');
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityname = "Bengaluru";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        //scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // actions: [GestureDetector
          // (onTap: () => print("refresh"),
          //   child: const Icon(Icons.refresh))],
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  //rebuilding
                });
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: FutureBuilder(
          future: CurrentWeather(cityname),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp'];
            final currentWeather = currentWeatherData['weather'][0]['main'];
            final humidity = currentWeatherData['main']['humidity'];
            final pressure = currentWeatherData['main']['pressure'];
            final windSpeed = currentWeatherData['wind']['speed'];

            return Padding(
              padding: EdgeInsetsGeometry.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(child: Text(cityname,style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)),
                  const SizedBox(height: 15),
                  //mainCard
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsetsGeometry.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "${currentTemp}°K",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Icon(
                                  currentWeather == 'Clouds'
                                      ? Icons.cloud
                                      : currentWeather == 'Rain'
                                      ? Icons.thunderstorm
                                      : currentWeather == 'Snow'
                                      ? Icons.cloudy_snowing
                                      : Icons.sunny,
                                  size: 65,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  currentWeather,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //weather forecast cards
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      "Weather Forecast",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       HourlyForecast(
                  //         time: "09:00",
                  //         icon: Icons.cloud,
                  //         temp: "301.17",
                  //       ),
                  //       HourlyForecast(
                  //         time: "12:00",
                  //         icon: Icons.sunny,
                  //         temp: "301.54",
                  //       ),
                  //       HourlyForecast(
                  //         time: "15:00",
                  //         icon: Icons.cloud,
                  //         temp: "301.11",
                  //       ),
                  //       HourlyForecast(
                  //         time: "18:00",
                  //         icon: Icons.cloudy_snowing,
                  //         temp: "301.54",
                  //       ),
                  //       HourlyForecast(
                  //         time: "21:00",
                  //         icon: Icons.thunderstorm,
                  //         temp: "301.67",
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: data['list'].length - 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final time = DateTime.parse(
                          data['list'][index + 1]['dt_txt'].toString(),
                        );
                        final hourlyTime = DateFormat.j().format(time);
                        final hourlyWeather =
                            data['list'][index + 1]['weather'][0]['main']
                                .toString();
                        final hourlytemp =
                            data['list'][index + 1]['main']['temp'].toString();
                        return HourlyForecast(
                          time: hourlyTime,
                          icon: hourlyWeather == 'Clouds'
                              ? Icons.cloud
                              : hourlyWeather == 'Rain'
                              ? Icons.thunderstorm
                              : hourlyWeather == 'Snow'
                              ? Icons.cloudy_snowing
                              : Icons.sunny,
                          temp: hourlytemp,
                        );
                      },
                    ),
                  ),
                  //Additional info
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInformation(
                        icon: Icons.water_drop,
                        title: "Humidity",
                        value: humidity.toString(),
                      ),
                      AdditionalInformation(
                        icon: Icons.air,
                        title: "Wind Speed",
                        value: windSpeed.toString(),
                      ),
                      AdditionalInformation(
                        icon: Icons.beach_access,
                        title: "Pressure",
                        value: pressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
