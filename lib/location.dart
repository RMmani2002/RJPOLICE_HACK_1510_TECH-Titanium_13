// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class LocationManager {
//   final databaseReference = FirebaseDatabase.instance.reference().child('user');
//   final userId = FirebaseAuth.instance.currentUser!.uid;
//
//   Future<Map<String, dynamic>?> getEventLocationData(String eventId) async {
//     try {
//       // Check if the user has the specified event
//       bool hasEvent = await databaseReference.child(userId).child('events').child(eventId).once().then((DatabaseEvent snapshot) {
//         return snapshot.snapshot.value == "true";
//       });
//
//
//       if (hasEvent) {
//         // Retrieve location data for the event
//         Map<String, dynamic>? locationData = await FirebaseDatabase.instance.reference().child('events').child(eventId).once().then((DatabaseEvent snapshot) {
//           return snapshot.snapshot.value as Map<String, dynamic>?;
//         });
//
//         return locationData;
//       } else {
//         // Handle the case where the user does not have the specified event
//         print("User does not have the event with ID: $eventId");
//         return null;
//       }
//     } catch (e) {
//       print("Error getting event location data: $e");
//       return null;
//     }
//   }
//
//   Future<void> getAndPrintEventLocationData(String eventId) async {
//     Map<String, dynamic>? locationData = await getEventLocationData(eventId);
//
//     if (locationData != null) {
//       double latitude = locationData['lat'];
//       double longitude = locationData['log'];
//
//       print("+++++++++++++++++++++++++=+++++++++++++++Latitude: $latitude, Longitude: $longitude  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
//     } else {
//       print("Failed to get location data for the event with ID: $eventId");
//     }
//   }
// }
//
// void main() async {
//   LocationManager locationManager = LocationManager();
//
//   // Example usage
//   await locationManager.getAndPrintEventLocationData("eventId1");
// }
