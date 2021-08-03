import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motorsafetysistem/services/shared_preferences.dart';
import 'package:motorsafetysistem/components/fullbutton.dart';
import 'map_screen.dart';

final Telephony telephony = Telephony.instance;
onBackgroundMessage(SmsMessage message) {}

class Locationdatascreen extends StatefulWidget {
  static const String id = 'GPS_page';
  @override
  _LocationdatascreenState createState() => _LocationdatascreenState();
}

class _LocationdatascreenState extends State<Locationdatascreen>
    with SingleTickerProviderStateMixin {
  List<String> _messages = [];
  String _newSms = "";

  late double _scale;
  late double? lat;
  late double? lon;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _messages = PhoneNumberPreferences.getGpsDataList() ?? [];
    listenNewSms();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _newSms = message.body ?? "Error reading message body.";
      _messages.add(_newSms);
    });
    await PhoneNumberPreferences.setGpsDataList(_messages);
    parseData();
  }

  Future<void> listenNewSms() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    } if (!mounted) return;
  }

  void parseData() async {
    final String gpsLat = _newSms.substring(0, 9);
    final String gpsLon = _newSms.substring(11);

    double lat = double.parse(gpsLat);
    double lon = double.parse(gpsLon);

    PhoneNumberPreferences.setLatTarget(lat);
    PhoneNumberPreferences.setLonTarget(lon);

    List<Placemark> address = await placemarkFromCoordinates(lat, lon);

    String placemark =
        "${address[0].street}, ${address[0].subLocality},  ${address[0].locality},  ${address[0].subAdministrativeArea}.  ${address[0].administrativeArea}";
    PhoneNumberPreferences.setaddress(placemark);
    print("$placemark");
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Koordinat Lokasi",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Color(0xFF1F487E))),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                PhoneNumberPreferences.deleteData();
                setState(() {
                  _messages.clear();
                });
              },
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFF1F487E),
              ),
            ),
          ]),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return InfoCard(coordinat: '${_messages[index]}');
                }),
          ),
          Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset.zero)
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lokasi Terbaru",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          )),
                      Text("$_newSms",
                          style: TextStyle(
                            color: Color(0xFF1F487E),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_newSms == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              ' Tidak ada lokasi terbaru ',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        Navigator.pushNamed(context, MapScreen.id);
                      }
                      parseData();
                    },
                    onTapDown: _tapDown,
                    onTapUp: _tapUp,
                    child: Transform.scale(
                      scale: _scale,
                      child: FullButton(
                        boxheight: 50,
                        fillColor: Color(0xFF1F487E),
                        name: "Tampilkan Maps",
                        size: size,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.coordinat,
  }) : super(key: key);

  final String coordinat;

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 9, right: 9, top: 4, bottom: 4),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset.zero)
            ]),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Image.asset(
                    'assets/img/destination_icon.png',
                    width: 50,
                    height: 40,
                  )),
                  SizedBox(width: 18),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('$coordinat',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                              )),
                        ]),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.place_outlined,
                      color: Colors.grey[300],
                    ),
                    onPressed: () {
                      _launchURL(
                          "https://www.google.com/maps/dir/?api=1&destination=$coordinat");
                    },
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
