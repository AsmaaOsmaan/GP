import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
      ),

      body: ListView.builder(
        itemBuilder: (context, position) {
          return
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  Text('Aya Has commented on Post Aya Has commented on Post  Aya Has commented on Post Aya Has commented on Post ')
                ],),
              ),
            );
        },
      ),
    );
  }
  Widget _draw(){
    return StreamBuilder<QuerySnapshot>(
      //stream: Firestore.instance.collection('User').where('ParentId',isEqualTo: 1).snapshots(),
     // stream:Firestore.instance.collection('ActivtyLog').document('jeffd23').collection('ActivtyLogitem').document('5arJBmgyMNlJgLKyvldS').get(),
     //stream:Firestore.instance.collection('ActivtyLog').document('ParentID').collection('ActivtyLogitem').snapshots(),
     stream:Firestore.instance.collection('ActivtyLog').where('ParentId',isEqualTo: 1).snapshots(),

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
               // if( document['images']==null)  {
                  return   Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                              children: <Widget>[

                                Container(
                                    width: 60,
                                    height: 60,

                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // borderRadius: BorderRadius.circular(100.0),
                                        image: DecorationImage(

                                          image: ExactAssetImage('images/imageprofile3.jpg'),
                                          fit: BoxFit.cover,
                                        ))),

                                Row(
                                  children: <Widget>[
                                    Text(
                                      document['UserName'],
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

                          ],
                        )
                    ),
                  );
             //   }


              }).toList(),
            );
        }
      },
    );

  }
}