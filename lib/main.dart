import 'package:flutter/material.dart';
import 'package:weather/common/theme.dart';
import 'package:weather/screens/dashboard.dart';
import 'package:weather/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'common/constants.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Constants.appName,
        theme: appTheme,
        home: Builder(
          builder: (context) {
            return Login();
          },
        ),
        initialRoute: Login.routeName,
        routes: {
          Login.routeName: (context) => Login(),
          Dashboard.routeName: (context) => Dashboard()
        });
  }
}
