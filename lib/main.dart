import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracking/algorithm.dart';
import 'package:tracking/homepage.dart';
import 'package:tracking/login.dart';
import 'lock.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  _startTimer();
  checkLocationPermission();
}

Future<bool> checkLocationPermission() async {
  PermissionStatus status = await Permission.location.status;

  if (status == PermissionStatus.granted) {
    return true;
  } else {
    return false;
  }
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
              bool isFingerprintAuthenticated = true; // Replace with your logic to check fingerprint status
              if (isFingerprintAuthenticated) {
                return Homepage();
              } else {
                return lock();
              }
            }
            else {
              return Login();
            }
          }),
    );
  }
}



void _startTimer() {
  late Timer _timer;
  // Set up a timer to trigger fingerprint authentication every 30 minutes
  _timer = Timer.periodic(Duration(minutes: 1), (timer) {
    // Call the function to perform authentication and push status to the database
    FingerprintManager().performAuthenticationAndPushStatus();
  });
}