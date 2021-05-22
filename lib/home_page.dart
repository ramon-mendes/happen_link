import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
                  onTap: () {/* ... */},
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
                  onTap: () {/* ... */},
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Procedimentos'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('asdf'),
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
