import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:happen_link/deck_audio_edit_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'apimodels/flashcard.dart';

class DeckCreateEditFlashcardPage extends StatefulWidget {
  static const routeName = '/deckcreateeditflashcard';

  @override
  _DeckCreateEditFlashcardPageState createState() =>
      _DeckCreateEditFlashcardPageState();
}

class _DeckCreateEditFlashcardPageState
    extends State<DeckCreateEditFlashcardPage> {
  bool _saving = false;
  bool _isedit = false;
  Flashcard _flashcard;
  final TextEditingController _txtFront = TextEditingController();
  final TextEditingController _txtBack = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _flashcard = ModalRoute.of(context).settings.arguments as Flashcard;
    if (_flashcard.id != null) {
      _isedit = true;
      _txtFront.text = _flashcard.front;
      _txtBack.text = _flashcard.back;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _txtFront.dispose();
    _txtBack.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adicionar flashcard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Adicionar flashcard',
              onPressed: () async {
                await _saveModel(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text('Texto tr??s:'),
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
                Text('Imagens frente:'),
                SizedBox(height: 5),
                GridView.count(
                  primary: false, // disables GridView scrolling
                  shrinkWrap: true,
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: _getGridImages(true),
                ),
                //
                SizedBox(height: 15),
                //
                Text('Imagens tr??s:'),
                SizedBox(height: 5),
                GridView.count(
                  primary: false, // disables GridView scrolling
                  shrinkWrap: true,
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: _getGridImages(false),
                ),
                //
                SizedBox(height: 15),
                //
                Text('??udio:'),
                SizedBox(height: 5),
                ElevatedButton(
                  child: Text('Grava????o/reprodu????o'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(DeckAudioEditPage.routeName,
                        arguments: _flashcard);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveModel(BuildContext context) async {
    setState(() {
      _saving = true;
    });

    _flashcard.front = _txtFront.text;
    _flashcard.back = _txtBack.text;
    if (_isedit) {
      await API.of(context).fcUpdate(_flashcard);
    } else {
      await API.of(context).fcCreate(_flashcard);
    }

    final snackBar = SnackBar(
        content: Text(_isedit
            ? 'Flashcard salvo com sucesso.'
            : 'Flashcard criado com sucesso.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).pop(_flashcard);
  }

  List<Widget> _getGridImages(bool front) {
    List<Widget> widgets = <Widget>[];

    var imgs = front
        ? this._flashcard.media.imagesFrontURL
        : this._flashcard.media.imagesBackURL;
    widgets.addAll(imgs.map((url) => _GridImage(
          url: url,
        )));

    widgets.add(Material(
      color: Color(0xff6fb6f8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: InkWell(
        onTap: () => _showPicker(context, front),
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
    ));

    return widgets;
  }

  final picker = ImagePicker();

  Future<String> _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile == null) return null;
    return _file2base64(File(pickedFile.path));
  }

  Future<String> _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile == null) return null;
    return _file2base64(File(pickedFile.path));
  }

  String _file2base64(File file) {
    var bytes = file.readAsBytesSync();
    return "data:image/jpeg;base64," + base64Encode(bytes);
  }

  void _showPicker(BuildContext context, bool front) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Galeria'),
                    onTap: () async {
                      var base64 = await _imgFromGallery();
                      if (base64 == null) return;

                      setState(() {
                        if (front)
                          _flashcard.media.imagesFrontURL.add(base64);
                        else
                          _flashcard.media.imagesBackURL.add(base64);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('C??mera'),
                    onTap: () async {
                      var base64 = await _imgFromCamera();
                      if (base64 == null) return;

                      setState(() {
                        if (front)
                          _flashcard.media.imagesFrontURL.add(base64);
                        else
                          _flashcard.media.imagesBackURL.add(base64);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class _GridImage extends StatelessWidget {
  const _GridImage({this.url, Key key}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    bool isbase64 = url.startsWith("data:");
    Uint8List bytes;

    if (isbase64) {
      var data = url.split(',')[1];
      bytes = base64Decode(data);
    }

    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: isbase64
          ? Image.memory(
              bytes,
              fit: BoxFit.fill,
            )
          : Image.network(
              this.url,
              fit: BoxFit.fill,
            ),
    );

    return image;
  }
}
