// home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_map_auth/view/screens/weather_detail.dart';
import 'package:provider/provider.dart';

import '../../view_model/provider/data_provider.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;

  void _searchWeather(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<WeatherProvider>(context, listen: false)
          .searchCity(_cityController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WeatherDetailsScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load weather data')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(children: [Lottie.asset('assets/sun.json') ,SizedBox(width: 10,),Text('Weather Info'),],),
        backgroundColor: Color.fromRGBO(137,207,240,0.5),
        elevation: 20,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 20,),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Enter city name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _searchWeather(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(137,207,240,1),
                    elevation: 30
                  ),
                  child: const Text('Search' ,style: TextStyle(color: Colors.black),),
                ),
                if (_isLoading) ...[
                  const SizedBox(height: 10),
                  const Center(child: CircularProgressIndicator()),
                ],
                SizedBox(height: 70,),
              Center(child: Column(
                children: [const Icon(Icons.add_location_alt ,size: 250,color: Colors.blue,),
                  SizedBox(height: 30,),
                  const Text("Check the Weather of the City" ,style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 25),),],
              ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
