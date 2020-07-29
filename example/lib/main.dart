import 'package:flutter/material.dart';
import 'package:mangazenkan_login/mangazenkan_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlatButton(
            child: Text('漫画全巻ドットコムアカウントでログインする'),
            color: Colors.amber,
            onPressed: () async {
              final _mangazenkanLogin = MangazenkanLogin(
                clientId: 'xxxxxxxxx',
                redirectURI: 'CUSTOMURL',
                responseType: ['token'],
              );
              final result = await _mangazenkanLogin.login();
              switch (result.status) {
                case LoginStatus.loggedIn:
                  break;

                case LoginStatus.error:
                  break;

                case LoginStatus.cancelledByUser:
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
