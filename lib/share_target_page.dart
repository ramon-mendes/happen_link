import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/flashcard.dart';
import 'package:happen_link/services/api.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'apimodels/deck.dart';
import 'color_loader_4.dart';

class ShareTargetPage extends StatefulWidget {
  static const routeName = '/sharetargetpage';

  @override
  _ShareTargetPageState createState() => _ShareTargetPageState();
}

class _ShareTargetPageState extends State<ShareTargetPage> {
  List<Deck> _decks;
  bool _saving = true;
  bool _imgside = true;
  String _deckid;
  final TextEditingController _txtFront = TextEditingController();
  final TextEditingController _txtBack = TextEditingController();

  @override
  void initState() {
    super.initState();

    API.of(context).deckList().then((value) => this.setState(() {
          _decks = value.where((element) => element.fromUser).toList();
          _deckid = _decks.first.id;
          _saving = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (_decks == null) {
      return Scaffold(
        body: Center(
          child: ColorLoader4(),
        ),
      );
    }

    final args =
        ModalRoute.of(context).settings.arguments as List<SharedMediaFile>;
    final imgpath = args[0].path;

    return LoadingOverlay(
      isLoading: _saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Criar novo Flashcard'),
        ),
        body: Container(
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              Text('Imagem:'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        RadioListTile<bool>(
                          title: const Text('Frente'),
                          groupValue: _imgside,
                          value: true,
                          onChanged: (bool value) {
                            setState(() {
                              _imgside = value;
                            });
                          },
                        ),
                        RadioListTile<bool>(
                          title: const Text('Trás'),
                          groupValue: _imgside,
                          value: false,
                          onChanged: (bool value) {
                            setState(() {
                              _imgside = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Image.file(
                    File(imgpath),
                    height: 200,
                  ),
                ],
              ),

              Text('Texto frente:'),
              SizedBox(height: 5),
              TextFormField(
                controller: _txtFront,
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 5, // when user presses enter it will adapt to it
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
              ),
              //
              SizedBox(height: 15),
              //
              Text('Texto trás:'),
              SizedBox(height: 5),
              TextFormField(
                controller: _txtBack,
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 5, // when user presses enter it will adapt to it
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
              ),
              //
              SizedBox(height: 15),
              //
              Text("Deck:"),
              DropdownButton<String>(
                value: _deckid,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String newValue) {
                  setState(() {
                    _deckid = newValue;
                  });
                },
                items: _decks.map<DropdownMenuItem<String>>((Deck deck) {
                  return DropdownMenuItem<String>(
                    value: deck.id,
                    child: Text(deck.title),
                  );
                }).toList(),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveModel(imgpath);
                  },
                  child: Text('Criar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveModel(String imgpath) async {
    var media = FlashcardMedia();
    media.imagesBackURL = <String>[];
    media.imagesFrontURL = <String>[];
    if (_imgside)
      media.imagesFrontURL.add(_file2base64(imgpath));
    else
      media.imagesBackURL.add(_file2base64(imgpath));

    setState(() {
      _saving = true;
    });

    await API.of(context).fcCreate(
        Flashcard(null, _deckid, _txtFront.text, _txtBack.text, media));

    final snackBar = SnackBar(content: Text('Flashcard criado com sucesso.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pop();
  }

  String _file2base64(String path) {
    var bytes = File(path).readAsBytesSync();
    return "data:image/jpeg;base64," + base64Encode(bytes);
  }
}
