import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';


class SosPage extends StatefulWidget {
  @override
  _SosPageState createState() => _SosPageState();
}

var size,height,width;




class _SosPageState extends State<SosPage> {
  TextEditingController textController = TextEditingController();
  String? nullableString;
  OverlayEntry? overlayEntry;
  final databaseReference = FirebaseDatabase.instance.reference().child('text');
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Page'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

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
                                Uri phoneno = Uri.parse('tel:102');
                                if (await launchUrl(phoneno)) {

                                }else{
                                  var snackBar = SnackBar(content: Text('Please dail 102'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // Change this to the desired color
                                shape: CircleBorder(), // Set to CircleBorder for a circular button
                                padding: EdgeInsets.all(16), // Adjust padding as needed
                              ),
                              child:Center(
                                child:
                                Icon(Icons.call,size: 30,color: Colors.white,),),
                              // ),
                            ),

                            SizedBox(height: height*0.01,),
                            Text("Ambulance"),
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
                                Uri phoneno = Uri.parse('tel:100');
                                if (await launchUrl(phoneno)) {

                                }else{
                                  var snackBar = SnackBar(content: Text('Please dail 100'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // Change this to the desired color
                                shape: CircleBorder(), // Set to CircleBorder for a circular button
                                padding: EdgeInsets.all(16), // Adjust padding as needed
                              ),

                              child:Center(
                                child:
                                Icon(Icons.track_changes_outlined,size: 30,color: Colors.white,),),

                            ),

                            SizedBox(height: height*0.01,),
                            Text("Control Room"),
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
                                Uri phoneno = Uri.parse('tel:101');
                                if (await launchUrl(phoneno)) {

                                }else{
                                  var snackBar = SnackBar(content: Text('Please dail 101'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // Change this to the desired color
                                shape: CircleBorder(), // Set to CircleBorder for a circular button
                                padding: EdgeInsets.all(16), // Adjust padding as needed
                              ),
                              child: Center(
                                child:
                                Icon(Icons.fire_truck_rounded,size: 30,color: Colors.white,),),
                              //  ),
                            ),

                            SizedBox(height: height*0.01,),
                            Text("Fire Brigade"),
                          ],
                        ),
                      ),

                      // SizedBox(width: width*0.05,),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 10,),

              Container(
                child: Row(children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                  Text("OR"),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                ]),
              ),

              SizedBox(height: 16),


              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                ),
              ),

              SizedBox(height: 16),


              ElevatedButton(
                onPressed: () {
                  _submit();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Change this to the desired color
                ),
                child: Text('Submit',style: TextStyle(color: Colors.white,),),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _submit() {

    if ( textController.text.isNotEmpty) {
      //_showOverlay();
      _submitForm();
    } else {
      var snackBar = SnackBar(content: Text('Please enter proper input'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _submitForm() {
    String enteredText = textController.text;

    // Generate a unique key for the entry
    String? entryKey = databaseReference.push().key;


    // Create a map with the data to be stored in the database
    Map<String, dynamic> data = {
      'text': enteredText,
      'key': entryKey,
    };

    // Push the data to the database under the 'text' node
    databaseReference.child(entryKey!).set(data);

    textController.clear();
    _showOverlay(entryKey);

  }

  void _showOverlay(String entryKey) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: height*0.1,
        left: width*0.15,
        child: Material(
          color: Colors.transparent,
          child: Container(

            height: height*0.15,
            width: width*0.7,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(230, 0, 0, 2),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _removeOverlay();
                    },
                  ),),
                Text(
                  "Submitted successfully with token:$entryKey" ,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry!);
  }

  void _removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

}
