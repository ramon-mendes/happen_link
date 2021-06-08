import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/flashcard.dart';
import 'package:happen_link/widgets/audio_player.dart';
import 'package:happen_link/widgets/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class DeckAudioEditPage extends StatefulWidget {
  static const routeName = '/deckaudioeditpage';

  @override
  _DeckAudioEditPageState createState() => _DeckAudioEditPageState();
}

class _DeckAudioEditPageState extends State<DeckAudioEditPage> {
  bool showPlayer = false;
  String path;
  Flashcard _flashcard;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _flashcard = ModalRoute.of(context).settings.arguments as Flashcard;

    if (_flashcard.media.audioBase64 != null) {
      showPlayer = true;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gravação/reprodução'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Adicionar flashcard',
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: getPath(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (showPlayer) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: AudioPlayer(
                    path: snapshot.data,
                    onDelete: () {
                      setState(() => showPlayer = false);
                      _flashcard.media.audioBase64 = null;
                    },
                  ),
                );
              } else {
                return AudioRecorder(
                  path: snapshot.data,
                  onStop: () async {
                    setState(() => showPlayer = true);
                    var file = File(path);
                    _flashcard.media.audioBase64 = base64.encode(await file.readAsBytes());
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<String> getPath() async {
    if (path == null) {
      final dir = await getApplicationDocumentsDirectory();
      path = dir.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.m4a';

      if (_flashcard.media.audioBase64 != null) {
        await File(path).writeAsBytes(base64.decode(_flashcard.media.audioBase64));
      }
    }
    return path;
  }
}
