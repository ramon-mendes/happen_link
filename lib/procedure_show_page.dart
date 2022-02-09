import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:happen_link/apimodels/procedure.dart';
import 'package:happen_link/apimodels/procedureitem.dart';
import 'package:happen_link/procedure_flashcard.dart';
import 'package:happen_link/services/api.dart';
import 'package:happen_link/widgets/color_loader_4.dart';

class ProcedureShowPage extends StatefulWidget {
  static const routeName = '/procedureshowpage';

  @override
  _ProcedureShowPageState createState() => _ProcedureShowPageState();
}

class _ProcedureShowPageState extends State<ProcedureShowPage> {
  Procedure _procedure;
  List<ProcedureItem> _data;
  List<Widget> _views = <Widget>[];
  int _idx = 0;
  PageController _ctrl = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    _procedure = ModalRoute.of(context).settings.arguments as Procedure;

    if (_data == null) {
      API.of(context).procedureListItens(_procedure.id).then((value) {
        setState(() {
          _data = value;
          for (var item in _data) {
            _views.add(_getItemView(item));
          }
        });
      });

      return Scaffold(
        body: Center(
          child: ColorLoader4(),
        ),
      );
    }

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
        color: Colors.white,
        child: PageView(
          controller: _ctrl,
          children: _views,
          //physics: AlwaysScrollableScrollPhysics(),
          onPageChanged: (value) {
            _idx = value;
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _getItemView(ProcedureItem item) {
    // Step
    if (item.type == 0) {
      var html = '''
<style>
body {
	margin: 20px 10px;
	font-family: sans-serif;
  font-size: 16px;
}

img {
	max-width: 100%;
	height: auto;
}

#title {
	text-align: center;
	font-size: 20px;
	font-weight: bold;
	margin-bottom: 20px;
}
ol, ul {
  padding-left: 0;
}</style>
<div id="title">${item.step.title}</div>
${item.step.html}
''';

      return Html(data: html);
    }

    // Flashcard
    else {
      return ProcedureFlashcard(item.flashcard);
    }
  }

  void _goNextSlide() {
    _idx++;
    _ctrl.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    setState(() {});
  }

  void _goPrevSlide() {
    _idx--;
    _ctrl.previousPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    setState(() {});
  }
}
