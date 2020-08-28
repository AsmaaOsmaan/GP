import 'dart:async';
import 'dart:io';
import 'dart:ui' as prefix1;
import 'dart:convert';
//import 'package:flutter_shop/child/Screens/navigation_darwer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/parent/activtylist.dart'as prefix0;
import 'package:flutter_shop/parent/childpage.dart';
import 'package:flutter_shop/parent/shared_ui/navigation_darwer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/parent/notification.dart' as prefix0;
import 'package:flutter_shop/provider_data.dart';
import 'package:provider/provider.dart';

import '../user_data.dart';
import 'activtylist.dart';
//import 'package:first_run/shared_ui/navigation_darwer.dart';
class PageParent extends StatefulWidget {
  @override
  _PageParentState createState() => _PageParentState();
}

class _PageParentState extends State<PageParent> {
    List<QuerySnapshot> arry=[];
  ////////////
  final _scaffoldKey=GlobalKey<ScaffoldState>();
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  @override
  void initState() {
    super.initState();


    super.initState();
    ///////////
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

////////////////////////
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

            content:Container(
              height: 250.0,
              child: ListView(
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

        ///////////////////////////////////
/*

        SnackBar snackBar = SnackBar(
          content: Text(message['notification']['body']),

        );

        _scaffoldKey.currentState.showSnackBar(snackBar);*/

      //  _keyScafold.of(context).showSnackBar(snackBar);


        /////////////////////////////////////////////
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivityFeed()),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivityFeed()),
        );
      },
    );
    //////////////////
  }
  @override
  void dispose() {
    super.dispose();
    if (iosSubscription != null) iosSubscription.cancel();

  }

  /////////////////
  bool switchval=false;
  bool changeColor = false;
  List<bool>switchvalues;

  List<int>data;
 // void onchanged(bool val){
 //   setState(() {
   //   switchval=val;
  //  });
  //}
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ProviderData>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xffd291bc),
        title: Text('My Children ',style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize:20.0,
          fontStyle:FontStyle.italic
        ),),
        centerTitle: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add_alert),onPressed: ()
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>prefix0.ActivityFeed()),
            );
          },)
        ],
      ),
      drawer: NavigationDrawer(),
      body: _draw(),
    );
  }



  Widget _draw(){
    final auth = Provider.of<ProviderData>(context);
    return StreamBuilder<QuerySnapshot>(
      //snapshot.data
      //stream: Firestore.instance.collection('User').where('ParentID',isEqualTo: auth.userData.uid).snapshots(),
      stream: Firestore.instance.collection('User').where('ParentID',isEqualTo: auth.userData.id).snapshots(),

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        int  numm= snapshot.data.documents.length;
        print(numm);
       // switchvalues.fillRange(0, numm,false);
       // switchvalues.filled( numm,false,false);
        print (switchvalues);
        print(auth.userData.ParentID);
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {

                 return  BodyOfScreen(document: document,);




              }).toList(),
            );
        }
      },
    );

  }
  Widget _dd(){
    return Container(
      color: Colors.amber,
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
     /* Firestore.instance.collection('ActivtyLog').document(uid).collection('ActivtyLogitem').document().setData({
        'type' : 'comment',
        //currentuser.userid
        'userid': uid ,
        'username':'fadl',
        'ParentId':'jeffd23',
        'timestamp':FieldValue.serverTimestamp(),
        'commentData':'ohh itis very funny',
        'postId':'rr',
        'postData':'ohh itis very funny',
        'userProfileImg':'https://firebasestorage.googleapis.com/v0/b/graduation-project-30cb8.appspot.com/o/869_child?alt=media&token=f79f42a7-72d5-4988-abb6-88726669c13d',

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
class BodyOfScreen extends StatefulWidget {
  final document;


  const BodyOfScreen({Key key, this.document}) : super(key: key);
  @override
  _BodyOfScreenState createState() => _BodyOfScreenState();
}

class _BodyOfScreenState extends State<BodyOfScreen> {

 // bool switchval = false;

  @override
  Widget build(BuildContext context) {
    bool switchval=widget.document['statues'];
    return    Card(
      child: InkWell(

        splashColor: Colors.yellow,
        highlightColor: Colors.blue.withOpacity(0.5),
        onTap: () {
          //document.documentID
          String X=widget.document.documentID;
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChildPage(ID:X)));
        },
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
              children: <Widget>[
                Column(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                  children: <Widget>[
                    ( widget.document['images']==null)?
                    Container(
                        width: 60,
                        height: 60,

                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(100.0),
                            image: DecorationImage(

                              image: ExactAssetImage('images/imageprofile3.jpg'),
                              fit: BoxFit.cover,
                            ))): Container(
                        width: 60,
                        height: 60,

                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(100.0),
                            image: DecorationImage(

                              image: NetworkImage(widget.document['images']),
                              fit: BoxFit.cover,

                            ))),

                    Row(
                      children: <Widget>[
                        Text(
                          widget.document['UserName'],
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize:15.0,
                            fontFamily: 'DancingScript',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(icon: Icon(Icons.delete_forever,),onPressed: (){
                  Firestore.instance.collection('User').document(widget.document.documentID).delete();

                },),
                Switch(value:switchval,onChanged:(bool val){
                  setState(() {
                    switchval=val;
                  });
                  Firestore.instance.collection('User').document(widget.document.documentID).updateData({'statues':switchval});

                }, activeColor: switchval ? Colors.blue : Colors.grey  ,)
              ],
            )
        ),
      ),
    );
  }
}


