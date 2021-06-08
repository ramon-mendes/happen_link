import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/flashcard.dart';
import 'package:happen_link/services/api.dart';
import 'package:lottie/lottie.dart';

class ProcedureFlashcard extends StatefulWidget {
  final Flashcard fc;

  ProcedureFlashcard(this.fc);

  @override
  _ProcedureFlashcardState createState() => _ProcedureFlashcardState();
}

class _ProcedureFlashcardState extends State<ProcedureFlashcard> {
  bool frontView = true;
  bool addedView = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    for (var img in widget.fc.media.imagesFrontURL) {
      precacheImage(NetworkImage(img), context);
    }
    for (var img in widget.fc.media.imagesBackURL) {
      precacheImage(NetworkImage(img), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Done view
    if (addedView) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
              child: Lottie.asset('assets/success_confetti_lottie.json'),
            ),
            Text('Flashcard adicionado ao deck Procedimentos!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

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
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                    textAlign: TextAlign.center,
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
            onTap: () async {
              var res = await API.of(context).procedureImportFlashcard(widget.fc.id);
              if (!res) {
                final snackBar = SnackBar(
                    content: Text('Este flashcard já está no seu deck de Procedimentos.'), backgroundColor: Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }
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
      items: imgs
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(e),
              ))
          .toList(),
      options: CarouselOptions(
        enableInfiniteScroll: false,
      ),
    );
  }
}
