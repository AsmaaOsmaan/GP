import 'package:flutter_shop/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
class ListMembersGroup extends StatefulWidget {
  final String documentID;
  ListMembersGroup(this.documentID, {Key key}) : super(key: key);
  @override
  _ListMembersGroupState createState() => _ListMembersGroupState();
}

class _ListMembersGroupState extends State<ListMembersGroup> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Members ',
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
              image: AssetImage('images/butterfly.jpg'),
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
      stream: Firestore.instance.collection('groups').document(widget.documentID).collection('members').snapshots(),
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
                              children:<Widget>[  Text(document['username'].toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),),



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
