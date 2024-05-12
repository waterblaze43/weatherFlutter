import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:weather_app/additional_data_item.dart";
import "package:weather_app/forecast_card.dart";
import "package:http/http.dart" as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = "Kāraikāl";
    String countryName = "IN";

    try {
      final res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,$countryName&APPID=47754da136f5a0d285844ed67adabb4a&units=metric"));
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw "An unnexpected Error Occured";
      } else {
        return data;
        /* setState(() {
          temp = data["list"][0]["main"]["temp"];
          type = data["list"][0]["weather"][0]["main"];
          humidity = data["list"][0]["main"]["humidity"];
          windSpeed = data["list"][0]["wind"]["speed"];
          pressure = data["list"][0]["main"]["pressure"];
        }); */
      }
    } catch (e) {
      throw "An Unexpected Error Occured";
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
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
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentWeatherData = data["list"][0];

          final currentTemp = currentWeatherData["main"]["temp"];
          final currentWeatherType = currentWeatherData["weather"][0]["main"];
          final currentHumidity = currentWeatherData["main"]["humidity"];
          final currentWindSpeed = currentWeatherData["wind"]["speed"];
          final currentPressure = currentWeatherData["main"]["pressure"];
          return Padding(
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
                                "$currentTemp° C",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentWeatherType == "Clouds"
                                    ? Icons.cloud
                                    : currentWeatherType == "Rain"
                                        ? Icons.cloudy_snowing
                                        : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentWeatherType,
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
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyData = data["list"][index + 1];
                      final time = DateTime.parse(hourlyData["dt_txt"]);
                      final hourlyValue = hourlyData["weather"][0]["main"];
                      final hourlyIconData = hourlyValue == "Clouds"
                          ? Icons.cloud
                          : hourlyValue == "Rain"
                              ? Icons.cloudy_snowing
                              : Icons.sunny;
                      return ForecastCard(
                        time: DateFormat.j().format(time),
                        value: hourlyValue,
                        icon: hourlyIconData,
                      );
                    },
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
                      value: "$currentHumidity",
                    ),
                    AdditionalDataItem(
                      icon: Icons.air,
                      type: "Wind Speed",
                      value: "$currentWindSpeed",
                    ),
                    AdditionalDataItem(
                      icon: Icons.beach_access,
                      type: "Pressure",
                      value: "$currentPressure",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
