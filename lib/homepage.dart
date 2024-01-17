import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:local_auth/local_auth.dart';
import 'main.dart';
import 'sos.dart';
import 'algorithm.dart';

var size,height,width;
final userId = FirebaseAuth.instance.currentUser!.uid;

class Homepage extends StatefulWidget {
  // const Homepage({Key? key}) : super(key: key);
  Homepage({Key? key}) : super(key: key);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  //final ref = FirebaseDatabase.instance.ref('Post');

  final user=FirebaseAuth.instance.currentUser;
  int pageIndex = 1;

  var size,height,width;

  final pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
  ];


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 6.0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('lib/image/logo.png'), // Replace with your image asset
              radius: 20,
            ),
            SizedBox(width: width*0.05),
            Text('Rajasthan Police', style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),),
          ],
        ),
        //centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),

    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: height*0.085,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Column(
                children:[
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    icon: pageIndex == 0
                        ? const Icon(
                      Icons.event_available,
                      color:Colors.red,
                      size: 35,
                    )
                        : const Icon(
                      Icons.event_available_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  //Text("List"),
                ]),),

          Container(
            child: Column(
                children:[
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    icon: pageIndex == 1
                        ? const Icon(
                      Icons.home,
                      color:Colors.red,
                      size: 35,
                    )
                        : const Icon(
                      Icons.home_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  //Text("Home"),
                ]),),


          Container(

            child: Column(
                children:[
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 2;
                      });
                    },
                    icon: pageIndex == 2
                        ? const Icon(
                      Icons.message,
                      color:Colors.red,
                      size: 35,
                    )
                        : const Icon(
                      Icons.message_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  //Text("messages"),
                ]),),

          Container(

            child: Column(
                children:[
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 3;
                      });
                    },
                    icon: pageIndex == 3
                        ? const Icon(
                      Icons.person,
                      color:Colors.red,
                      size: 35,
                    )
                        : const Icon(
                      Icons.person_outline,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                 // Text("Profile"),
                ]
            ),
          ),


        ],
      ),
    );

  }
}


class Page1 extends StatelessWidget {
  Page1({Key? key}) : super(key: key);
  final ref = FirebaseDatabase.instance.reference().child('users');
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  DateTime? firstUpcomingEventDate;
  double? lat;
  double? log;
  OverlayEntry? overlayEntry;
  bool isWithinRange = true;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
        body: Center(
        child: Column(
        children: [
        SizedBox(height: height * 0.01),
              Container(
              width: width * 1,
              child: Text(
              "Event List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              ),
              ),
              SizedBox(height: height * 0.01),
              Expanded(
              child: Divider(
              thickness: 1.5,
              color: Colors.red,
              ),
              ),
            SizedBox(height: height * 0.01),

          Container(
            height:height*0.7,
            child: StreamBuilder(
              stream: _database.child('user').child(userId).child('events').onValue,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return Center(child: Text('No events available for this user'));
                } else {
                  Map<dynamic, dynamic> userEvents = snapshot.data!.snapshot.value;
                  print("User Events: $userEvents");

                  return ListView(
                    children: userEvents.keys.map<Widget>((eventId) {
                      bool isEventIdTrue = userEvents[eventId] == true;

                      if (isEventIdTrue) {
                        return StreamBuilder(
                          stream: _database.child('events').child(eventId).onValue,
                          builder: (context, AsyncSnapshot eventSnapshot) {
                            if (eventSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (eventSnapshot.hasError) {
                              return Center(child: Text('Error: ${eventSnapshot.error}'));
                            } else if (!eventSnapshot.hasData || eventSnapshot.data!.snapshot.value == null) {
                              return Center(child: Text('Event details not available'));
                            } else {
                              Map<dynamic, dynamic> eventData = eventSnapshot.data!.snapshot.value;
                              // Check if the event has a valid date
                              // if (eventData.containsKey('date')) {
                              //   DateTime eventDate = DateTime.parse(eventData['date']);
                              //
                              //   // Check if the event is upcoming
                              //   if (eventDate.isAfter(DateTime.now()) &&
                              //       (firstUpcomingEventDate == null || eventDate.isBefore(firstUpcomingEventDate!))) {
                              //     firstUpcomingEventDate = eventDate;
                              //
                              //     // Retrieve and store latitude for the first upcoming event
                              //     if (eventData.containsKey('lat') || eventData.containsKey('log') ) {
                              //       lat = double.tryParse(eventData['lat'].toString());
                              //       log = double.tryParse(eventData['log'].toString());
                              //     }
                              //   }
                              // }
                              if (eventData.containsKey('lat') || eventData.containsKey('log') ) {
                                lat = double.tryParse(eventData['lat'].toString());
                                log = double.tryParse(eventData['log'].toString());
                              }

                              if (lat != null && log != null) {
                                checkLocation(lat! , log!); // Check location against specified range
                              }


                                      if (!isWithinRange) {
                                        //_showOverlay();
                                        _otpOverlay(context);
                                       // FingerprintManager().performAuthenticationAndPushStatus();
                                      }



                              return Padding(
                                padding: const EdgeInsets.fromLTRB(20,10,20,10),
                                child:
                                PhysicalModel(
                            color: Colors.red,
                            elevation: 10,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                            // child:Padding(
                            // padding: const EdgeInsets.fromLTRB(5,10,5,10),
                            child: Container(
                            width: width*0.9,
                            //height:height*0.15,
                            child: Column(
                            children: [
                            Container(
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            Container(
                            child: Row(children: [
                            Icon(Icons.date_range_outlined,size:30,color: Colors.white,),
                            Text(eventData['date']?? 'Date nill',style: TextStyle(color: Colors.white,
                            fontSize: 20,),),
                            ],)
                            ),

                            Container(
                            child: Row(children: [
                            Icon(Icons.access_time,size:30,color: Colors.white,),
                            Text(eventData['time']?? 'Time nill',style: TextStyle(color: Colors.white,
                            fontSize: 20,),),
                            ],
                            )
                            ),
                            ],
                            ),
                            ),
                            Container(
                            child: Text(eventData['event']?? 'Event nill',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                            fontSize: 20,),
                            ),
                            ),
                            Container(
                            child: Center(
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            Container(
                            child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.location_on_outlined,size:30,color: Colors.white,),
                              ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(eventData['location']?? 'Location nill',
                                    maxLines: 2, // Limit the number of lines
                                    overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,
                                    fontSize: 20,),) ,
                                ],
                              )
                            ),

                            ],
                            ),
                            ),
                            ],
                            ),
                            ),
                            ),
                            ]
                            ),
                            ),
                           // ),
                                ),
                              );
                            }
                          },
                        );
                      } else {
                        // If eventId is not true, you can return an empty container or handle accordingly
                        return Container();
                      }
                    }).toList(),
                  );
                }
              },
            ),

          ),
        ]
              ),
                    ),
                );
              }

// Function to check if the user's location is within the specified range
Future<void> checkLocation(double lat, double log) async {
  try {
    checkLocationPermission();
    Position currentPosition = await Geolocator.getCurrentPosition();
    double distanceInMeters = Geolocator.distanceBetween(lat, log, currentPosition.latitude, currentPosition.longitude);

    // Set isWithinRange based on your specified range (e.g., 100 meters)
    isWithinRange = distanceInMeters >= 100;
    FingerprintManager().performAuthenticationAndPushStatus();
  } catch (e) {
    print('Error checking location: $e');
  }
}

  Future<bool> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }


  void _otpOverlay(BuildContext context) async {

    OverlayState overlayState = Overlay.of(context);

    OverlayEntry overlayEntry3;


    overlayEntry3 = OverlayEntry(builder: (context) {


      return Positioned(
        left: MediaQuery.of(context).size.width * 0.05,
        top: MediaQuery.of(context).size.height * 0.04,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.2,
            color: Colors.red.shade400,
            child: Material(
              color: Colors.transparent,

              child: Column(
                children: [


                  InkWell(
                    onTap: (){
                      _removeOverlay();
                    },
                    child: Container(child:
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.84,),
                        Icon(Icons.close,color: Colors.white,),
                      ],
                    ),
                    ),
                  ),


                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),

                  Container(child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05,),

                     // Icon(Icons.check_circle_outline_outlined,color: Colors.white,size : 50.0,),

                      Container(
                        child:
                        Text('Your Out of Range',
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.03,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)
                        ),
                      ),

                    ],
                  ),
                  ),

                  // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  //
                  // Container(child:  Text('OTP has been Sent to Registered Moblie Number',
                  //     style: TextStyle(
                  //         fontSize: MediaQuery.of(context).size.height * 0.02,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white)
                  // ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    );


    //overlayState.insertAll([overlayEntry3]);


    await Future.delayed(Duration(seconds: 3));

    overlayEntry3.remove();
  }

  void _removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }




// void _showOverlay() {
  //   overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: height*0.1,
  //       left: width*0.15,
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //
  //           height: height*0.15,
  //           width: width*0.7,
  //           decoration: BoxDecoration(
  //             color: Colors.green,
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //           child: Column(
  //             children: [
  //               Padding(padding: EdgeInsets.fromLTRB(230, 0, 0, 2),
  //                 child: IconButton(
  //                   icon: Icon(Icons.close),
  //                   onPressed: () {
  //                     _removeOverlay();
  //                   },
  //                 ),),
  //               Text(
  //                 "Return" ,
  //                 style: TextStyle(color: Colors.white),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   Overlay.of(context)?.insert(overlayEntry!);
  // }
  //
  // void _removeOverlay() {
  //   if (overlayEntry != null) {
  //     overlayEntry!.remove();
  //     overlayEntry = null;
  //   }
  // }

}




DateTime now = DateTime.now();
String formattedDate = DateFormat.MMMEd().format(DateTime.now());
const defaultDuration = Duration(hours: 2, minutes: 30);



class Page2 extends StatelessWidget {
  Page2({Key? key}) : super(key: key);

  static LatLng sourceLocation = LatLng(12.989802, 79.971097);
  static LatLng destination = LatLng(12.984397, 79.973972);
  BitmapDescriptor sourceicone = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationicone = BitmapDescriptor.defaultMarker;

  void setCustomMarkerIcon(){
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "lib/image/image1.png")
        .then(
          (icon) {
        sourceicone = icon;
      },);
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "lib/image/image1.png")
        .then(
          (icon) {
        destinationicone = icon;
      },);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Container(
      color: Colors.white,
      child: Center(
        child:SingleChildScrollView(
          child: Column(
            children: [


              Container(
                width: width*1,
                height:height*0.06 ,
                color: Colors.red.shade600,
                child: Center(
                  child:
                  Row(
                    children:[
                      SizedBox(width: width*0.04,),
                      const Text(
                        'Bandobast Duty',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      SizedBox(width: width*0.2,),

                      Icon(Icons.date_range_outlined,color: Colors.white,),
                      SizedBox(width: width*0.02,),
                      Text(formattedDate,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white),),
                      //SizedBox(width: width*0.08,),
                    ],

                  ),
                ),
              ),


              SizedBox(height: height*0.01,),


              Container(
                width: width*0.7,
                height:height*0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:Colors.transparent,
                  border: Border.all(
                    width: 2,
                    color: Colors.purple.shade900,
                  ),
                ),
                child:
                const Center(
                  child: Column(
                    children: [
                      Text("Duty Hr left"),
                      SlideCountdown(
                        duration: defaultDuration,
                        slideDirection: SlideDirection.down,
                        icon: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.alarm,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        style: TextStyle(color: Colors.red,fontSize: 30,), // Set the text color
                      ),

                    ],
                  ),
                ),
              ),


              SizedBox(height: height*0.01,),

              Container(
                width:width*0.28,
                child:
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SosPage()
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Change this to the desired color
                    shape: CircleBorder(), // Set to CircleBorder for a circular button
                    padding: EdgeInsets.all(16), // Adjust padding as needed
                  ),
                  child:Center(
                    child:
                    Icon(Icons.sos,size: 57,color: Colors.white,),),

                ),
              ),


              SizedBox(height: height*0.01,),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                height:height*0.4,
                width:width*0.9,
                child: Center(
                  child: GoogleMap(initialCameraPosition: CameraPosition(target: sourceLocation, zoom: 16),
                    markers: {
                      Marker(
                        markerId: MarkerId("source"),
                        icon: sourceicone,
                        position: sourceLocation,
                      ),
                      Marker(
                        markerId: MarkerId("source"),
                        icon: destinationicone,
                        position: destination,
                      )
                    },
                  ),
                ),
              ),


              SizedBox(height: height*0.01,),

              Container(
                child:
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SizedBox(width: width*0.05,),
                      Container(
                        child:Column(
                          children: [

                            ElevatedButton(
                              onPressed: () async {
                                ///to do
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // Change this to the desired color
                                shape: CircleBorder(), // Set to CircleBorder for a circular button
                                padding: EdgeInsets.all(16), // Adjust padding as needed
                              ),
                              child:Center(
                                child:
                                Icon(Icons.free_breakfast_outlined,size: 25,color: Colors.white,),),
                              // ),
                            ),

                            SizedBox(height: height*0.01,),
                            Text("Takebreak"),
                          ],
                        ),
                      ),
                      // SizedBox(width: width*0.125),

                      Container(
                        child:Column(
                          children: [

                            ElevatedButton(
                              onPressed: () async {
                                ///to do
                                /// FingerprintManager().performAuthenticationAndPushStatus();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // Change this to the desired color
                                shape: CircleBorder(), // Set to CircleBorder for a circular button
                                padding: EdgeInsets.all(16), // Adjust padding as needed
                              ),

                              child:Center(
                                child:
                                Icon(Icons.report_gmailerrorred,size: 25,color: Colors.white,),),

                            ),

                            SizedBox(height: height*0.01,),
                            Text("Report"),
                          ],
                        ),
                      ),

                      // SizedBox(width: width*0.125,),

                      Container(
                        child:Column(
                          children: [

                            ElevatedButton(
                              onPressed: () async {
                                ///to do
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // Change this to the desired color
                                shape: CircleBorder(), // Set to CircleBorder for a circular button
                                padding: EdgeInsets.all(16), // Adjust padding as needed
                              ),
                              child: Center(
                                child:
                                Icon(Icons.swap_horizontal_circle_outlined,size: 25,color: Colors.white,),),
                              //  ),
                            ),

                            SizedBox(height: height*0.01,),
                            Text("Swap Request"),
                          ],
                        ),
                      ),

                      // SizedBox(width: width*0.05,),
                    ],
                  ),
                ),
              ),










            ],
          ),
        ),
      ),
    );
  }
}





class Page3 extends StatelessWidget {
  Page3({Key? key}) : super(key: key);

  final ref = FirebaseDatabase.instance.reference().child('message');

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            Container(
              width: width * 1,
              child: Text(
                "Important Messages",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.01),
            Expanded(
              child: Divider(
                thickness: 1.5,
                color: Colors.red,
              ),
            ),
            SizedBox(height: height * 0.01),
            Container(
              height: height * 0.7,
              child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: LoadingMessage(
                      message: snapshot.child('msg').value.toString(),
                      receivedTime: DateTime.now(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingMessage extends StatelessWidget {
  final String message;
  final DateTime receivedTime;

  LoadingMessage({required this.message, required this.receivedTime});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Center(
       // padding: const EdgeInsets.all(16.0),
        child:
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  '${_formatTime(receivedTime)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute}';
  }
}






class Page4 extends StatelessWidget {
  Page4({Key? key}) : super(key: key);
  final ref = FirebaseDatabase.instance.reference().child('user');
  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: StreamBuilder(
          stream: ref.child(userId).onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              Map<dynamic, dynamic>? userData =
              snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

              if (userData == null) {
                return Center(child: Text('No data available'));
              }

              return Column(
                children: [
                  PhysicalModel(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child:Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Row(
                        children: [

                          Container(
                            width: width * 0.4,
                            height: height * 0.2,
                          //color: Colors.black,
                          //   child:Padding(
                          // padding: const EdgeInsets.fromLTRB(10,10,10,10),
                           child: CircleAvatar(
                             child: Image.network(
                               "https://th.bing.com/th/id/OIP.audMX4ZGbvT2_GJTx2c4GgHaHw?pid=ImgDet&rs=1",
                             ),
                           ),
                        // ),
                        ),


                      Container(
                       // color: Colors.red,
                        width: width * 0.6,
                        height: height * 0.2,
                        child: Padding(padding: EdgeInsets.fromLTRB(0,5,5,5),
                          child: Center(
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Align(alignment: Alignment.centerLeft,
                                child:Text(
                                        'Name: ${userData['name'] ?? 'Name not available'}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                              Align(alignment: Alignment.centerLeft,
                                child: Text(
                                    'Phone Number: ${userData['phone'] ?? 'Number not available'}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                              ),
                              Align(alignment: Alignment.centerLeft,
                                child: Text(
                                      'ID: ${userData['id'] ?? 'ID not available'}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ), textAlign: TextAlign.left,
                                    ),

                              ),

                            ],
                          ),
                        ),
                        ),
                      ),



                      //     Container(
                      //        alignment: Alignment.centerLeft,
                      //       width: width * 0.6,
                      //       height: height * 0.2,
                      //       color: Colors.red,
                      //       child:Padding(padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                      //         child:
                      //         Column(
                      //           children: [
                      //
                      //             Container(child:
                      //                 Text(
                      //               'Name: ${userData['name'] ?? 'Name not available'}',
                      //               style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 16,
                      //               ),textAlign: TextAlign.left,
                      //             ),
                          //             ),
                          //         Container(child:
                          //             Text(
                          //           'Phone Number: ${userData['phone'] ?? 'Phone Number not available'}',
                          //           style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 16,
                          //           ),
                          //         ),
                          //             ),
                          //         Container(
                          //           child: Text(
                          //             'ID: ${userData['id'] ?? 'ID not available'}',
                          //             style: TextStyle(
                          //               color: Colors.black,
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 16,
                          //             ),
                          //           ),
                          //         ),
                      //           ],
                      //         ),
                      //     ),
                      // ),


                          //SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                        ],
                      ),
                    ),
              ),
                  ),

                   SizedBox(height: height*0.01,),

                  PhysicalModel(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: width*1,
                      height: height*0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: width*0.3,
                            height: height*0.1,
                            child: Icon(Icons.security_outlined, color: Colors.red,size: 40,),
                          ),
                          Container(
                            width: width*0.7,
                            height: height*0.1,
                            //color: Colors.cyan,
                            child: Column(
                              children: [

                                SizedBox(height: height *0.02,),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Posting",style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  ),
                                ),

                                SizedBox(height: height *0.01,),

                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Constable",style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),),
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height*0.01,),


                  PhysicalModel(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: width*1,
                      //height: height*0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: width*0.3,
                            //height: height*0.1,
                            child: Icon(Icons.home, color: Colors.red,size: 40,),
                          ),
                          Container(
                            width: width*0.7,
                            //height: height*0.1,
                            //color: Colors.cyan,
                            child: Column(
                              children: [

                                SizedBox(height: height *0.02,),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Address",style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  ),
                                ),



                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,5,5,10),
                              child:Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(userData['address'] ?? 'Address not available',style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),),
                                ),),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height*0.01,),


                  PhysicalModel(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: width*1,
                      height: height*0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: width*0.3,
                            height: height*0.1,
                            child: Icon(Icons.bloodtype, color: Colors.red,size: 40,),
                          ),
                          Container(
                            width: width*0.7,
                            height: height*0.1,
                            //color: Colors.cyan,
                            child: Column(
                              children: [

                                SizedBox(height: height *0.02,),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Blood Group",style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  ),
                                ),

                                SizedBox(height: height *0.01,),

                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(userData['blood'] ?? 'Blood Group not available',style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),),
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),



                  SizedBox(height:height*0.01),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.0),
                    child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Change this to the desired color
                      ),
                      onPressed: (()=>signout()),
                      child: Text('Logout',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}





