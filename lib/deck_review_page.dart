import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/deck.dart';
import 'package:happen_link/apimodels/flashcard.dart';
import 'package:happen_link/apimodels/review.dart';
import 'package:happen_link/classes/sm.dart';
import 'package:happen_link/deck_review_done.dart';
import 'package:happen_link/deck_show_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'dart:math';

class DeckReviewPage extends StatefulWidget {
  static const routeName = '/deckreviewpage';

  @override
  _DeckReviewPageState createState() => _DeckReviewPageState();
}

class _DeckReviewPageState extends State<DeckReviewPage> {
  Flashcard currentFlashcard;
  List<Flashcard> flashcards;
  Map<Flashcard, FlahscardReviewFactor> factors = new Map<Flashcard, FlahscardReviewFactor>();
  bool loading = true;
  bool frontView = true;
  Deck deck;
  Random rng = new Random();

  void loadReviewList(BuildContext context) {
    API.fcGetReviewList(deck.id).then((review) {
      if (review.flashcards.length == 0) {
        Navigator.of(context).pushNamedAndRemoveUntil(DeckReviewDone.routeName, (route) => false);
      }

      flashcards = review.flashcards;

      int i = 0;
      for (var item in flashcards) {
        factors[item] = review.factors[i++];

        for (var img in item.media.imagesBackURL) {
          precacheImage(NetworkImage(img), context);
        }
        for (var img in item.media.imagesBackURL) {
          precacheImage(NetworkImage(img), context);
        }
      }

      loading = false; // for next
      goToNextFlashcard(context);
    });
  }

  void goToNextFlashcard(BuildContext context) {
    currentFlashcard = getNextFlashcard();
    if (currentFlashcard == null) {
      // go to ReviewDone page
      API.fcCommitReview(new ReviewCommit(flashcards, factors.values.toList())).then((value) {
        Navigator.of(context).pushNamedAndRemoveUntil(DeckReviewDone.routeName, (route) => route is DeckShowPage);
      });
    } else {
      // show next flashcard
      setState(() {
        frontView = true;
      });
    }
  }

  Flashcard getNextFlashcard() {
    if (factors.length == 0) return null;

    var filtered = factors.entries.where((element) {
      var date =
          DateTime(element.value.dtLastReview.year, element.value.dtLastReview.month, element.value.dtLastReview.day);
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

  void reviewFlashcard(int quality) {
    var review = factors[currentFlashcard];
    var result = SM.calc(quality, review.repetitions, review.interval, review.easeFactor);
    review.easeFactor = result.easeFactor;
    review.interval = result.interval;
    review.repetitions = result.repetitions;
    review.dtLastReview = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    deck = ModalRoute.of(context).settings.arguments as Deck;

    // Loading
    if (loading) {
      loadReviewList(context);

      return LoadingOverlay(
        isLoading: true,
        child: Container(),
      );
    }

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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(currentFlashcard.front),
                  ),
                  currentFlashcard.media.imagesFrontURL.length == 0
                      ? Container()
                      : _imagesCarousel(currentFlashcard.media.imagesFrontURL),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(currentFlashcard.back),
                  ),
                  currentFlashcard.media.imagesBackURL.length == 0
                      ? Container()
                      : _imagesCarousel(currentFlashcard.media.imagesBackURL),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [Text('< 1 min'), Text('NOVAMENTE')],
                      ),
                    ),
                    onTap: () {
                      reviewFlashcard(0);
                      goToNextFlashcard(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Color(0xff35c672),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [Text('< 10 min'), Text('BOM')],
                      ),
                    ),
                    onTap: () {
                      reviewFlashcard(3);
                      goToNextFlashcard(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Color(0xff9a88f3),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [Text('4 d'), Text('FÁCIL')],
                      ),
                    ),
                    onTap: () {
                      reviewFlashcard(5);
                      goToNextFlashcard(context);
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
    return CarouselSlider(
      items: imgs.map((e) => Image.network(e)).toList(),
      options: CarouselOptions(),
    );
  }
}
