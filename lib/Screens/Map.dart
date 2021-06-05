import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pulizia_strade/Utils/utils.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  var currentLocation;
  bool mapToggle = false;

  @override
  void initState() {
    super.initState();

    print(Location().getLocation().toString());

    /*Location().getLocation().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
      });
    });*/
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
    ));
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    changeMapMode(controller);
  }
}
