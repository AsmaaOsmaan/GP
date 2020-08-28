import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_shop/child/Screens/profile_screen.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class EditPost extends StatefulWidget {
  final String documentID;
  final String postId;
  EditPost(this.documentID, this.postId, {Key key}) : super(key: key);
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _postContentController = TextEditingController();
  File _image1;
  String imageurl;
  Future getImage(File requiredImage) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      requiredImage = image;
    });
  }

  int groupValue;
  @override
  void dispose() {
    super.dispose();
    _postContentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Edit Your Post ',
          style: TextStyle(fontSize: 23, color: Colors.purple.shade800),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Row(
          children: <Widget>[
            InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width * 1 / 6,
                  height: MediaQuery.of(context).size.width * 1 / 6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: ExactAssetImage('images/profile_page.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(widget.documentID)),
                  );
                }),
            SizedBox(width: MediaQuery.of(context).size.width * 2 / 60),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
              padding: EdgeInsets.only(
                  right: (MediaQuery.of(context).size.width * 1 / 500),
                  left: (MediaQuery.of(context).size.width * 1 / 500)),
              decoration: BoxDecoration(
                  color: Color(0xFFcccccc),
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _postContentController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write Post...",
                        hintStyle: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            fontStyle: FontStyle.italic),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Post is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 28,
                    ),
                    color: Colors.grey.shade800,
                    onPressed: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      setState(() {
                        _image1 = image;
                      });
                    },
                  ),
                ],
              ),
            ),
            FlatButton(
              child: Text(
                'Edit',
                style: TextStyle(color: Color(0xFF9656A1), fontSize: 18),
              ),
              onPressed: () async {
                final auth = Provider.of<ProviderData>(context, listen: false);

                //String imageUrl1 = await uploadImage(_image1);
                Firestore.instance
                    .collection('pages')
                    .document(widget.documentID)
                    .collection('post')
                    .document(widget.postId)
                    .updateData({
                  'postData': _postContentController.text,
                  //'post_image': imageUrl1,
                  'userid': auth.userData.id,
                  'username': auth.userData.name,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                Firestore.instance
                    .collection('ActivtyLog')
                    .document(auth.userData.ParentID)
                    .collection('ActivtyLogitem')
                    .document()
                    .updateData({
                  'ParentID': auth.userData.ParentID,
                  // 'comment_content': _commentController.currentState.value,
                  'postData': _postContentController.text,
                  //'post_image': imageUrl1,
                  'userid': auth.userData.id,
                  'postId': 'dfre',
                  'username': auth.userData.name,
                  'type': 'post',
                  'timestamp': FieldValue.serverTimestamp(),
                });
                _postContentController.text = "";
                Toast.show("your post update Successfully", context);

              },
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
