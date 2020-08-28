import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../main.dart';

import '../user_data.dart';
import '../user_data.dart';
import 'group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';



class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();

}

class _CreateGroupState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _groupNameController = TextEditingController();
  File _image1;
  String imageurl;
  Future getImage( File requiredImage ) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery );

    setState(() {
      requiredImage = image;
    });
  }
  int groupValue;
  @override
  void dispose() {
    super.dispose();
    _groupNameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(

        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Create Your Group ',
          style: TextStyle(fontSize: 23, color: Colors.purple.shade800),
        ),
      ),
      body:
      Container(

    decoration:BoxDecoration(
    image: DecorationImage(
    image: AssetImage('images/kids3456.webp'),
    fit: BoxFit.cover,
    )) ,

        child: Form(

          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:  EdgeInsets.all(MediaQuery.of(context).size.width*1/26),
                child: Form(
                    child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'What Do You Want To Name This Group ?',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          color: Colors.grey.shade700),
                    ),
                    TextFormField(
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        hintText: 'Name Group ',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'name is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(

                          'Add Cover Photo To This Group',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              color: Colors.grey.shade700),
                          textAlign: TextAlign.left,
                        ),

                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 18,
                            ),
                           FlatButton(
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        size: 28,
                                      ),
                                      color: Colors.grey.shade800,
                                      onPressed: () {}),
                                  Text('Add Cover Photo',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey.shade500,
                                      )),
                                ],
                              ),
                              onPressed: () async{
                                var image = await ImagePicker.pickImage(source: ImageSource.gallery );
                                setState(() {
                                  _image1 = image;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    RaisedButton(
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                          String imageUrl1 = await uploadImage(_image1);
                          final auth = Provider.of<ProviderData>(context);
                          DocumentReference documentReference =  Firestore.instance
                              .collection("groups")
                              .document();
                          documentReference.setData({
                            'groupName': _groupNameController.text,
                            'cover_photo' : imageUrl1,
                            'userid': auth.userData.id,
                            'username':auth.userData.name,
                            'timestamp': Timestamp.fromDate(DateTime.now()),
                            'groupID': documentReference.documentID,
                            'NumberOfMembers': 0 ,

                          });
                          Firestore.instance
                              .collection('ActivtyLog')
                              .document(auth.userData.ParentID)
                              .collection('ActivtyLogitem')
                              .document()
                              .setData({
                            'groupName': _groupNameController.text,
                            'cover_photo' : imageUrl1,
                            'userid': auth.userData.id,
                            'username':auth.userData.name,
                            'ParentId':auth.userData.ParentID,
                            'userProfileImg':auth.userData.profileImage,
                            'parentId':auth.userData.ParentID,
                            'type':'createGroup',
                            'timestamp': Timestamp.fromDate(DateTime.now()),
                            'groupID': documentReference.documentID,

                          });
                          Firestore.instance
                              .collection('User')
                              .document(auth.userData.id )
                              .collection('groups')
                              .document(documentReference.documentID )
                              .setData({
                            'groupid': documentReference.documentID ,
                            'statues':false,




                          });
                          _groupNameController.text="";
                          imageUrl1="";

                        }

                      },
                      child: Text(
                        'Create Group',
                        style: TextStyle(color: Color(0xFF9656A1)),
                      ),
                )

                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

 /* void something(int e) {
    setState(() {
      if (e == 1) {
        groupValue = 1;
      } else if (e == 2) {
        groupValue = 2;
      }
    });
  }*/
  Future<String> uploadImage( File image ) async{
    String name = Random().nextInt(1000).toString() + '_group';
    final StorageReference storageReference = FirebaseStorage().ref().child( name );
    final StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot response = await uploadTask.onComplete;
    String url = await response.ref.getDownloadURL();
    return url;
  }

}
