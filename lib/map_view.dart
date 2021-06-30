import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigator/get_location.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;
  late Position _currentPosition;
  bool? canLocate;

  void getPosition() async {
    try {
      await getLocation().then((value) => _currentPosition = value);
        canLocate = true;
    } catch (e) {
      print(e);
        canLocate = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100,
                      child: InkWell(
                        onTap: () => mapController.animateCamera(
                          CameraUpdate.zoomIn(),
                        ),
                        splashColor: Colors.blue,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.add,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // inkwell color
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.remove),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.orange.shade100, // button color
                    child: InkWell(
                      splashColor: Colors.orange, // inkwell color
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        getPosition();
                        if (canLocate==true) {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
