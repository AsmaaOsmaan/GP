import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';

import '../../provider_data.dart';

class PageUpdatePost extends StatefulWidget {
  final String pageId;
  final String postId;

  PageUpdatePost(this.pageId, this.postId, {Key key}) : super(key: key);
  @override
  _PageUpdatePostState createState() => _PageUpdatePostState();
}

class _PageUpdatePostState extends State<PageUpdatePost> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _postContentController = TextEditingController();
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
    _postContentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Update Your Post ',
          style: TextStyle(fontSize: 23, color: Colors.purple.shade800),
        ),
      ),
      body:
      Form(
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

                }),
            SizedBox(width: MediaQuery.of(context).size.width * 2 / 60),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width *1/ 3,
                    child: TextFormField(
                      controller: _postContentController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write Post...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                          )),
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
                'Update',
                style: TextStyle(color: Color(0xFF9656A1), fontSize: 18),
              ),
              onPressed: ()
              // async

              async {
                if (_formKey.currentState.validate()) {
                  String imageUrl1 = await uploadImage(_image1);
                  final auth = Provider.of<ProviderData>(context);
                  Firestore.instance
                      .collection('pages')
                      .document(widget.pageId)
                      .collection('post')
                      .document(widget.postId)
                      .updateData({
                    'postData': _postContentController.text,
                    'post_image': imageUrl1,
                    'userid': auth.userData.id,
                    'username':auth.userData.name,
                    'timestamp': DateTime.now().toString(),
                  });
                  _postContentController.text="";
                  Toast.show("your post update Successfully", context);

                  /*  Firestore.instance.collection('groups')
        .document(widget.documentID)
        .collection('post')
        .document((widget.postId)).get().then(
    (DocumentSnapshot result) async {
                          Firestore.instance
                              .collection('ActivtyLog')
                              .document(auth.userData.ParentID)
                              .collection('ActivtyLogitem')
                              .document()
                              .updateData({
                            'post_content': _postContentController.text,
                            'post_image': imageUrl1,
                            'userid': auth.userData.id,
                            'username':auth.userData.name,
                            'type': 'updatepost',
                            'profile_image':auth.userData.profileImage,
                            'post_content' : result['post_content'],
                            'timestamp':  DateTime.now().toString(),
                          });});*/
                }
              },
            ),
          ],
        ),
      ),

    );
  }


  Future<String> uploadImage( File image ) async{
    String name = Random().nextInt(1000).toString() + '_group';
    final StorageReference storageReference = FirebaseStorage().ref().child( name );
    final StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot response = await uploadTask.onComplete;
    String url = await response.ref.getDownloadURL();
    return url;
  }

}
