import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:happen_link/decks_page.dart';
import 'package:happen_link/gpslink_page.dart';
import 'package:happen_link/login_page.dart';
import 'package:happen_link/procedure_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:package_info/package_info.dart';

import 'consts.dart' as Consts;
import 'gpslink_show_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _versionCode = "";

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String buildNumber = packageInfo.buildNumber;

      setState(() {
        _versionCode = 'v$buildNumber';
      });
    });

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      Navigator.of(context).pushNamed(GPSLinkShowPage.routeName, arguments: {id: receivedNotification.id});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: UnconstrainedBox(
                  child: Container(
                    width: 270,
                    child: Image(image: AssetImage('assets/logo.png')),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(DecksPage.routeName);
                  },
                  child: Container(
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Decks',
                            style: TextStyle(fontSize: 20, color: Consts.LOGIN_TXT_COLOR),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Flashcards para você revisar seu conhecimento',
                              style:
                                  TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Consts.LOGIN_TXT_COLOR)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProcedurePage.routeName);
                  },
                  child: Container(
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Procedimentos', style: TextStyle(fontSize: 20, color: Consts.LOGIN_TXT_COLOR)),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Instruções passo-a-passo de tarefas conhecidas',
                              style:
                                  TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Consts.LOGIN_TXT_COLOR)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(GPSLinkPage.routeName);
                  },
                  child: Container(
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('GPS Link', style: TextStyle(fontSize: 20, color: Consts.LOGIN_TXT_COLOR)),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Lembretes para quando você entrar em uma área no mapa',
                              style:
                                  TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Consts.LOGIN_TXT_COLOR)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(''),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_versionCode, style: TextStyle(color: Consts.LOGIN_TXT_COLOR)),
                  GestureDetector(
                    onTap: () async {
                      await API.logout();
                      Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
                    },
                    child: Text('Logout', style: TextStyle(color: Consts.LOGIN_TXT_COLOR)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
