import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/flashcard.dart';
import 'package:happen_link/deck_createedit_flashcard_page.dart';
import 'package:happen_link/deck_review_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'apimodels/deck.dart';

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
                    // rmv deck
                    // set up the buttons
                    Widget cancelButton = TextButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                    Widget continueButton = TextButton(
                      child: Text("Continuar"),
                      onPressed: () {
                        Navigator.of(context).pop();

                        setState(() {
                          this._saving = true;
                        });

                        API.of(context).deckRemove(deck.id).then((value) {
                          final snackBar = SnackBar(content: Text('Deck removido com sucesso.'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pop();

                          setState(() {
                            this._saving = false;
                          });
                        });
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      content: Text("Deseja realmente remover este deck?"),
                      actions: [
                        cancelButton,
                        continueButton,
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => alert,
                    );
                  }

                  if (val == '2') {
                    // reset deck
                    // set up the buttons
                    Widget cancelButton = TextButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                    Widget continueButton = TextButton(
                      child: Text("Continuar"),
                      onPressed: () async {
                        await API.of(context).deckReset(deck.id);
                        final snackBar = SnackBar(content: Text('Revis??es limpadas com sucesso.'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        Navigator.of(context).pop();
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      content: Text("Deseja realmente remover todas as revis??es realizadas?"),
                      actions: [
                        cancelButton,
                        continueButton,
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => alert,
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      deck.fromUser
                          ? const PopupMenuItem<String>(
                              value: '1',
                              child: Text('Remover deck'),
                            )
                          : null,
                      const PopupMenuItem<String>(
                        value: '2',
                        child: Text('Limpar revis??es dos flashcards'),
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
              child: Text('Iniciar revis??o'),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (deck.fromUser) {
              Navigator.of(context)
                  .pushNamed(DeckCreateEditFlashcardPage.routeName, arguments: Flashcard.fromDeckId(deck.id));
            } else {
              // Create button
              Widget okButton = TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );

              // Create AlertDialog
              AlertDialog alert = AlertDialog(
                content: Text("Esse ?? um deck compartilhado. Voc?? n??o pode adicionar flashcards a ele."),
                actions: [
                  okButton,
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
