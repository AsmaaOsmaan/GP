import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditComment extends StatefulWidget {
  final String documentID;
  final String postId;
  final String commentId;
  EditComment(this.documentID, this.postId, this.commentId, {Key key})
      : super(key: key);
  @override
  _EditCommentState createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
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
      body: Row(
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
              if (_commentController.currentState.value.trim().isNotEmpty) {
                final auth = Provider.of<ProviderData>(context);
                Firestore.instance
                    .collection('pages')
                    .document(widget.documentID)
                    .collection('post')
                    .document(widget.postId)
                    .collection('comment')
                    .document(widget.commentId)
                    .updateData({
                  'comment_content': _commentController.currentState.value,
                  'userid': auth.userData.id,
                  'username': auth.userData.name,
                  'timestamp': Timestamp.fromDate(DateTime.now()),
                });
                Firestore.instance
                    .collection('ActivtyLog')
                    .document(auth.userData.ParentID)
                    .collection('ActivtyLogitem')
                    .add({
                  'comment_content': _commentController.currentState.value,
                  'userid': auth.userData.id,
                  'username': auth.userData.name,
                  'type': 'comment',
                  'timestamp': Timestamp.fromDate(DateTime.now()),
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
