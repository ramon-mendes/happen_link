import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/procedure.dart';
import 'package:happen_link/apimodels/procedureitem.dart';
import 'package:happen_link/color_loader_4.dart';
import 'package:happen_link/procedure_flashcard.dart';
import 'package:happen_link/services/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProcedureShowPage extends StatefulWidget {
  static const routeName = '/procedureshowpage';

  @override
  _ProcedureShowPageState createState() => _ProcedureShowPageState();
}

class _ProcedureShowPageState extends State<ProcedureShowPage> {
  WebViewController _wvcontroller;
  CarouselController _crcontroller = CarouselController();
  Procedure _procedure;
  CarouselSlider _carousel;
  List<ProcedureItem> _data;
  int _idx = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _procedure = ModalRoute.of(context).settings.arguments as Procedure;

    if (_data == null) {
      API.procedureListItens(_procedure.id).then((value) {
        setState(() {
          _data = value;
        });
      });

      return Scaffold(
        body: Center(
          child: ColorLoader4(),
        ),
      );
    }

    _carousel = CarouselSlider(
      items: _data.map((item) => _getItemView(item)).toList(),
      options: CarouselOptions(
        autoPlay: false,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        height: double.infinity,
        onPageChanged: (idx, c) => _updateButtons(idx),
      ),
      carouselController: _crcontroller,
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _idx != 0 && _data.length > 1
                ? () {
                    _goPrevSlide();
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _idx != _data.length - 1 && _data.length > 1
                ? () {
                    _goNextSlide();
                  }
                : null,
          ),
        ],
      ),
      body: Container(
        color: Colors.green,
        child: _carousel,
      ),
    );
  }

  Widget _getItemView(ProcedureItem item) {
    // Step
    if (item.type == 0) {
      var html = '''<html>
</html>''';

      return WebView(
          initialUrl: '',
          //javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _wvcontroller = webViewController;
            _wvcontroller.loadUrl(Uri.dataFromString(
              html,
              mimeType: 'text/html',
            ).toString());
          });
    }
    // Flashcard
    else {
      return ProcedureFlashcard(item.flashcard);
    }
  }

  void _goNextSlide() {
    _crcontroller.nextPage();
  }

  void _goPrevSlide() {
    _crcontroller.previousPage();
  }

  void _updateButtons(int idx) {
    setState(() {
      _idx = idx;
    });
  }
}
