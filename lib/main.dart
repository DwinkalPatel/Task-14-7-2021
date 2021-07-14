import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:task_flutter/Welcome.dart';

import 'loginpage.dart';


void main() => runApp(

    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: ThemeData(
        primaryColor: Colors.black,
        primarySwatch: Colors.purple,

      ),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences prefs;
  bool issignin =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSiginSharedPref();

  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print(token);
      _storeSharedPref(token);

    });

   /* _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );*/
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context,snapshot){
              if (snapshot.hasError) {
                return Center(child: Text('SOmething went wrong'));
              }
              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                    width: MediaQuery.of(context).size.width,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image(
                          image: AssetImage('assets/images/logo.png'),
                          width: 200,
                          height: 130,
                        ),
                        SizedBox(height: 15,),

                      ],
                    ));
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return Center(child: CircularProgressIndicator());
            },

          ),
        ),
      ),
    );
  }

  Future _storeSharedPref(String token) async{
    prefs.setString('fcm_id',token);

  }

  Future _getSiginSharedPref() async{
   prefs  = await SharedPreferences.getInstance();
   issignin= prefs.getBool('signin');
   if(issignin==null){
     issignin=false;
   }

   Future.delayed(Duration(seconds: 15), () {
     firebaseCloudMessaging_Listeners();
   });

   Future.delayed(Duration(seconds: 3), ()
   {
     if (issignin) {
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(
           builder: (context) => WelcomeScreen(),
         ),
       );
     }
     else {
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(
           builder: (context) => LoginPage(),
         ),
       );
     }
   });

  }
}
