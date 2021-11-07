import 'dart:async';

import 'package:flutter/material.dart';
import 'package:happen_link/deck_add_page.dart';
import 'package:happen_link/deck_audio_edit_page.dart';
import 'package:happen_link/deck_createedit_flashcard_page.dart';
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
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:happen_link/share_target_page.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.start();

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  var isLogged = await API.isLogged();

  runApp(MyApp(
    initialRoute: isLogged ? HomePage.routeName : LoginPage.routeName,
  ));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  MyApp({this.initialRoute});

  @override
  _MyAppState createState() => _MyAppState(this.initialRoute);
}

class _MyAppState extends State<MyApp> {
  String initialRoute;
  StreamSubscription _intentDataStreamSubscription;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  _MyAppState(this.initialRoute);

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      navigatorKey.currentState
          .pushNamed(ShareTargetPage.routeName, arguments: value);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.length != 0) {
        navigatorKey.currentState
            .pushNamed(ShareTargetPage.routeName, arguments: value);
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Happen Link',
      theme: ThemeData(primarySwatch: Colors.teal, accentColor: Colors.black),
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        ShareTargetPage.routeName: (BuildContext context) => ShareTargetPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        DecksPage.routeName: (BuildContext context) => DecksPage(),
        ProcedurePage.routeName: (BuildContext context) => ProcedurePage(),
        ProcedureShowPage.routeName: (BuildContext context) =>
            ProcedureShowPage(),
        DeckAddPage.routeName: (BuildContext context) => DeckAddPage(),
        DeckShowPage.routeName: (BuildContext context) => DeckShowPage(),
        DeckReviewPage.routeName: (BuildContext context) => DeckReviewPage(),
        DeckReviewDone.routeName: (BuildContext context) => DeckReviewDone(),
        DeckCreateEditFlashcardPage.routeName: (BuildContext context) =>
            DeckCreateEditFlashcardPage(),
        DeckAudioEditPage.routeName: (BuildContext context) =>
            DeckAudioEditPage(),
        GPSLinkPage.routeName: (BuildContext context) => GPSLinkPage(),
        GPSLinkEditPage.routeName: (BuildContext context) => GPSLinkEditPage(),
        GPSLinkShowPage.routeName: (BuildContext context) => GPSLinkShowPage(),
      },
    );
  }
}
