import 'package:flutter/material.dart';
import 'package:happen_link/decks_page.dart';
import 'package:happen_link/procedure_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: UnconstrainedBox(
                  child: Container(
                    width: 280,
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                    ),
                  ),
                ),
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
                    height: 115,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deck',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Flashcards para você revisar seu conhecimento'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                    height: 115,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Procedimentos',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Instruções passo-a-passo de tarefas conhecidas'),
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
                  Text('v12'),
                  GestureDetector(
                    onTap: () {},
                    child: Text('Logout'),
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
