import 'package:flutter/material.dart';
import 'package:happen_link/deck_add_page.dart';
import 'package:happen_link/deck_show_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:happen_link/color_loader_4.dart';

import 'apimodels/deck.dart';

class DecksPage extends StatefulWidget {
  static const routeName = '/deckspage';

  @override
  _DecksPageState createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage> {
  static List<Deck> _cache;

  @override
  void initState() {
    super.initState();
    reloadData();
  }

  void reloadData() {
    API.deckList().then((value) => this.setState(() {
          _cache = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar deck',
            onPressed: () async {
              await Navigator.of(context).pushNamed(DeckAddPage.routeName);
              reloadData();
            },
          ),
        ],
      ),
      body: Container(
        child: _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    if (_cache == null) {
      return Center(
        child: new ColorLoader4(),
      );
    }

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1,
      ),
      itemCount: _cache.length,
      itemBuilder: (BuildContext context, int index) => _buildListItem(_cache[index], context),
    );
  }

  Widget _buildListItem(Deck deck, BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).pushNamed(DeckShowPage.routeName, arguments: deck);
        reloadData();
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(deck.title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Cartas novas: ',
                          style: TextStyle(color: Color(0xff7E7E7E)),
                        ),
                        Text(
                          '${deck.cntNew}',
                          style: TextStyle(color: Color(0xff3c2dc4)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Cartas antigas: ',
                          style: TextStyle(color: Color(0xff7E7E7E)),
                        ),
                        Text(
                          '${deck.cntOld}',
                          style: TextStyle(color: Color(0xffc42d2d)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
