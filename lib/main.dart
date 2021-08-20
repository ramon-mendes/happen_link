import 'package:flutter/material.dart';
import 'package:happen_link/deck_add_page.dart';
import 'package:happen_link/deck_audio_edit_page.dart';
import 'package:happen_link/deck_edit_flashcard_page.dart';
import 'package:happen_link/deck_review_done.dart';
import 'package:happen_link/deck_review_page.dart';
import 'package:happen_link/deck_show_page.dart';
import 'package:happen_link/decks_page.dart';
import 'package:happen_link/gpslink_edit_page.dart';
import 'package:happen_link/gpslink_page.dart';
import 'package:happen_link/gpslink_show_page.dart';
import 'package:happen_link/home_page.dart';
import 'package:happen_link/login_page.dart';
import 'package:happen_link/procedure_page.dart';
import 'package:happen_link/procedure_show_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:happen_link/services/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.start();

  var isLogged = await API.isLogged();

  runApp(MyApp(
    initialRoute: isLogged ? HomePage.routeName : LoginPage.routeName,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happen Link',
      theme: ThemeData(primarySwatch: Colors.teal, accentColor: Colors.black),
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        DecksPage.routeName: (BuildContext context) => DecksPage(),
        ProcedurePage.routeName: (BuildContext context) => ProcedurePage(),
        ProcedureShowPage.routeName: (BuildContext context) => ProcedureShowPage(),
        DeckAddPage.routeName: (BuildContext context) => DeckAddPage(),
        DeckShowPage.routeName: (BuildContext context) => DeckShowPage(),
        DeckReviewPage.routeName: (BuildContext context) => DeckReviewPage(),
        DeckReviewDone.routeName: (BuildContext context) => DeckReviewDone(),
        DeckEditFlashcardPage.routeName: (BuildContext context) => DeckEditFlashcardPage(),
        DeckAudioEditPage.routeName: (BuildContext context) => DeckAudioEditPage(),
        GPSLinkPage.routeName: (BuildContext context) => GPSLinkPage(),
        GPSLinkEditPage.routeName: (BuildContext context) => GPSLinkEditPage(),
        GPSLinkShowPage.routeName: (BuildContext context) => GPSLinkShowPage(),
      },
    );
  }
}
