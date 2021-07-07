import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/Alerts/SnackbarBuilder.dart';
import 'package:pulizia_strade/CustomWidgets/Buttons/InfoButton.dart';
import 'package:pulizia_strade/CustomWidgets/InfoBottomSheet.dart';
import 'package:pulizia_strade/CustomWidgets/ParkButtonBuilder.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Providers/ParkProvider.dart';
import 'package:pulizia_strade/Utils/LoacalizationUtils.dart';
import 'package:pulizia_strade/Utils/SizeConfig.dart';
import 'package:pulizia_strade/Utils/utils.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

enum DONE { YES, NO }

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  bool _isButtonTapped = false;
  bool mapToggle = false;
  GoogleMapController mapController;
  var currentLocation;
  bool fabShown = false;

  final DioNetwork dio = new DioNetwork();

  @override
  void initState() {
    super.initState();
    determinePosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        fabShown = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ParkProvider parkProvider = Provider.of<ParkProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          mapToggle
              ? GoogleMap(
                  mapType: MapType.normal,
                  markers: parkProvider.markers,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation[0], currentLocation[1]),
                    zoom: 17,
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Positioned(
            left: SizeConfig.blockSizeHorizontal * 40,
            bottom: SizeConfig.blockSizeVertical * 2,
            child: InfoButton(
              onClick: () async {
                if (!_isButtonTapped) {
                  _isButtonTapped = true;
                  PositionInMap positionInMap;
                  List<double> coordinates = await determinePosition();
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
            ),
          ),
        ],
      ),
      floatingActionButton:
          parkProvider.parked ? buildSpeedDial(context, mapController) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
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
