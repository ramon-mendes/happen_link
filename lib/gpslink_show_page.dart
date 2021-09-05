import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/gpslink.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:happen_link/gpslink_edit_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:loading_overlay/loading_overlay.dart';

class GPSLinkShowPage extends StatefulWidget {
  static const routeName = '/gpslinkshowpage';

  @override
  _GPSLinkShowPageState createState() => _GPSLinkShowPageState();
}

class _GPSLinkShowPageState extends State<GPSLinkShowPage> {
  Set<Marker> markers = Set<Marker>();
  GPSLink _gpslink;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gpslink = ModalRoute.of(context).settings.arguments as GPSLink;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_gpslink.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.restore_from_trash),
              tooltip: 'Remover GPSLink',
              onPressed: () async {
                // set up the buttons
                Widget cancelButton = TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                Widget continueButton = TextButton(
                  child: Text("Continuar"),
                  onPressed: () {
                    Navigator.of(context).pop();

                    setState(() {
                      this._saving = true;
                    });

                    API.of(context).gpslinkRemove(_gpslink.id).then((value) {
                      final snackBar = SnackBar(content: Text('GPS Link removido com sucesso.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();

                      setState(() {
                        this._saving = false;
                      });
                    });
                  },
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  content: Text("Deseja realmente remover este GPS Link?"),
                  actions: [
                    cancelButton,
                    continueButton,
                  ],
                );

                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) => alert,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Adicionar GPSLink',
              onPressed: () async {
                var gps = await Navigator.of(context).pushNamed(GPSLinkEditPage.routeName, arguments: _gpslink);
                if (gps != null) {
                  _gpslink = gps;

                  setState(() {
                    final Marker marker = Marker(
                      markerId: MarkerId("123456"),
                      position: LatLng(_gpslink.lat, _gpslink.lng),
                    );
                    markers.clear();
                    markers.add(marker);
                  });
                }
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lembrete:'),
              Card(
                child: ListTile(
                  title: Text(_gpslink.remember),
                ),
              ),
              SizedBox(height: 15),
              Text('Localização:'),
              SizedBox(height: 5),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(_gpslink.lat, _gpslink.lng), zoom: 18),
                  onMapCreated: (GoogleMapController controller) {
                    final Marker marker = Marker(
                      markerId: MarkerId("123456"),
                      position: LatLng(_gpslink.lat, _gpslink.lng),
                    );
                    setState(() {
                      markers.add(marker);
                    });
                  },
                  markers: markers,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
