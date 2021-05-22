import 'package:flutter/material.dart';
import 'package:happen_link/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela login',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        //'/': (BuildContext context) => LoginPage(),
        '/': (BuildContext context) => HomePage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
      },
    );
  }
}
