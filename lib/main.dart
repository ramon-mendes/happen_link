import 'package:flutter/material.dart';
import 'package:happen_link/deck_add_page.dart';
import 'package:happen_link/deck_review_done.dart';
import 'package:happen_link/deck_review_page.dart';
import 'package:happen_link/deck_show_page.dart';
import 'package:happen_link/decks_page.dart';
import 'package:happen_link/home_page.dart';
import 'package:happen_link/login_page.dart';
import 'package:happen_link/procedures_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela login',
      theme: ThemeData(primarySwatch: Colors.teal, accentColor: Colors.black),
      routes: {
        '/': (BuildContext context) => LoginPage(),
        //'/': (BuildContext context) => HomePage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        DecksPage.routeName: (BuildContext context) => DecksPage(),
        ProceduresPage.routeName: (BuildContext context) => ProceduresPage(),
        DeckAddPage.routeName: (BuildContext context) => DeckAddPage(),
        DeckShowPage.routeName: (BuildContext context) => DeckShowPage(),
        DeckReviewPage.routeName: (BuildContext context) => DeckReviewPage(),
        DeckReviewDone.routeName: (BuildContext context) => DeckReviewDone(),
      },
    );
  }
}
