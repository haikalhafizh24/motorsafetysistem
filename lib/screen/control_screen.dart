import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'package:motorsafetysistem/components/mainbutton.dart';
import 'package:motorsafetysistem/components/fullbutton.dart';
import 'package:motorsafetysistem/models/motorlocation.dart';
import 'package:motorsafetysistem/controllers/motorControllers.dart';

class ControlScreen extends StatefulWidget {
  static const String id='control_screen';
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  
  LocationServices targetLocation = LocationServices();
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text( "Secrac",
                  style: TextStyle(
                    fontSize: 45,
                  ),
                  ),
                  Text("Secure and Track your Vehicle",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<MotorLocation>(
                  stream: targetLocation.locatioanStream,
                  builder: (_, snapshot) {
                    if(snapshot.hasData) { 
                    return 
                    // GestureDetector(
                    //   onTap: () {
                    //     dbRef.child('TargetLoc/lat').set(
                    //       snapshot.data!.targetLat);
                    //     dbRef.child('TargetLoc/lon').set(
                    //       snapshot.data!.targetLon);
                    //     dbRef.child('Control/modul').set(
                    //       true);
                    //     print(snapshot.data!);
                    //   },
                    //   child: 
                      MainButton(
                          logo: Icons.power_settings_new_rounded,
                          title: "Turn ON",
                          messageContent: "MODUL HIDUP",
                          colour: Colors.teal,
                        );
                    // );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        );
                    }
                  }
                ),
                // GestureDetector(
                //   onTap: () {
                //     dbRef.child('Control/modul').set(
                //           false);
                //   },
                  // child: 
                  MainButton(
                    logo: Icons.power_settings_new_rounded,
                    title: "Turn Off",
                    messageContent: "MODUL MATI",
                    colour: Colors.red,
                    ),
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MainButton(
                  logo: Icons.vpn_key_rounded,
                  title: "Kontak ON",
                  messageContent: "KONTAK ON",
                  colour: Colors.teal,
                  ),
                  MainButton(
                  logo: Icons.vpn_key_rounded,
                  title: "Kontak OFF",
                  messageContent: "KONTAK OFF",
                  colour: Colors.red,
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MainButton(
                  logo: Icons.electric_moped_rounded, 
                  title: "Starter ON", 
                  messageContent: "STATER ON", 
                  colour: Colors.teal
                  ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.015,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MapScreen.id);
                  },
                  child: FullButton(
                    boxheight: size.height * 0.06,
                    fillColor: Colors.redAccent,
                    name: "Get Location",
                    size: size,
                  ),
                ),
              ],
            ),
          ]),
      ),
    );
  }
}