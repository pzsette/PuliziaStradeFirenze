import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/Alerts/SnackbarBuilder.dart';
import 'package:pulizia_strade/CustomWidgets/Buttons/CircularButton.dart';
import 'package:pulizia_strade/CustomWidgets/InfoBottomSheet.dart';
import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:pulizia_strade/Network/dioNetwork.dart';
import 'package:pulizia_strade/Providers/ParkProvider.dart';
import 'package:pulizia_strade/Repository/shared_preferences.dart';
import 'package:pulizia_strade/Utils/LoacalizationUtils.dart';
import 'package:pulizia_strade/Utils/NavigationUtils.dart';
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

  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;

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

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);

    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ParkProvider parkProvider = Provider.of<ParkProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
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
            left: screenWidth / 42,
            top: screenWidth / 24,
            child: parkProvider.parked
                ? Stack(children: [
                    IgnorePointer(
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(0),
                          7 + degOneTranslationAnimation.value * 90),
                      child: CircularButtom(
                        color: Colors.green,
                        size: screenWidth / 11,
                        padding: 6,
                        icon: Icons.subdirectory_arrow_right,
                        onClick: () {
                          List coords = sharedPrefs.getParkCoords();
                          openNavigatorTo(coords[0], coords[1], context);
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(42),
                          7 + degOneTranslationAnimation.value * 90),
                      child: CircularButtom(
                        color: Colors.deepPurple,
                        size: screenWidth / 11,
                        padding: 6,
                        icon: Icons.center_focus_strong_rounded,
                        onClick: () {
                          List coords = sharedPrefs.getParkCoords();
                          mapController.moveCamera(CameraUpdate.newLatLng(
                              LatLng(coords[0], coords[1])));
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(85),
                          7 + degOneTranslationAnimation.value * 90),
                      child: CircularButtom(
                          color: Colors.red[400],
                          size: screenWidth / 11,
                          padding: 6,
                          icon: Icons.delete,
                          onClick: () {
                            parkProvider.removePark();
                          }),
                    ),
                    CircularButtom(
                      color: Colors.white,
                      backgroundColor: Colors.blue[400],
                      padding: 8,
                      size: screenWidth / 8,
                      icon: Icons.local_parking,
                      onClick: () {
                        if (animationController.isCompleted) {
                          animationController.reverse();
                        } else {
                          animationController.forward();
                        }
                      },
                    ),
                  ])
                : Container(),
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
