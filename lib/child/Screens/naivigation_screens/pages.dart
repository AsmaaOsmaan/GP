import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/authentication/dialogBox.dart';
import 'package:flutter_shop/page/admin.dart';
import 'package:flutter_shop/page/createpage_screen.dart';
import 'package:flutter_shop/page/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider_data.dart';

class Pages extends StatefulWidget {
  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  DialogBox dialogBox = new DialogBox();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'pages ',
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
                MaterialPageRoute(builder: (context) => CreatePage()),
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
            _pages(),
          ],
        ),
      ),
    );
  }

  Widget _pages() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('pages').snapshots(),
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
                    padding: EdgeInsets.all(
                        (MediaQuery.of(context).size.width * 1 / 25)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 1 / 6,
                      width: MediaQuery.of(context).size.width,
                      child: Material(
                          elevation: 14,
                          borderRadius: BorderRadius.circular(8.0),
                          shadowColor: Colors.purple,
                          child: Padding(
                            padding: EdgeInsets.all(
                                (MediaQuery.of(context).size.width * 1 / 30)),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      document['pageName'],
                                      style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      final auth = Provider.of<ProviderData>(
                                          context,
                                          listen: false);
                                      Firestore.instance
                                          .collection("pages")
                                          .document(document.documentID)
                                          .get()
                                          .then(
                                              (DocumentSnapshot result) async {
                                        if (result["admin"].toString() ==
                                            auth.userData.id) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Admin(document.documentID)),
                                          );
                                        } else {
                                          Firestore.instance
                                              .collection('User')
                                              .document(auth.userData.id)
                                              .collection('pages')
                                              .document(document.documentID)
                                              .get()
                                              .then((DocumentSnapshot doc) {
                                            if (!doc.exists) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PageScreen(document
                                                            .documentID)),
                                              );
                                            } else if (doc != null) {
                                              if (doc['statues'] == true) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Pages()));
                                                dialogBox.information(
                                                    context,
                                                    "Block ",
                                                    "you are Blocked from this page ");
                                              } else if (doc['statues'] ==
                                                  false) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PageScreen(document
                                                              .documentID)),
                                                );
                                              }
                                            }
                                          });
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    document['page_catogory'],
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  /*IconButton(
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      await Firestore.instance
                                          .collection('pages')
                                          .document(document.documentID)
                                          .collection('post')
                                          .document(document.documentID)
                                          .collection('comment')
                                          .document(document.documentID)
                                          .collection('like')
                                          .getDocuments()
                                          .then((snapshot) {
                                        for (DocumentSnapshot ds
                                            in snapshot.documents) {
                                          ds.reference.delete();
                                        }
                                      });

                                      await Firestore.instance
                                          .collection('pages')
                                          .document(document.documentID)
                                          .delete();
                                    },
                                  ),*/
                                ],
                              ),
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
