import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/page/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider_data.dart';
class JoinGroupScreen extends StatefulWidget {
  final String documentID;

  JoinGroupScreen(this.documentID, {Key key}) : super(key: key);
  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  bool pressed = false;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: Container(
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.black),
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 1 / 26,
              left: MediaQuery.of(context).size.width * 1 / 26),
          decoration: BoxDecoration(
              color: Color(0xFFcccccc),
              borderRadius: BorderRadius.all(Radius.circular(22.0))),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _coverGroup(),
          _profileGroup(),

        ],
      ),
    );
  }
  Widget _coverGroup() {
    return FutureBuilder(
        future: Firestore.instance
            .collection('groups')
            .document(widget.documentID)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(snapshot.data['cover_photo']),
                  ),
                ),
              );
          }
        });
  }
  Widget _profileGroup() {
    final auth = Provider.of<ProviderData>(context);
    return FutureBuilder(
        future: Firestore.instance
            .collection('groups')
            .document(widget.documentID)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.purple.shade200,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Group By',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey.shade900),
                          ),
                          Text(
                            snapshot.data['username'],
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      snapshot.data['groupName'],
                      style:
                      TextStyle(fontSize: 25, color: Colors.grey.shade900),
                    ),



                    RaisedButton(
                        child: pressed ? Text(
                          'Cancel Request',
                          style: TextStyle(color: Color(0xFF9656A1)),
                        ):Text(
                          'Join Group',
                          style: TextStyle(color: Color(0xFF9656A1)),
                        ),
                        onPressed: () async{
                          setState(() {
                            pressed = !pressed;
                          });
                          if (pressed) {

                            DocumentReference documentReference =
                            Firestore.instance
                                .collection('groups')
                                .document(widget.documentID)
                                .collection('requests')
                                .document(auth.userData.id);
                            documentReference.setData({
                              'requestId':documentReference.documentID,
                              'userid': auth.userData.id,
                              'username':auth.userData.name,
                              'timestamp': Timestamp.fromDate(DateTime.now()),
                            });
                        Firestore.instance.collection('groups')
                        .document(widget.documentID)
                        .get().then(
                        (DocumentSnapshot result) async {
                            Firestore.instance
                                .collection('ActivtyLog')
                                .document(auth.userData.ParentID)
                                .collection('ActivtyLogitem')
                                .document()
                                .setData({
                              'userid': auth.userData.id,
                              'username':auth.userData.name,
                              'ParentId':auth.userData.ParentID,
                              'userProfileImg':auth.userData.profileImage,
                              'groupName':result['groupName'],
                              'groupID': result['groupID'],
                              'timestamp': Timestamp.fromDate(DateTime.now()),
                              'type':'joinGroup',

                            });
    });
                          }
                          else {
    Firestore.instance.collection('groups')
        .document(widget.documentID)
        .collection('requests')
        .document((auth.userData.id)).get().then(
    (DocumentSnapshot result) async {
                            Firestore.instance
                                .collection('groups')
                                .document(widget.documentID)
                                .collection('requests')
                                .document(result['requestId'])
                                .delete();
    });
                          }

                        }


                    ),
                  ],
                ),
              );
          }
        });
    /*  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('groups').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return  ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.purple.shade200,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Group By',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey.shade900),
                            ),
                            FlatButton(
                              onPressed: () => _groupByPressed(),
                              child: Text(
                                'Mbc3',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        snapshot.data.documents[index]['group_name'],
                        style:
                        TextStyle(fontSize: 25, color: Colors.grey.shade900),
                      ),



                      RaisedButton(
                          child: pressed ? Text(
                            'Cancel Request',
                            style: TextStyle(color: Color(0xFF9656A1)),
                          ):Text(
                            'Join Group',
                            style: TextStyle(color: Color(0xFF9656A1)),
                          ),
                          onPressed: () async{
                            setState(() {
                              pressed = !pressed;
                            });
                            if (pressed) {
                              final auth = Provider.of<ProviderData>(context);
                              Firestore.instance
                                  .collection('groups')
                                  .document(widget.documentID)
                                  .collection('requests')
                                  .document()
                                  .setData({
                                'userid': auth.userData.id,
                                'username':auth.userData.name,
                                'timestamp': Timestamp.fromDate(DateTime.now()),
                              });


                            }
                            else {
                              Firestore.instance
                                  .collection('groups')
                                  .document(widget.documentID)
                                  .collection('requests')
                                  .document(snapshot
                                  .data
                                  .documents[index]
                                  .documentID)
                                  .delete();

                            }

                          }


                      ),
                    ],
                  ),
                );
              }
            );
        }
      },
    );*/
  }
}