import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import "package:weather_app/additional_data_item.dart";
import "package:weather_app/forecast_card.dart";
import "package:http/http.dart" as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0, windSpeed = 0;
  int humidity = 0, pressure = 0;
  String type = "";

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    String cityName = "Kāraikāl";
    String countryName = "IN";
    try {
      final res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,$countryName&APPID=47754da136f5a0d285844ed67adabb4a"));
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw "An unnexpected Error Occured";
      } else {
        setState(() {
          temp = data["list"][0]["main"]["temp"];
          type = data["list"][0]["weather"][0]["main"];
          humidity = data["list"][0]["main"]["humidity"];
          windSpeed = data["list"][0]["wind"]["speed"];
          pressure = data["list"][0]["main"]["pressure"];
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //getCurrentWeather();
              getCurrentWeather();
              print("refresh");
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Main Card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "${temp}K",
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            type,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Weather Forecast",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ForecastCard(
                    time: "09:00",
                    value: "317.1",
                    icon: Icons.cloud,
                  ),
                  ForecastCard(
                    time: "12:00",
                    value: "318.2",
                    icon: Icons.cloud,
                  ),
                  ForecastCard(
                    time: "15:00",
                    value: "315.0",
                    icon: Icons.sunny,
                  ),
                  ForecastCard(
                    time: "18:00",
                    value: "320.5",
                    icon: Icons.cloud,
                  ),
                  ForecastCard(
                    time: "21:00",
                    value: "319.2",
                    icon: Icons.cloud,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Additional Information",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalDataItem(
                  icon: Icons.water_drop,
                  type: "Humidity",
                  value: "$humidity",
                ),
                AdditionalDataItem(
                  icon: Icons.air,
                  type: "Wind Speed",
                  value: "$windSpeed",
                ),
                AdditionalDataItem(
                  icon: Icons.beach_access,
                  type: "Pressure",
                  value: "$pressure",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
