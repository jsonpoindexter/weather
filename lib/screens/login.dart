import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'dashboard.dart';

class Login extends StatefulWidget {
  static const routeName = 'login';
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  String _message = '';

  Future<Null> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        Navigator.pushReplacementNamed(context, Dashboard.routeName);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        _showMessage(
            'Something went wrong with the login process.\n${result.errorMessage}');
        break;
    }
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(_message),
            new RaisedButton(
              onPressed: _login,
              child: new Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
