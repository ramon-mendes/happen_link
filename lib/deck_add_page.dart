import 'package:flutter/material.dart';
import 'package:happen_link/services/api.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'consts.dart' as Consts;

class DeckAddPage extends StatefulWidget {
  static const routeName = '/deckaddpage';

  @override
  _DeckAddPageState createState() => _DeckAddPageState();
}

class _DeckAddPageState extends State<DeckAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _txtFieldCtrl = TextEditingController();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar deck'),
      ),
      body: LoadingOverlay(
        isLoading: _saving,
        color: Consts.LOADING_OVERLAY_COLOR,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Título:'),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor insira o título';
                    }
                    return null;
                  },
                  controller: _txtFieldCtrl,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        API.deckCreate(_txtFieldCtrl.text).then((value) {
                          final snackBar = SnackBar(content: Text('Deck criado com sucesso.'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Text('Criar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
