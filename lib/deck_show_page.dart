import 'package:flutter/material.dart';
import 'package:happen_link/deck_review_page.dart';
import 'apimodels/deck.dart';
import 'consts.dart' as Consts;

class DeckShowPage extends StatefulWidget {
  static const routeName = '/deckshowpage';

  @override
  _DeckShowPageState createState() => _DeckShowPageState();
}

class _DeckShowPageState extends State<DeckShowPage> {
  @override
  Widget build(BuildContext context) {
    final deck = ModalRoute.of(context).settings.arguments as Deck;

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.title),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(DeckReviewPage.routeName, arguments: deck);
            },
            child: Text('Iniciar revisão'),
          ),
        ),
      ),
    );
  }
}
