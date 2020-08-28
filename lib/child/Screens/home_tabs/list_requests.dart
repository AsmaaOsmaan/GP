import 'package:flutter_shop/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class ListRequests extends StatefulWidget {

  @override
  _ListRequestsState createState() => _ListRequestsState();
}

class _ListRequestsState extends State<ListRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Container(

        child: Stack(
          children: <Widget>[
            _members(),
          ],
        ),
      ),

    );
  }
  Widget  _members() {
    final auth = Provider.of<ProviderData>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('User').document(auth.userData.id).collection('requests').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return ListView(
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
                              children:<Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(document['username'].toString(),
                                      style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),),],),



                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,

                                  children: <Widget>[Row(
                                    children: <Widget>[
                                      IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () async{
                                        final auth = Provider.of<ProviderData>(context);
                                        await


                                        Firestore.instance
                                            .collection('User')
                                            .document(auth.userData.id)
                                            .collection('Friends')
                                            .document( document['userid'] )
                                            .setData({
                                          'userid': document['userid'] ,
                                          'username':document['username'] ,
                                          'timestamp': Timestamp.fromDate(DateTime.now()),
                                          'statues':false,
                                          'userProfileImg':document['userProfileImg'],

                                        });
                                        Firestore.instance
                                            .collection('User')
                                            .document( document['userid'])
                                            .collection('Friends')
                                            .document( auth.userData.id )
                                            .setData({
                                          'userid': auth.userData.id ,
                                          'username':auth.userData.name ,
                                          'timestamp': Timestamp.fromDate(DateTime.now()),
                                          'statues':false,
                                          'userProfileImg':auth.userData.profileImage,

                                        });

                                      /*  Firestore.instance
                                            .collection('ActivtyLog')
                                            .document(auth.userData.ParentID)
                                            .collection('ActivtyLogitem')
                                            .document()
                                            .setData({
                                          'userid': document['userid'] ,
                                          'username':document['username'] ,
                                          'profile_image':auth.userData.profileImage,
                                          'timestamp': Timestamp.fromDate(DateTime.now()),
                                          'type': 'addfriend',


                                        });*/
                                        Firestore.instance
                                            .collection('User')
                                            .document(auth.userData.id)
                                            .collection('requests')
                                            .document(document.documentID)
                                            .delete();



                                      },

                                      ),

                                      IconButton(icon: Icon(Icons.delete_outline), onPressed: () async{
                                        await  Firestore.instance
                                            .collection('User')
                                            .document(auth.userData.id)
                                            .collection('requests')
                                            .document(document.documentID)
                                            .delete();
                                      },

                                      ),
                                    ],
                                  )],


                                ),




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
