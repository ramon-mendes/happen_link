import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/gpslink.dart';
import 'package:happen_link/gpslink_edit_page.dart';
import 'package:happen_link/gpslink_show_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:happen_link/widgets/color_loader_4.dart';

class GPSLinkPage extends StatefulWidget {
  static const routeName = '/gpslinkpage';

  @override
  _GPSLinkPageState createState() => _GPSLinkPageState();
}

class _GPSLinkPageState extends State<GPSLinkPage> {
  static List<GPSLink> _cache;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() {
    print('reloadData');

    API.of(context).gpslinkList().then((value) => this.setState(() {
          _cache = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Link'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar GPS Link',
            onPressed: () async {
              await Navigator.of(context).pushNamed(GPSLinkEditPage.routeName);
              _reloadData();
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

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            child: Text('Selecione um item para visualizá-lo:'),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                ),
                itemCount: _cache.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildListItem(_cache[index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(GPSLink gpsLink, BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () async {
          await Navigator.of(context)
              .pushNamed(GPSLinkShowPage.routeName, arguments: gpsLink);
          _reloadData();
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(gpsLink.name),
        ),
      ),
    );
  }
}
