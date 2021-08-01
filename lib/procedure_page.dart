import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/procedure.dart';
import 'package:happen_link/color_loader_4.dart';
import 'package:happen_link/procedure_show_page.dart';
import 'package:happen_link/services/api.dart';

class ProcedurePage extends StatefulWidget {
  static const routeName = '/procedurespage';

  @override
  _ProcedurePageState createState() => _ProcedurePageState();
}

class _ProcedurePageState extends State<ProcedurePage> {
  static List<Procedure> _cache;

  @override
  void initState() {
    super.initState();
    reloadData();
  }

  void reloadData() {
    print('reloadData');

    API.of(context).procedureList().then((value) => this.setState(() {
          _cache = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedimentos'),
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
            child: Text('Selecione um procedimento para visualizá-lo:'),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                ),
                itemCount: _cache.length,
                itemBuilder: (BuildContext context, int index) => _buildListItem(_cache[index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(Procedure procedure, BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).pushNamed(ProcedureShowPage.routeName, arguments: procedure);
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${procedure.title}'),
              Text(
                '${procedure.stepCnt} etapas',
                style: TextStyle(color: Color(0xff3c2dc4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
