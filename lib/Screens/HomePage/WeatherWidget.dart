import 'package:agriteck/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Services/WeatherServices/weather-services.dart';
import '../../Services/sharedPrefs.dart';

class WeatherSection extends StatefulWidget {
  const WeatherSection({super.key});

  @override
  State<WeatherSection> createState() => _WeatherSectionState();
}

class _WeatherSectionState extends State<WeatherSection> {
  Map<String, dynamic>? waetherForFivedays;

  List? weatherData;
  String? _currentDate;
  var _userLocation;
  Future<Map<String, dynamic>> getWeatherUpdate() async {
    WeatherServices weather =
        WeatherServices("9be7d9f30e6275394f7aa27d8093dd5f");

    waetherForFivedays = await weather.getFiveDayForecast();
    weatherData = waetherForFivedays!['list'];
    _currentDate = weather.getDateTime();
    _userLocation = await SharedPrefs.getPositionInfo();
    return await weather.getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SliverToBoxAdapter(
        child: FutureBuilder(
            future: getWeatherUpdate(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var weatherJSON = snapshot.data;
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${weatherJSON!['name']} - ${_userLocation['locationName']}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _currentDate!,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12, top: 8, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${weatherJSON!['weather'][0]['main']} - ${weatherJSON['weather'][0]['description']}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              '${weatherJSON!['main']['temp'].toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              fontSize: 60,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold)),
                                      WidgetSpan(
                                        child: Transform.translate(
                                          offset: const Offset(2, -10),
                                          child: const Text('°C',
                                              //superscript is usually smaller in size
                                              textScaleFactor: 0.7,
                                              style: TextStyle(
                                                  fontSize: 60,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      TextSpan(
                                          text:
                                              '\nMin:${weatherJSON['main']['temp_min'].toStringAsFixed(0)}°C /Max:${weatherJSON['main']['temp_max'].toStringAsFixed(0)}°C ',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w800)),
                                    ]),
                                  ),
                                ],
                              )),
                              Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/weather.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Wind: ${weatherJSON!['wind']['speed'].toStringAsFixed(2)}m/s',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(child: CircularProgressIndicator()));
              }
            }));
  }
}
