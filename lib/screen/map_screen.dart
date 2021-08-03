import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motorsafetysistem/services/shared_preferences.dart';

const double CAMERA_ZOOM = 18;
const double CAMERA_TILT = 45;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 10;
const double PIN_INVISIBLE_POSITION = -220;

class MapScreen extends StatefulWidget {
  static const String id = 'map_page';
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  Set<Marker> _markers = Set<Marker>();
  double pinPillPosition = PIN_VISIBLE_POSITION;

  late String address;

  late Location location;
  late LocationData userLocation;
  late double latitude;
  late double longitude;
  late double lat;
  late double lon;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    this.getUserLocation();
    this.setSourceAndDestinationMarkerIcons();

    latitude = PhoneNumberPreferences.getLatTarget() ?? -6.3976658;
    longitude = PhoneNumberPreferences.getLonTarget() ?? 106.8779136;
    address = PhoneNumberPreferences.getaddress() ?? '';
    print('$address');
  }

  void setSourceAndDestinationMarkerIcons() async {
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0),
        'assets/img/destination_icon.png');
  }

  void getUserLocation() async {
    location = new Location();
    location.onLocationChanged.listen((userLocation) {});
    userLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
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
              target: LatLng(latitude, longitude),
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
                    position: LatLng(latitude, longitude),
                    icon: destinationIcon,
                    onTap: () {
                      setState(() {
                        this.pinPillPosition = PIN_VISIBLE_POSITION;
                      });
                    }));
              });
            },
          )),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: this.pinPillPosition,
            child: InfoCard(
              address: address,
              urlLink:
                "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude"
            ),
          ),
        ],
      ),
    ));
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.address, required this.urlLink})
      : super(key: key);

  final String address;
  final String urlLink;

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        // padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Color(0xFF1F487E),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero)
            ]),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          color: Colors.white),
                      child: Image.asset(
                        'assets/img/destination_icon.png',
                        width: 50,
                        height: 50,
                      )),
                  SizedBox(width: 18),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Lokasi Sepeda Motor',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('$address',
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              )),
                          // Container(
                          //   height: size.height * 0.06,
                          //   color:Color(0xFF269CCF),
                          // )
                        ]),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _launchURL("$urlLink");
              },
              child: Container(
                height: size.height * 0.06,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Petunjuk Arah",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
