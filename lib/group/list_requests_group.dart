import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../provider_data.dart';
class ListRequestsGroup extends StatefulWidget {
  final String documentID;

  ListRequestsGroup(this.documentID, {Key key}) : super(key: key);
  @override
  _ListRequestsGroupState createState() => _ListRequestsGroupState();
}

class _ListRequestsGroupState extends State<ListRequestsGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requests',
          style: TextStyle(
            fontSize: 23,
            color: Colors.purple.shade800,
          ),
        ),
        backgroundColor: Colors.grey.shade300,

      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/wallpaper.jpg'),
              fit: BoxFit.cover,
            )),
        child: Stack(
          children: <Widget>[
            _members(),
          ],
        ),
      ),

    );
  }
  Widget  _members() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('groups').document(widget.documentID).collection('requests').snapshots(),
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
                                            .collection('groups')
                                            .document(widget.documentID)
                                            .collection('members')
                                            .document( document['userid'] )
                                            .setData({
                                              'userid': document['userid'] ,
                                              'username':document['username'] ,
                                              'timestamp': Timestamp.fromDate(DateTime.now()),
                                              'statues':false,

                                        });
                                        Firestore.instance
                                            .collection("groups")
                                            .document(widget.documentID)
                                            .updateData({
                                          'NumberOfMembers': FieldValue.increment(1) ,
                                        });
                                     /*   Firestore.instance.collection('User')
                                            .document(document['userid']).get().then(
                                                (DocumentSnapshot result) async {
                                              Firestore.instance
                                                  .collection('ActivtyLog')
                                                  .document(result['ParentID'])
                                                  .collection('ActivtyLogitem')
                                                  .document()
                                                  .setData({
                                                'userid': result['userid'] ,
                                                'username':result['username'] ,
                                                //'profile_image':auth.userData.profileImage,
                                                'timestamp': Timestamp.fromDate(DateTime.now()),
                                                'type': 'addMember',
                                                'groupID': widget.documentID,

                                              });
                                            });
                                        Firestore.instance
                                            .collection('ActivtyLog')
                                            .document(auth.userData.ParentID)
                                            .collection('ActivtyLogitem')
                                            .document()
                                            .setData({
                                          'userid': auth.userData.id,
                                          'username':auth.userData.name ,
                                          'profile_image':auth.userData.profileImage,
                                          'timestamp': Timestamp.fromDate(DateTime.now()),
                                          'type': 'addMember',
                                          'groupID': widget.documentID,

                                        });*/
                                        Firestore.instance
                                            .collection('groups')
                                            .document(widget.documentID)
                                            .collection('requests')
                                            .document(document.documentID)
                                            .delete();


                                        Firestore.instance
                                            .collection('User')
                                            .document(document['userid'] )
                                            .collection('groups')
                                            .document(widget.documentID )
                                            .setData({
                                          'groupid': widget.documentID ,
                                          'statues':false,




                                        });


                                      },

                                      ),

                                      IconButton(icon: Icon(Icons.delete_outline), onPressed: () async{
                                        await  Firestore.instance
                                            .collection('groups')
                                            .document(widget.documentID)
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
