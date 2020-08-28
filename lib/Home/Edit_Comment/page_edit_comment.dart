import 'package:flutter/material.dart';
import 'package:flutter_shop/child/Screens/home_tabs/home.dart';
import 'dart:io';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';

import '../../provider_data.dart';

class PageUpdateComment extends StatefulWidget {
  final String pageID;
  final String postId;
  final String commentId;
  PageUpdateComment(this.pageID, this.postId,this.commentId, {Key key}) : super(key: key);
  @override
  _PageUpdateCommentState createState() => _PageUpdateCommentState();
}

class _PageUpdateCommentState extends State<PageUpdateComment> {

  static final GlobalKey<FormFieldState<String>> _commentController =
  GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Update Your Comment ',
          style: TextStyle(fontSize: 23, color: Colors.purple.shade800),
        ),
      ),
      body:
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width * 1 / 26)),
                  child: TextFormField(
                    key: _commentController,
                    decoration: InputDecoration.collapsed(
                      hintText: "Type a message",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'message is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.send,
                  color: Colors.deepPurple,
                ),
                disabledColor: Colors.grey,
                onPressed: () async {
                  if (_commentController.currentState.value
                      .trim()
                      .isNotEmpty) {

                    final auth = Provider.of<ProviderData>(context);

                    Firestore.instance.collection('pages')
                        .document(widget.pageID)
                        .collection('post')
                        .document((widget.postId)).get().then(
                            (DocumentSnapshot result) async {
                          Firestore.instance
                              .collection('pages')
                              .document(widget.pageID)
                              .collection('post')
                              .document(widget.postId)
                              .collection('comment')
                              .document(widget.commentId)
                              .updateData({
                            'commentData':
                            _commentController.currentState.value,
                            'postId':widget.postId,
                            'userid': auth.userData.id,
                            'postData' : result['postData'],
                            'username': auth.userData.name,
                            'ParentId':auth.userData.ParentID,
                            'type': 'comment',
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                        });
                    Toast.show("your comment update Successfully", context);

                    /* Firestore.instance.collection('groups')
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
                            'comment_content':
                            _commentController.currentState.value,
                            'postid':widget.postId,
                            'userid': auth.userData.id,
                            'username':auth.userData.name,
                            'profile_image':auth.userData.profileImage,
                            'type': 'updatecomment',
                            'post_content' : result['post_content'],
                            'timestamp': Timestamp.fromDate(DateTime.now()),                      }); });*/
                  }
                },
              ),
            ],
          ),
        ],

      ),

    );
  }




}
