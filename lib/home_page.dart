import 'package:flutter/material.dart';
import 'package:happen_link/decks_page.dart';
import 'package:happen_link/procedures_page.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Ink.image(
                image: const AssetImage('assets/crane_card.png'),
                fit: BoxFit.cover,
                width: 300.0,
                height: 200.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(DecksPage.routeName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Decks',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
              height: 20,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Ink.image(
                image: const AssetImage('assets/rally_card.png'),
                fit: BoxFit.cover,
                width: 300.0,
                height: 200.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProceduresPage.routeName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Procedimentos',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
          ],
        ),
      ),
    );
  }
}
