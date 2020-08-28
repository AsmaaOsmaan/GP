import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AllProudct extends StatefulWidget {
  @override
  _AllProudctState createState() => _AllProudctState();
}

class _AllProudctState extends State<AllProudct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' My Proudct'),
      ),
      body:  _draw(),
    );
  }
  Widget _draw(){


    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('proudcts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return Card(
                  child: new Column(
                    children: <Widget>[
                  ListTile(
                  title: new Text(document['title'],style: TextStyle(color: Colors.indigo,fontSize: 20)),
                  subtitle: new Text(document['description'],style: TextStyle(color: Colors.black87,fontSize: 15)),
                  ),
                   Container(



                      width: 320.0,
                       height: 100.0,
                     color: Colors.indigo,
                   ) ,
                   Container(
                     color: Colors.grey,
                     child: Center(

                       child: Row(

                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.all(16.0),
                             child: Text(document['price'],style: TextStyle(color: Colors.white,fontSize: 20),),
                           ),
                       IconButton(icon: Icon(Icons.delete,color: Colors.red,),
                         onPressed: (){
                           Firestore.instance.collection('proudcts').document(document.documentID).delete();
                         },)
                         ],
                       ),
                     ),
                   ),
                      Divider(
                          color: Colors.black87,
                          height: 10.0,
                      )

                    ],

                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
