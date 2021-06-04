import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/flashcard.dart';

class ProcedureFlashcard extends StatefulWidget {
  Flashcard fc;

  ProcedureFlashcard(this.fc);

  @override
  _ProcedureFlashcardState createState() => _ProcedureFlashcardState();
}

class _ProcedureFlashcardState extends State<ProcedureFlashcard> {
  bool frontView = true;
  bool addedView = false;

  @override
  Widget build(BuildContext context) {
    // Done view
    if (addedView) {}

    // Frontview
    if (frontView) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.fc.front ?? ''),
                ),
                widget.fc.media.imagesFrontURL.length == 0
                    ? Container()
                    : _imagesCarousel(widget.fc.media.imagesFrontURL),
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
      );
    }

    // Backview
    return Column(
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
                  child: Text(
                    widget.fc.back,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                widget.fc.media.imagesBackURL.length == 0
                    ? Container()
                    : _imagesCarousel(widget.fc.media.imagesBackURL),
              ],
            ),
          ),
        ),

        // add to deck button
        Material(
          color: Color(0xffa13232),
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                  child: Text(
                'Adicionar ao meu deck',
                style: TextStyle(color: Colors.white),
              )),
            ),
            onTap: () {
              setState(() {
                addedView = true;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _imagesCarousel(List<String> imgs) {
    return CarouselSlider(
      items: imgs.map((e) => Image.network(e)).toList(),
      options: CarouselOptions(),
    );
  }
}
