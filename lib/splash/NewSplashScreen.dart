import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_shop/authentication/firedase_authentication.dart';
import 'package:flutter_shop/child/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../local_child_notification.dart';
import '../provider_data.dart';
class SplashScreen extends StatefulWidget {
  SplashScreen({
    this.auth,
    this. onSignedOut,
    this.documentID,

  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final String documentID;


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Firestore _db = Firestore.instance;

  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
//  final FirebaseUser user;
//
//   SplashScreen({Key key, this.user}) : super(key: key);

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(widget.documentID))));
    /////////////////////////
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        final auth = Provider.of<ProviderData>(context);
        print("onMessage: $message");
        final String recipienceID=message['data']['recipient'];
        if (recipienceID==auth.userData.id){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              elevation: 7.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Center(
                child: Row(

                  children: <Widget>[
                    Icon(Icons.message, color: Color.fromRGBO(37, 47, 83, 10.0)),
                    SizedBox(width: 10.0),
                    Text("New Notification",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),

              content: Container(
                height: 200.0,
                child:ListView(
                  children: <Widget>[
                    Text(
                      message['notification']['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'GE SS',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      message['notification']['body'],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  //color: Colors.amber,
                  child: Text('OK',style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                  ),),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }


      },
      onLaunch: (Map<String, dynamic> message) async {

        print("onLaunch: $message");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LocalChildNotification()),
        );

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LocalChildNotification()),
        );
      },
    );
    ///////////////////////////////////////
    @override
    void dispose() {
      if (iosSubscription != null) iosSubscription.cancel();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('images/splash_screen.jpg'),
      ),
    );
  }

  _saveDeviceToken() async {
    // Get the current user
    //String uid = 'jeffd23';
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;

    //FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('User')
          .document(uid).updateData({'androidNotificationToken': fcmToken});
      print("androidNotificationToken:$fcmToken");
      print(("okkk"));
      //jeffd23->parentId
    /*  Firestore.instance.collection('Notification').document('VaMkkscXUbfrsfIQAdZ4cvmok4z1').collection('Notificationitem').document().setData({
        'OwnerId':'VaMkkscXUbfrsfIQAdZ4cvmok4z1',
        'type' : 'like',
        'username':'fadl',
        'timestamp':FieldValue.serverTimestamp(),
        'commentData':'ohh itis very funny',
        'postId':'TNIdH2DyYKib4dxlCshy',
        'postData':'ohh itis very funny',

      }).then((data) {
        setState(() {
          print('ok');
        });
      });*/
      //  .collection('tokens')
      //  .document(fcmToken);
      ///androidNotificationToken

      //   await tokens.setData({
      // 'token': fcmToken,
      //'createdAt': FieldValue.serverTimestamp(), // optional
      //'platform': Platform.operatingSystem // optional
      //   });
      //  Firestore.instance.collection('users').document(currentUserId).updateData({'pushToken': token});
      //  }).catchError((err) {
      // Fluttertoast.showToast(msg: err.message.toString());
      //  });
    }
  }

}
////////////////////////////////////////
