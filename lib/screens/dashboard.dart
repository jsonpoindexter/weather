import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/common/constants.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '';

  Dashboard({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController zipcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                controller: zipcodeController,
                decoration: InputDecoration(
                  // border: InputBorder.,
                  hintText: 'Enter a zipcode',
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {},
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
