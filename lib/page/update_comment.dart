import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter_shop/child/Screens/profile_screen.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';

class UpdateComment extends StatefulWidget {
  final String documentID;
  final String postId;
  final String commentId;
  UpdateComment(this.documentID, this.postId,this.commentId, {Key key}) : super(key: key);
  @override
  _UpdateCommentState createState() => _UpdateCommentState();
}

class _UpdateCommentState extends State<UpdateComment> {
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

                    Firestore.instance
                        .collection('groups')
                        .document(widget.documentID)
                        .collection('post')
                        .document(widget.postId)
                        .collection('comment')
                        .document(widget.commentId)
                        .updateData({
                      'comment_content':
                      _commentController.currentState.value,
                      'postId':widget.postId,
                      'userid': auth.userData.id,
                      'username':auth.userData.name,
                      'timestamp': FieldValue.serverTimestamp(),
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