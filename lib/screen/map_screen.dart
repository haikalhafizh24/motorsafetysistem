import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motorsafetysistem/models/motorlocation.dart';
import 'package:motorsafetysistem/controllers/motorControllers.dart';

const LatLng SOURCE_LOCATION = LatLng(-6.38977, 106.8779575);
const LatLng DEST_LOCATION = LatLng(-6.3976658, 106.8779136);
const double CAMERA_ZOOM = 18;
const double CAMERA_TILT = 45;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 10;
const double PIN_INVISIBLE_POSITION = -220;

class MapScreen extends StatefulWidget { 
  static const String id='map_page';
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  Set<Marker> _markers = Set<Marker>();
  double pinPillPosition = PIN_VISIBLE_POSITION;
  LocationServices targetLocation = LocationServices();

  late Location location;
  late LocationData userLocation;
  late double latitude;
  late double longitude;

  @override
  void dispose() {
    targetLocation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // targetLocation.locatioanStream.listen((motorLocation) {
    //   setState(() {
    //     latitude = motorLocation.targetLat;
    //     longitude = motorLocation.targetLon;
    //     print(motorLocation);
    //   });
    // });

    this.getUserLocation();
    this.setSourceAndDestinationMarkerIcons();
  }

  void setSourceAndDestinationMarkerIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'assets/img/user_icon.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0),
        'assets/img/destination_icon.png');
  }

  void getUserLocation() async {
    location = new Location();
    location.onLocationChanged.listen((LocationData userLocation) {
    });
    userLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          StreamBuilder<MotorLocation>(
            stream: targetLocation.locatioanStream,
            builder: (_, snapshot) {
              if(snapshot.hasData) { 
              return Positioned.fill(
                      child: GoogleMap(
                    myLocationEnabled: true,
                    compassEnabled: false,
                    tiltGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    markers: _markers,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      zoom: CAMERA_ZOOM,
                      tilt: CAMERA_TILT,
                      bearing: CAMERA_BEARING,
                      target: LatLng(
                        snapshot.data!.targetLat,
                        snapshot.data!.targetLon
                      ),
                    ),
                    onTap: (LatLng loc) {
                      setState(() {
                        this.pinPillPosition = PIN_INVISIBLE_POSITION;
                      });
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                      setState(() {
                        _markers.add(Marker(
                            markerId: MarkerId('destinationPin'),
                            position: LatLng(
                              snapshot.data!.targetLat,
                              snapshot.data!.targetLon
                            ),
                            icon: destinationIcon,
                            onTap: () {
                              setState(() {
                                this.pinPillPosition = PIN_VISIBLE_POSITION;
                              });
                            }));
                      });
                    },
                    )
                  );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                  )
                  );
              }
            }
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: this.pinPillPosition,
            child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset.zero)
                    ]),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                              child: Image.asset(
                            'assets/img/destination_icon.png',
                            width: 50,
                            height: 50,
                          )),
                          SizedBox(width: 18),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Mio Soul',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                  Text('B 9387 FSD'),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: SingleButton(text: 'Track')
                            )
                          ]),
                    ),
                  ],
                )),
          ),
        ],
      ),
    ));
  }
}

class SingleButton extends StatelessWidget {
  const SingleButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        width: 300,
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero)
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ));
  }
}