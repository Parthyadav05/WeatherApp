// weather_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/model.dart';


class WeatherProvider with ChangeNotifier {
  Model? _data;
  Model? get data => _data;
  String? get LastCity => _lastSearchedCity;
  String _lastSearchedCity = '';

  Future<void> searchCity(String city) async {
    _lastSearchedCity = city;

    try {
      final response = await http.get(Uri.parse(
          'URL$city&appid=APIKEY'));

      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        _data = Model.fromJson(parsedJson);
        notifyListeners();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service');
    }
  }

  Future<void> refreshWeather() async {
    try {
      if (_lastSearchedCity.isNotEmpty) {
        await searchCity(_lastSearchedCity);
      }
    } catch (error) {
      throw Exception('Failed to refresh weather data');
    }
  }

  Future<void> saveLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastCity', _lastSearchedCity);
  }

  Future<String?> getLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastSearchedCity = prefs.getString('lastCity')!;
    return prefs.getString('lastCity');
  }
}
