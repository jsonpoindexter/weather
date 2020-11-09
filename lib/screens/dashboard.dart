import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  String _temperature = '';
  final _storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _readZipcode();
  }

  Future<Null> _readZipcode() async {
    var zipcode = await _storage.read(key: 'zipcode');
    if (zipcode != null) {
      zipcodeController.value = TextEditingValue(text: zipcode);
      fetchWeather(zipcode);
    }
  }

  Future<String> fetchWeather(String zipcode) async {
    var queryParameters = {
      'zip': zipcode,
      'units': 'imperial',
      'appid': Constants.openWeatherApiId,
    };
    var uri = Uri.https(
        Constants.openWeatherUri, '/data/2.5/weather', queryParameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      _storage.write(key: "zipcode", value: zipcode);
      var jsonResponse = convert.jsonDecode(response.body);
      var temperature;
      try {
        temperature = jsonResponse['main']['temp'].round().toString();
      } catch (error) {
        return "Unable to fetch temperature information.";
      }
      setState(() {
        _temperature = temperature;
      });
      return null;
    } else if (response.statusCode == 404) {
      setState(() {
        _temperature = '';
      });
      return 'Invalid zipcode. Please try again.';
    } else {
      // Handle general errors
      setState(() {
        _temperature = '';
      });
      return 'Request failed with status: ${response.statusCode}.';
    }
  }

  void logOut() {
    _storage.delete(key: 'zipcode');
    Navigator.pushReplacementNamed(context, Login.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
        actions: <Widget>[
          new RaisedButton(
            onPressed: () => logOut(),
            child: new Text('Logout'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_temperature.isNotEmpty)
              Text('Current Temperature: ' + _temperature + 'F'),
            Container(
                width: 200.0,
                child: TextField(
                    onChanged: (_) => setState(() => _temperature = ''),
                    textAlign: TextAlign.center,
                    controller: zipcodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter a zipcode',
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  var error = await fetchWeather(zipcodeController.text);
                  if (error != null) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        elevation: 10,
                        title: Text("Error"),
                        content: Text(error),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
