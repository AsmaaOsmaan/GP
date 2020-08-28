import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider_data.dart';

class Edit extends StatefulWidget {
  final String documentID;

  Edit(this.documentID, {Key key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController __PageNameController = TextEditingController();
  TextEditingController __PageCatogoryController = TextEditingController();
  File _image1, _image2;
  String imageUrl1, imageUrl2;

  Future getImage(requiredImage) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      requiredImage = image;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    __PageNameController.dispose();
    __PageCatogoryController.dispose();
  }

  _backPressed() {
    setState(() {
      //  Navigator.push(
      //    context, MaterialPageRoute(builder: (context) => PageScreen(document.documentID)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Edit Page ',
          style: TextStyle(fontSize: 23, color: Colors.purple.shade800),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 1 / 26),
              child: Form(
                  child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'What Do You Want To Name This Page ?',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        color: Colors.grey.shade700),
                  ),
                  TextFormField(
                    controller: __PageNameController,
                    decoration: InputDecoration(
                      hintText: 'Name Page ',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'What Category Best Describes This Page ?',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        color: Colors.grey.shade700),
                  ),
                  TextFormField(
                    controller: __PageCatogoryController,
                    decoration: InputDecoration(
                      hintText: 'Category Page ',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Category is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Add Profile Picture and Cover Photo To This Page',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        color: Colors.grey.shade700),
                    textAlign: TextAlign.left,
                  ),
                  Column(
                    children: <Widget>[
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
                            Text('Add Profile Picture',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey.shade500,
                                )),
                          ],
                        ),
                        onPressed: () async {
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            _image1 = image;
                          });
                        },
                      ),
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
                        onPressed: () async {
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            _image2 = image;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String imageUrl1 = await uploadImage(_image1);
                        String imageUrl2 = await uploadImage(_image2);
                        final auth =
                            Provider.of<ProviderData>(context, listen: false);

                        Firestore.instance
                            .collection('pages')
                            .document(widget.documentID)
                            .updateData({
                          'page_name': __PageNameController.text,
                          'page_catogory': __PageCatogoryController.text,
                          'profile_Picture': imageUrl1,
                          'cover_Photo': imageUrl2,
                          'userid': auth.userData.id,
                          'username': auth.userData.name,
                          'admin': auth.userData.id,
                        });

                        Firestore.instance
                            .collection('ActivtyLog')
                            .document(auth.userData.ParentID)
                            .collection('ActivtyLogitem')
                            .document()
                            .updateData({
                          'ParentID': auth.userData.ParentID,
                          'page_name': __PageNameController.text,
                          'page_catogory': __PageCatogoryController.text,
                          'profile_Picture': imageUrl1,
                          'cover_Photo': imageUrl2,
                          'userid': auth.userData.id,
                          'username': auth.userData.name,
                          'type': 'page',
                          'timetamp': DateTime.now().toIso8601String(),
                        });
                      }
                    },
                    /*
                          child: Text(
                            'Create page',
                            style: TextStyle(color: Color(0xFF9656A1)),
                          ),
                        ); }},

     */

                    child: Text(
                      'Edit Page',
                      style: TextStyle(color: Color(0xFF9656A1)),
                    ),
                  )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> uploadImage(File image) async {
    String name = Random().nextInt(1000).toString() + '_page';
    final StorageReference storageReference =
        FirebaseStorage().ref().child(name);
    final StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot response = await uploadTask.onComplete;
    String url = await response.ref.getDownloadURL();
    return url;
  }
}
