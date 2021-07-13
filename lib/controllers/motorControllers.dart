import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:motorsafetysistem/models/motorlocation.dart';

class LocationServices {
  Location targetLoc = Location();
  StreamController<MotorLocation>_locationStreamController = StreamController<MotorLocation>();
  Stream<MotorLocation> get locatioanStream => _locationStreamController.stream;

  LocationServices() {
    DatabaseReference _test = FirebaseDatabase.instance.reference().child('position');
    _test.get().then((DataSnapshot? data) {
      _locationStreamController.add(MotorLocation(
        targetLat: data?.value['lat'],
        targetLon: data?.value['lng']
        ));
      // print("Data : ${data?.value} ");
      });
  }

  void dispose() => _locationStreamController.close();
}