import 'package:flutter/material.dart';
import 'package:happen_link/decks_page.dart';
import 'package:happen_link/procedure_page.dart';
import 'package:package_info/package_info.dart';

import 'consts.dart' as Consts;

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
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      setState(() {
        _versionCode = 'v$buildNumber';
      });
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
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                    ),
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
                            'Deck',
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
              Expanded(
                child: Text(''),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_versionCode, style: TextStyle(color: Consts.LOGIN_TXT_COLOR)),
                  GestureDetector(
                    onTap: () {},
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
