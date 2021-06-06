import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pulizia_strade/Utils/utils.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool mapToggle = false;
  GoogleMapController mapController;
  var currentLocation;
  bool fabShown = true;

  @override
  void initState() {
    super.initState();
    Location().getLocation().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
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
    )
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

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    changeMapMode(controller);
  }
}
