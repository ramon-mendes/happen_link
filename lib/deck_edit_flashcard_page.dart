import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'apimodels/flashcard.dart';

class DeckEditFlashcardPage extends StatefulWidget {
  static const routeName = '/deckeditflashcard';

  @override
  _DeckEditFlashcardPageState createState() => _DeckEditFlashcardPageState();
}

class _DeckEditFlashcardPageState extends State<DeckEditFlashcardPage> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final flashcard = ModalRoute.of(context).settings.arguments as Flashcard;

    return LoadingOverlay(
      isLoading: _saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adicionar flashcard'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(),
        ),
      ),
    );
  }
}
