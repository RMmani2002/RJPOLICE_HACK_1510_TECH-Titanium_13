import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking/algorithm.dart';
import 'package:tracking/homepage.dart';
import 'package:tracking/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'location.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  _startTimer();
}

class LatDataProvider with ChangeNotifier {
  double? _lat;

  double? get lat => _lat;

  void setLat(double? newLat) {
    _lat = newLat;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Homepage();
            }
            else {
              return Login();
            }
          }),
    );
  }
}


// LatLng eventLocation = LatLng(12.989802, 79.971097);
//
// void location() async {
//   // Get the current user location
//   Position userLocation = await getCurrentLocation();
//   double distance = calculateDistance(
//     userLocation.latitude,
//     userLocation.longitude,
//     eventLocation.latitude,
//     eventLocation.longitude,
//   );
//   double distanceThreshold = 100.0; // Assume the distance threshold is 100 meters
//
//   if (distance <= distanceThreshold) {
//     print('User is within the specified distance of the event location.');
//   } else {
//     print('User is outside the specified distance of the event location.');
//   }
// }


// Future<Position> getCurrentLocation() async {
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   return position;
// }
//
// double calculateDistance(double startLatitude, double startLongitude,
//     double endLatitude, double endLongitude) {
//   return Geolocator.distanceBetween(
//       startLatitude, startLongitude, endLatitude, endLongitude);
// }

void _startTimer() {
  late Timer _timer;
  // Set up a timer to trigger fingerprint authentication every 30 minutes
  _timer = Timer.periodic(Duration(minutes: 1), (timer) {
    // Call the function to perform authentication and push status to the database
    FingerprintManager().performAuthenticationAndPushStatus();
  });
}