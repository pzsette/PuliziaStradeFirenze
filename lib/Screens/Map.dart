import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pulizia_strade/Alerts/SnackbarBuilder.dart';
import 'package:pulizia_strade/CustomWidgets/InfoBottomSheet.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Utils/LoacalizationUtils.dart';
import 'package:pulizia_strade/Utils/utils.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

enum DONE { YES, NO }

class _MapScreenState extends State<MapScreen> {
  bool _isButtonTapped = false;
  bool mapToggle = false;
  GoogleMapController mapController;
  var currentLocation;
  bool fabShown = false;

  final DioNetwork dio = new DioNetwork();

  @override
  void initState() {
    super.initState();
    Location().getLocation().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        fabShown = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          mapToggle
              ? GoogleMap(
                  mapType: MapType.normal,
                  //markers: parkProvider.markers,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentLocation.latitude, currentLocation.longitude),
                    zoom: 17,
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
      floatingActionButton: fabShown
          ? FloatingActionButton(
              backgroundColor: Colors.blue[400],
              onPressed: () async {
                if (!_isButtonTapped) {
                  _isButtonTapped = true;
                  PositionInMap positionInMap;
                  List<double> coordinates = await getCoordinates();
                  try {
                    positionInMap =
                        await getPosition(coordinates[0], coordinates[1]);
                  } on Exception catch (e) {
                    print(e.toString());
                    setState(() {
                      fabShown = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackbarBuilder.build(
                            "Impossibile caricare informazioni posizione",
                            Colors.grey));
                    positionInMap = null;
                    setState(() {
                      fabShown = true;
                    });
                  }
                  await _prepareForBottomSheet(positionInMap, coordinates);
                  _isButtonTapped = false;
                }
              },
              tooltip: 'Get Info',
              child: Icon(Icons.pin_drop_sharp))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _showModalBottomSheet(context, PositionInMap position, double latitude,
      double longitude, String tract) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          position.addSection(tract);
          return new InfoBottomSheet(position, latitude, longitude);
        });
  }

  _askUser(context, List<String> tracts) async {
    String tractSelected = '';
    switch (await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: new Text('Seleziona il tratto in cui ti trovi'),
              children: <Widget>[
                for (var tract in tracts)
                  new SimpleDialogOption(
                    child: new Text(tract),
                    onPressed: () {
                      tractSelected = tract;
                      Navigator.pop(context, DONE.YES);
                    },
                  ),
              ],
            ))) {
      case DONE.YES:
        return tractSelected;
        break;
      case DONE.NO:
        throw new Exception("Error");
        break;
    }
  }

  _prepareForBottomSheet(
      PositionInMap positionInMap, List<double> coordinates) async {
    try {
      List<String> tracts = await dio.getTracts(positionInMap.streetName);
      String selectedTract;
      if (tracts.length > 1) {
        selectedTract = await _askUser(context, tracts);
        if (selectedTract == null) return;
      } else if (tracts.length == 1) {
        selectedTract = tracts[0];
      } else {
        selectedTract = null;
      }
      _showModalBottomSheet(context, positionInMap, coordinates[0],
          coordinates[1], selectedTract);
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackbarBuilder.build(
          "Impossibile connettersi al server", Colors.red));
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    changeMapMode(controller);
  }
}
