import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/child/Screens/profile_friends_screen.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friends ',
          style: TextStyle(
            fontSize: 23,
            color: Colors.purple.shade800,
          ),
        ),
        backgroundColor: Colors.grey.shade300,

      ),
      body:Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/wallpaper.jpg'),
              fit: BoxFit.cover,
            )),
        child: Stack(
          children: <Widget>[
            _friends(),
          ],
        ),
      ),
    );
  }
  Widget _friends()
  {final auth = Provider.of<ProviderData>(context);
    return StreamBuilder<QuerySnapshot>(
      stream:  Firestore.instance.collection('User').document(auth.userData.id).collection('Friends').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return  ListView(
              children:
              snapshot.data.documents.map((DocumentSnapshot document) {
                return ListTile(
                  title: Padding(

                    padding: EdgeInsets.all((MediaQuery.of(context).size.width * 1 / 20)),

                    child: Container(
                      height: MediaQuery.of(context).size.height * 1 / 9,
                      width: MediaQuery.of(context).size.width,
                      child: Material(
                          elevation: 14,
                          borderRadius: BorderRadius.circular(8.0),
                          shadowColor: Colors.cyan,
                          child: Padding(
                            padding:EdgeInsets.all((MediaQuery.of(context).size.width * 1 / 30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[ FlatButton(
                                child: Text(document['username'],
                                  style: TextStyle(
                                    color: Colors.grey.shade900,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FriendScreen( document['userid']),
                                    ),);


                                },
                              ),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,

                                    children: <Widget>[
                                      IconButton(icon: Icon(Icons.delete_outline), onPressed: () async{
                                        await


                                        Firestore.instance
                                            .collection('User')
                                            .document(auth.userData.id)
                                            .collection('Friends')
                                            .document(document['userid'])
                                            .delete();

                                        Firestore.instance
                                            .collection('User')
                                            .document(document['userid'])
                                            .collection('Friends')
                                            .document(auth.userData.id)
                                            .delete();
                                      },

                                      ),
                                    ])

                              ],
                            ),
                          )),
                    ),

                  ),

                );
              }).toList(),
            );
        }
      },
    );

  }
}
