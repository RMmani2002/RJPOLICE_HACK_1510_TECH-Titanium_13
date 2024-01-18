import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';




var size,height,width;

// class Page1 extends StatelessWidget {
//   Page1({Key? key}) : super(key: key);
//   final ref = FirebaseDatabase.instance.reference().child('users');
//   final DatabaseReference _database = FirebaseDatabase.instance.reference();
//   final userId = FirebaseAuth.instance.currentUser!.uid;
//   DateTime? firstUpcomingEventDate;
//   double? lat;
//   double? log;
//   @override
//   Widget build(BuildContext context) {
//     size = MediaQuery.of(context).size;
//     height = size.height;
//     width = size.width;
//
//     return
//         StreamBuilder(
//                   stream: _database.child('user').child(userId).child('events').onValue,
//                   builder: (context, AsyncSnapshot snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//                       return Center(child: Text('No events available for this user'));
//                     } else {
//                       Map<dynamic, dynamic> userEvents = snapshot.data!.snapshot.value;
//                       print("User Events: $userEvents");
//
//                       return ListView(
//                         children: userEvents.keys.map<Widget>((eventId) {
//                           bool isEventIdTrue = userEvents[eventId] == true;
//
//                           if (isEventIdTrue) {
//                             return StreamBuilder(
//                               stream: _database.child('events').child(eventId).onValue,
//                               builder: (context, AsyncSnapshot eventSnapshot) {
//                                 if (eventSnapshot.connectionState == ConnectionState.waiting) {
//                                   return Center(child: CircularProgressIndicator());
//                                 } else if (eventSnapshot.hasError) {
//                                   return Center(child: Text('Error: ${eventSnapshot.error}'));
//                                 } else if (!eventSnapshot.hasData || eventSnapshot.data!.snapshot.value == null) {
//                                   return Center(child: Text('Event details not available'));
//                                 } else {
//                                   Map<dynamic, dynamic> eventData = eventSnapshot.data!.snapshot.value;
//                                   // Check if the event has a valid date
//                                   if (eventData.containsKey('date')) {
//                                     DateTime eventDate = DateTime.parse(eventData['date']);
//
//                                     // Check if the event is upcoming
//                                     if (eventDate.isAfter(DateTime.now()) &&
//                                         (firstUpcomingEventDate == null || eventDate.isBefore(firstUpcomingEventDate!))) {
//                                       firstUpcomingEventDate = eventDate;
//
//                                       // Retrieve and store latitude for the first upcoming event
//                                       if (eventData.containsKey('lat') || eventData.containsKey('log') ) {
//                                         lat = double.tryParse(eventData['lat'].toString());
//                                         log = double.tryParse(eventData['log'].toString());
//                                       }
//                                     }
//                                   }
//                                   return Container();
//                                 }
//                               },
//                             );
//                           } else {
//                             // If eventId is not true, you can return an empty container or handle accordingly
//                             return Container();
//                           }
//                         }).toList(),
//                       );
//                     }
//                   },
//                 );
//     //           ),
//     //         ]
//     //     ),
//     //   ),
//     // );
//
//
//   }
//   void check(){
//     if (lat!=null)
//       {
//
//       }
//   }
//
// }

//
// class MyClass {
//   double _lat;
//   double _log;
//
//   MyClass(this._lat, this._log);
//
//   double get lat => _lat;
//   double get log => _log;
//
//   // Optionally, you can provide methods to update the values
//   void updateFirstData(double lat) {
//     _lat = lat;
//   }
//
//   void updateSecondData(double log) {
//     _log = log;
//   }
// }



class FingerprintManager {
  final databaseReference = FirebaseDatabase.instance.reference().child('user');
  final userId = FirebaseAuth.instance.currentUser!.uid;
  LocalAuthentication authentication = LocalAuthentication();

  Future<bool> authenticate() async {
    final bool isBiometricAvailable =
    await authentication.isDeviceSupported();
    if (!isBiometricAvailable) return false;
    try {
      return await authentication.authenticate(
        localizedReason: "Authenticate to view your secret",
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print("Authentication Error: $e");
      return false;
    }
  }

  void pushFingerprintStatus(bool isFingerprintAuthenticated) {
    String status = isFingerprintAuthenticated ? 'true' : 'false';
    databaseReference.child(userId).child('fingerprint').child('status').set(status);
  }

  void performAuthenticationAndPushStatus() async {
    bool isAuthenticated = await authenticate();
    pushFingerprintStatus(isAuthenticated);
    if (isAuthenticated) {
      print('Fingerprint authentication successful!');

    } else {
      //checkfingerprint1();
      print('Fingerprint authentication failed!');
    }
  }


}





void main() async {
  FingerprintManager fingerprintManager = FingerprintManager();
  // Call the function to perform authentication and push status to the database
  fingerprintManager.performAuthenticationAndPushStatus();
}
