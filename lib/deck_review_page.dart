import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/deck.dart';
import 'package:happen_link/apimodels/flashcard.dart';
import 'package:happen_link/apimodels/review.dart';
import 'package:happen_link/classes/sm.dart';
import 'package:happen_link/deck_review_done.dart';
import 'package:happen_link/services/api.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math';
import 'consts.dart' as Consts;
import 'deck_createedit_flashcard_page.dart';
import 'decks_page.dart';

class DeckReviewPage extends StatefulWidget {
  static const routeName = '/deckreviewpage';

  @override
  _DeckReviewPageState createState() => _DeckReviewPageState();
}

class _DeckReviewPageState extends State<DeckReviewPage> {
  Flashcard currentFlashcard;
  List<Flashcard> flashcards;
  Map<Flashcard, FlahscardReviewFactor> factors =
      new Map<Flashcard, FlahscardReviewFactor>();
  bool loading = true;
  bool loaded = false;
  bool frontView = true;
  Deck deck;
  Random rng = new Random();

  void _loadReviewList(BuildContext context) {
    API.of(context).fcGetReviewList(deck.id).then((review) {
      if (review.flashcards.length == 0) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            DeckReviewDone.routeName, ModalRoute.withName(DecksPage.routeName));
        return;
      }

      flashcards = review.flashcards;

      int i = 0;
      for (var item in flashcards) {
        factors[item] = review.factors[i++];

        for (var img in item.media.imagesFrontURL) {
          precacheImage(NetworkImage(img), context);
        }
        for (var img in item.media.imagesBackURL) {
          precacheImage(NetworkImage(img), context);
        }
      }

      loading = false; // for next
      _goToNextFlashcard(context);
    });
  }

  void _goToNextFlashcard(BuildContext context) {
    currentFlashcard = _getNextFlashcard();
    if (currentFlashcard == null) {
      setState(() {
        this.loading = true;
      });

      // go to ReviewDone page
      API
          .of(context)
          .fcCommitReview(new ReviewCommit(flashcards, factors.values.toList()))
          .then((value) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            DeckReviewDone.routeName, ModalRoute.withName(DecksPage.routeName));
      });
    } else {
      // show next flashcard
      setState(() {
        frontView = true;
      });
    }
  }

  Flashcard _getNextFlashcard() {
    if (factors.length == 0) return null;

    var filtered = factors.entries.toList();

    filtered = factors.entries.where((element) {
      var date = DateTime(element.value.dtLastReview.year,
          element.value.dtLastReview.month, element.value.dtLastReview.day);
      date = date.add(Duration(days: element.value.interval));
      return date.isBefore(DateTime.now()) || element.value.interval == 0;
    }).toList();

    if (filtered.length == 0) return null;

    for (var i = 0;; i++) {
      var newcard = filtered[rng.nextInt(filtered.length)].key;
      if (newcard == currentFlashcard && i < 10) continue;
      return newcard;
    }
  }

  void _reviewFlashcard(int quality) {
    assert(currentFlashcard != null);
    var review = factors[currentFlashcard];
    var result = SM.calc(
        quality, review.repetitions, review.interval, review.easeFactor);
    review.easeFactor = result.easeFactor;
    review.interval = result.interval;
    review.repetitions = result.repetitions;
    review.dtLastReview = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    if (!loaded) {
      loaded = true;
      deck = ModalRoute.of(context).settings.arguments as Deck;
      _loadReviewList(context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Loading
    if (loading) {
      return LoadingOverlay(
        isLoading: true,
        progressIndicator: Consts.LOADING_INDICATOR,
        child: Container(),
      );
    }

    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            _getMainView(),
            Positioned(
              top: -1,
              right: 4,
              child: ClipOval(
                child: Material(
                  child: InkWell(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: PopupMenuButton(
                        child: new Icon(Icons.arrow_drop_down),
                        onSelected: (choice) async {
                          if (choice == 'rmv') {
                            API
                                .of(context)
                                .fcDelete(currentFlashcard)
                                .then((value) {
                              flashcards.remove(currentFlashcard);
                              factors.remove(currentFlashcard);
                              _goToNextFlashcard(context);

                              final snackBar = SnackBar(
                                  content:
                                      Text('Flashcard removido com sucesso.'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            });
                          } else {
                            var res = await Navigator.of(context).pushNamed(
                                DeckCreateEditFlashcardPage.routeName,
                                arguments: currentFlashcard);
                            if (res != null) {
                              setState(() {
                                currentFlashcard = res;
                              });
                            }
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'rmv',
                              child: Text('Remover flashcard'),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Editar flashcard'),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getMainView() {
    // Frontview
    if (frontView) {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Visibility(
                      visible: currentFlashcard.front != null,
                      child: Text(
                        currentFlashcard.front,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  currentFlashcard.media.imagesFrontURL.length == 0
                      ? Container()
                      : Expanded(
                          child: _imagesCarousel(
                              currentFlashcard.media.imagesFrontURL)),
                ],
              ),
            ),
            Material(
              color: Color(0xff465a65),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(
                      child: Text(
                    'Mostrar resposta',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                onTap: () {
                  setState(() {
                    frontView = false;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    // Backview
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Visibility(
                      visible: currentFlashcard.back != null,
                      child: Text(
                        currentFlashcard.back,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  currentFlashcard.media.imagesBackURL.length == 0
                      ? Container()
                      : Expanded(
                          child: _imagesCarousel(
                              currentFlashcard.media.imagesBackURL)),
                  FutureBuilder(
                      future: _audioPlayer(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data;
                        }
                        return Container();
                      }),
                ],
              ),
            ),
          ),

          // 3 buttons
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Color(0xffd92121),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Column(
                        children: [
                          Text('< 1 min',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                          SizedBox(height: 2),
                          Text('NOVAMENTE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (currentFlashcard == null) return;
                      _reviewFlashcard(0);
                      _goToNextFlashcard(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Color(0xff35c672),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Column(
                        children: [
                          Text('< 10 min',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                          SizedBox(height: 2),
                          Text('BOM',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (currentFlashcard == null) return;
                      _reviewFlashcard(3);
                      _goToNextFlashcard(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Color(0xff9a88f3),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Column(
                        children: [
                          Text('4 d',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                          SizedBox(height: 2),
                          Text('F??CIL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (currentFlashcard == null) return;
                      _reviewFlashcard(5);
                      _goToNextFlashcard(context);
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _imagesCarousel(List<String> imgs) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(imgs[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
        );
      },
      itemCount: imgs.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
      backgroundDecoration: BoxDecoration(color: Colors.transparent),
    ));
  }

  /*Widget _imagesCarousel(List<String> imgs) {
    return SizedBox(
      child: CarouselSlider(
        items: imgs
            .map((e) => FadeInImage.assetNetwork(
                  placeholder: 'assets/busy.gif',
                  image: e,
                ))
            .toList(),
        options: CarouselOptions(
          height: 230,
          aspectRatio: 1,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }*/

  AudioPlayer _player;

  Future<Widget> _audioPlayer() async {
    if (currentFlashcard.media.audioBase64 != null) {
      _player = AudioPlayer();
      final dir = await getApplicationDocumentsDirectory();
      final path = dir.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.m4a';
      File(path)
          .writeAsBytes(base64.decode(currentFlashcard.media.audioBase64));
      await _player.setFilePath(path);

      // play control logic
      const double _controlSize = 56;
      Icon icon;
      Color color;

      if (_player.playerState.playing) {
        icon = Icon(Icons.pause, color: Colors.red, size: 30);
        color = Colors.red.withOpacity(0.1);
      } else {
        final theme = Theme.of(context);
        icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
        color = theme.primaryColor.withOpacity(0.1);
      }

      return ClipOval(
        child: Material(
          color: color,
          child: InkWell(
            child: SizedBox(
                width: _controlSize, height: _controlSize, child: icon),
            onTap: () {
              if (_player.playerState.playing) {
                _player.pause();
              } else {
                _player.play();
              }
            },
          ),
        ),
      );
    }
    return Container();
  }
}
