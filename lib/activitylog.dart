import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_shop/provider_data.dart';
class ActivtyLog extends StatefulWidget {
  @override
  _ActivtyLogState createState() => _ActivtyLogState();
}

class _ActivtyLogState extends State<ActivtyLog> {

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
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
        print("onMessage: $message");

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              //title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
    /*  body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Eshoping.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),*/

    );
  }
  _saveDeviceToken() async {
    print("uuiduuid");
    // Get the current user
   // String uid = 'jeffd23';
     FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
print("uuiduuid");
     print(uid);
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
    /*  Firestore.instance.collection('ActivtyLog').document(uid).collection('ActivtyLogitem').document().setData({
        'type' : 'like',
        //currentuser.userid
        'userid': "ILN3VjgebBF38ojjrSeK" ,
        'username':'aya',
        'ParentId':'jeffd23',
        'timestamp':FieldValue.serverTimestamp(),
        'commentData':'ohh itis very funny',
        'postId':'rr',
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
