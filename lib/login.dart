import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

var size,height,width;

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: password.text);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'lib/image/bg.png.png', // Replace with your background image asset path
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          Center(
              child: Container(
                width: width*0.9,
                height:height*0.5,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo image
                    Image.asset(
                      'lib/image/logo.png', // Replace with your logo image asset path
                      height: 100.0,
                      width: 100.0,
                    ),

                    SizedBox(height: height*0.02),

                    // Text in the middle
                    Text('Rajasthan Police', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20, fontWeight: FontWeight.bold
                    ),),

                    SizedBox(height: height*0.02),

                    // Email and password fields
                    TextField(
                      controller: email,
                      decoration: InputDecoration(hintText: 'Enter email'),
                    ),
                    SizedBox(height: height*0.02),
                    TextField(
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(hintText: 'Enter password'),
                    ),

                    SizedBox(height: height*0.02),

                    // Submit button
                    // Container(
                    //   child: Center(child:
                    //   ElevatedButton(
                    //     onPressed: (() => signIn()),
                    //     child: Center(
                    //       child: Container(
                    //         width: width*0.5,
                    //         height: height*0.05,
                    //         child: Text("Login",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    //       ),
                    //     ),
                    //   ),),
                    // ),


                    GestureDetector(
                      onTap: (() => signIn()),
                      child:
                      Container(
                        width: width*0.8,
                        height: height*0.05,
                        decoration: BoxDecoration(
                            color: Colors.purple.shade900,
                            borderRadius: BorderRadius.circular(5)
                        ),

                        child: const Center(
                          child:
                          Text("Login",textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                      ),
                    ),

                  ],
                ),
              ),

          ),
        ],
      ),
    );
  }
}
