import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/group/admin_group_screen.dart';
import 'package:flutter_shop/group/creategroup_screen.dart';
import 'package:flutter_shop/group/group_screen.dart';
import 'package:flutter_shop/group/group_tabs/about.dart';
import 'package:flutter_shop/group/invite_member.dart';
import 'package:flutter_shop/group/join_group_screen.dart';
import 'package:flutter_shop/group/updategroup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop/authentication/dialogBox.dart';
//import '../../../provider_data.dart';

class Groups extends StatefulWidget {

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  String get requestID => null;
  DialogBox dialogBox = new DialogBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groups ',
          style: TextStyle(
            fontSize: 23,
            color: Colors.purple.shade800,
          ),
        ),
        backgroundColor: Colors.grey.shade300,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              size: 35,
              color: Colors.purple.shade800,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroup()),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/wallpaper.jpg'),
              fit: BoxFit.cover,
            )),
        child: Stack(
          children: <Widget>[
            _groups(),
          ],
        ),
      ),

    );
  }
  Widget  _groups() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('groups').snapshots(),
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
                              children:<Widget>[ Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[FlatButton(
                                  child: Text(document['groupName'],
                                    style: TextStyle(
                                      color: Colors.grey.shade900,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),),

                                  onPressed: () {

                                    final auth = Provider.of<ProviderData>(context);
                                    /*  Firestore.instance
                                        .collection('User')
                                        .document(auth.userData.id)
                                        .collection('groups')
                                        .document(document.documentID)
                                        .get().then((DocumentSnapshot doc){
                                      if (doc['statues']==false) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupScreen(document.documentID)), );}
                                      else{
                                        Firestore.instance
                                            .collection('User')
                                            .document(auth.userData.id)
                                            .collection('groups')
                                            .document(document.documentID)
                                            .get().then((DocumentSnapshot doc){
                                          if (doc['statues']==true) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Groups()));
                                            dialogBox.information(  context, "Block ", "you are Blocked from this Group."); }

                                          else{
                                            Firestore.instance
                                                .collection("groups")
                                                .document(document.documentID)
                                                .get()
                                                .then((DocumentSnapshot result)async{
                                              if (result["userid"].toString() ==
                                                  auth.userData.id) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminGroupScreen(document.documentID)),
                                                );
                                              }

                                              else{
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          JoinGroupScreen(document.documentID)),
                                                );

                                              }
                                            });

                                          }



                                        });

                                      }
                                    });*/
                                    Firestore.instance
                                        .collection("groups")
                                        .document(document.documentID)
                                        .get()
                                        .then(
                                            (DocumentSnapshot result) async {
                                          if (result["userid"].toString() ==
                                              auth.userData.id) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminGroupScreen(document.documentID)),
                                            );
                                          }

                                          else{
                                            Firestore.instance
                                                .collection('User')
                                                .document(auth.userData.id)
                                                .collection('groups')
                                                .document(document.documentID)
                                                .get().then((DocumentSnapshot doc){
                                                 if (!doc.exists){

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                     builder: (context) => JoinGroupScreen( document.documentID),

                                                  ),);
                                                print("asmaaaaaaaaa");
                                                //print("doc['groupid']${doc['groupid']}");
                                              }
                                             else if(doc!=null)   {
                                                   if (doc['statues']==true) {
                                                     Navigator.pushReplacement(
                                                         context,
                                                         MaterialPageRoute(
                                                             builder: (context) =>
                                                                 Groups()));
                                                     dialogBox.information(  context, "Block ", "you are Blocked from this Group."); }


                                                   else if (doc['statues']==false) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              GroupScreen(document.documentID)), );}


                                                 }



                                            });

                                            /*     Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => JoinGroupScreen( document.documentID),
                                                        // builder: (context) => GroupScreen( ),
                                                      ),);*/

                                          }

                                        });

                                  },
                                ),],

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
