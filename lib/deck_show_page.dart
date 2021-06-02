import 'package:flutter/material.dart';
import 'package:happen_link/deck_review_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'apimodels/deck.dart';
import 'consts.dart' as Consts;

class DeckShowPage extends StatefulWidget {
  static const routeName = '/deckshowpage';

  @override
  _DeckShowPageState createState() => _DeckShowPageState();
}

class _DeckShowPageState extends State<DeckShowPage> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final deck = ModalRoute.of(context).settings.arguments as Deck;

    return LoadingOverlay(
      isLoading: _saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(deck.title),
          actions: [
            PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == '1') {
                    setState(() {
                      this._saving = true;
                    });

                    API.deckRemove(deck.id).then((value) {
                      final snackBar = SnackBar(content: Text('Deck removido com sucesso.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();

                      setState(() {
                        this._saving = false;
                      });
                    });
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: '1',
                        child: Text('Remover deck'),
                      ),
                    ]),
          ],
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
      ),
    );
  }
}
