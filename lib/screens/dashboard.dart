import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/common/constants.dart';
import 'package:weather/screens/login.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController zipcodeController = TextEditingController();

  String _tempurature = '';

  void logOut() {}

  Future<void> fetchWeather(String zipcode) async {
    var queryParameters = {
      'zip': zipcode,
      'units': 'imperial',
      'appid': Constants.openWeatherApiId,
    };
    var uri = Uri.https(
        Constants.openWeatherUri, '/data/2.5/weather', queryParameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _tempurature = jsonResponse['main']['temp'].round().toString();
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
        actions: <Widget>[
          new RaisedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, Login.routeName),
            child: new Text('Logout'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_tempurature.isNotEmpty)
              Text('Current Tempurature: ' + _tempurature + 'F'),
            TextField(
                controller: zipcodeController,
                decoration: InputDecoration(
                  hintText: 'Enter a zipcode',
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () => fetchWeather(zipcodeController.text),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
