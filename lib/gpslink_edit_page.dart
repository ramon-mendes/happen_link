import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/gpslink.dart';
import 'package:happen_link/services/api.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GPSLinkEditPage extends StatefulWidget {
  static const routeName = '/gpslinkeditpage';

  @override
  _GPSLinkEditPageState createState() => _GPSLinkEditPageState();
}

class _GPSLinkEditPageState extends State<GPSLinkEditPage> {
  bool _saving = false;
  bool _isedit = false;
  GPSLink _gpsLink;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtRemember = TextEditingController();
  Set<Marker> _markers = Set<Marker>();
  LatLng _mapLoc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _gpsLink = ModalRoute.of(context).settings.arguments as GPSLink;
    _isedit = _gpsLink != null;

    if (_isedit) {
      _txtName.text = _gpsLink.name;
      _txtRemember.text = _gpsLink.remember;

      _mapLoc = LatLng(_gpsLink.lat, _gpsLink.lng);
      _markers = Set<Marker>();
      _markers.add(
        Marker(
          markerId: MarkerId(_mapLoc.toString()),
          position: _mapLoc,
        ),
      );
    } else {
      _gpsLink = GPSLink(radius: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isedit ? 'Editar GPS Link' : 'Adicionar GPS Link'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                if (_markers.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Clique no mapa para definir um marcador com a região a ser monitorada.'),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                if (_formKey.currentState.validate()) {
                  await _saveModel(context);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome:'),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _txtName,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira o nome';
                      }
                      return null;
                    },
                  ),
                  //
                  SizedBox(height: 15),
                  //
                  Text('Lembrete:'),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _txtRemember,
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 5, // when user presses enter it will adapt to it
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira o lembrete';
                      }
                      return null;
                    },
                  ),
                  //
                  SizedBox(height: 15),
                  //
                  Text('Localização:'),
                  //
                  SizedBox(height: 5),
                  (_mapLoc == null
                      ? FutureBuilder(
                          future: _getLocation(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              _mapLoc = LatLng(snapshot.data.latitude, snapshot.data.longitude);
                              return _buildMap(_mapLoc);
                            }
                            return CircularProgressIndicator();
                          },
                        )
                      : _buildMap(_mapLoc)),
                  //
                  SizedBox(height: 5),
                  Text('Pressione no mapa para definir a localização', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMap(LatLng loc) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: loc,
          zoom: 18,
        ),
        onTap: _handleTap,
        markers: _markers,
        onCameraMove: (position) => _mapLoc = position.target,
      ),
    );
  }

  _handleTap(LatLng loc) {
    setState(() {
      _markers = Set<Marker>();
      _markers.add(
        Marker(
          markerId: MarkerId(loc.toString()),
          position: loc,
        ),
      );
    });
  }

  Future<LocationData> _getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  _saveModel(BuildContext context) async {
    setState(() {
      _saving = true;
    });

    _gpsLink.lat = _markers.first.position.latitude;
    _gpsLink.lng = _markers.first.position.longitude;
    _gpsLink.name = _txtName.text;
    _gpsLink.remember = _txtRemember.text;

    if (_isedit)
      await API.of(context).gpslinkEdit(_gpsLink);
    else
      await API.of(context).gpslinkCreate(_gpsLink);

    final snackBar = SnackBar(content: Text('GPS Link salvo com sucesso.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).pop<GPSLink>(_gpsLink);
  }
}
