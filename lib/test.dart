import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
class tesst extends StatefulWidget {
  @override
  _tesstState createState() => _tesstState();
}

class _tesstState extends State<tesst> {
  @override
  Widget build(BuildContext context) {
    return Container(

        child: RaisedButton(
          child: Text('Save Proudct',style: TextStyle(color: Colors.black87),),
          onPressed: (){
            tes();
          },
        ),
    );
  }


Widget tes(){
 // document('1')->parentID (first)
  //document('1')->childID or user how react

  Firestore.instance.collection('ActivtyLog').document('jeffd23').collection('ActivtyLogitem').document('5arJBmgyMNlJgLKyvldS').setData({
  'type' : 'like',
  //  //currentuser.userid
  'userid': "5arJBmgyMNlJgLKyvldS" ,
    'username':'yousef',

 }).then((data) {
    setState(() {
      print('ok');
    });
  });



  /*Firestore.instance.collection('users').document().setData({
    'nickname': 'eman',
    'photoUrl':'https://firebasestorage.googleapis.com/v0/b/graduation-project-30cb8.appspot.com/o/541_group?alt=media&token=91c67723-723f-42a9-9364-0ccd22480987',
    'id': 'LCPM3Ugm4ViwrrJ1ecin'  ,
    'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
    'chattingWith': null
  });*/
}

      }


