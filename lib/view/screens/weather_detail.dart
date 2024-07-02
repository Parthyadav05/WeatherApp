import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_map_auth/view/widgets/weather_detail_card.dart';
import 'package:provider/provider.dart';

import '../../view_model/provider/data_provider.dart';

class WeatherDetailsScreen extends StatelessWidget {
  void _refreshWeather(BuildContext context) async {
    try {
      await Provider.of<WeatherProvider>(context, listen: false)
          .refreshWeather();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh weather data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = Provider.of<WeatherProvider>(context).data;
    final lastSearchedCity = Provider.of<WeatherProvider>(context).LastCity;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
        backgroundColor: Color.fromRGBO(137, 207, 240, 0.5),
        elevation: 20,
        toolbarHeight: 70,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refreshWeather(context);

    },
          ),
        ],
      ),
      body: weatherData != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  PlanCardComponent(
                    weatherData: weatherData,
                  ),
                  SizedBox(height: 10,),
                  Text("Recent Search",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  Row(children: [
                    FaIcon(FontAwesomeIcons.clock ,color: Colors.grey,),SizedBox(width: 10,),Text('${lastSearchedCity}',style: TextStyle(fontSize: 20),)
                  ],)
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
