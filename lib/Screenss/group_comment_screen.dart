import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/group/update_comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../provider_data.dart';

class GroupComment extends StatefulWidget {
  final String postId;
  final String documentID;

  GroupComment(this.documentID, this.postId,{Key key}) : super(key: key);
  @override
  _GroupCommentState createState() => _GroupCommentState();
}

class _GroupCommentState extends State<GroupComment> {
  static final GlobalKey<FormFieldState<String>> _commentController =
  GlobalKey<FormFieldState<String>>();
  String userId;

  void _updateComment(context, String postId, String commentId) {
    showModalBottomSheet(

      context: context,
      builder: (BuildContext builder) {
        return
          UpdateComment(widget.documentID, widget.postId,commentId);


      },
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.964,
      child: Scaffold(
        backgroundColor: Colors.white, //Color(0xFFcccccc),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: FlatButton(
              onPressed: () {},
              child: Row(
                children: <Widget>[
                  Text(
                    '30K',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 3,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        size: 25,
                      ),
                      color: Colors.black54,
                      onPressed: () {}),
                ],
              )),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                  future: Firestore.instance
                      .collection('groups')
                      .document(widget.documentID)
                      .collection('post')
                      .document(widget.postId)
                      .collection('comment')
                      .getDocuments(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Text('Loading...');
                      default:
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[

                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: FlatButton(
                                          child: CircleAvatar(
                                            backgroundImage: ExactAssetImage(
                                                'images/profile_page.jpg'),
                                            radius: 20,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                      Expanded(
                                        child: Card(
                                          /*Container(
                                            padding:  EdgeInsets.all(5),
                                            margin:EdgeInsets.only(top:5) ,
                                            height: 100.0,
                                            width: 100.0,
                                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10.0)),*/

                                          color: Colors.grey.shade100,
                                          margin: EdgeInsets.all(5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Column(

                                                children: <Widget>[

                                                  FlatButton(
                                                    child: Text(
                                                      snapshot.data.documents[index]
                                                      ['username'],
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.2,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    onPressed: () {},
                                                  ),],

                                              ),
                                              Text(
                                                snapshot.data.documents[index]
                                                ['comment_content'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.2,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),



                                            ],
                                          ),
                                        ),
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          final auth = Provider.of<ProviderData>(context);

                                          if( (snapshot.data.documents[index]['userid']) ==(auth.userData.id)) {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    height: 200,
                                                    child: Wrap(
                                                      children: <Widget>[
                                                        FlatButton(
                                                          onPressed: ()  {

                                                            Firestore.instance
                                                                .collection('groups')
                                                                .document(widget.documentID)
                                                                .collection('post')
                                                                .document(widget.postId)
                                                                .collection('comment')
                                                                .document(snapshot
                                                                .data
                                                                .documents[index]
                                                                .documentID)
                                                                .delete();
                                                            Firestore.instance
                                                                .collection('groups')
                                                                .document(widget.documentID)
                                                                .collection('post')
                                                                .document(widget.postId)
                                                                .updateData({
                                                              'NumberOfComments': FieldValue.increment(-1) ,
                                                            });
                                                          },
                                                          child: ListTile(
                                                            title: Text(
                                                              'Delete Comment',
                                                              style: TextStyle(
                                                                  color: Colors.grey),
                                                            ),
                                                            leading: Icon(
                                                              Icons.delete,
                                                              color: Color(0xFF9656A1),
                                                            ),
                                                          ),
                                                        ),
                                                        FlatButton(
                                                          onPressed: () => _updateComment(
                                                              context,
                                                              snapshot.data.documents[index]
                                                                  .documentID, snapshot.data.documents[index]
                                                              .documentID),
                                                          child: ListTile(
                                                            title: Text(
                                                              'Edit Comment',
                                                              style: TextStyle(
                                                                  color: Colors.grey),
                                                            ),
                                                            leading: Icon(
                                                              Icons.edit,
                                                              color: Color(0xFF9656A1),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          }
                                          else{
                                            Container();
                                          }

                                        },
                                        icon: Icon(Icons.more_vert),

                                      ),
                                    ],
                                  ),

                                  FlatButton(
                                    child: Text(
                                      'Like',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        height: 1.2,
                                        color: Colors.purple.shade500,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),

                                ],
                              ),
                            );

                          },
                          //  itemCount: 20,
                        );
                    }
                  }),
            ),
            Divider(height: 2.0),
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
                          .add({
                        'comment_content':
                        _commentController.currentState.value,
                        'postId':widget.postId,
                        'userid': auth.userData.id,
                        'username':auth.userData.name,
                        'ParentId':auth.userData.ParentID,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      Firestore.instance
                          .collection('groups')
                          .document(widget.documentID)
                          .collection('post')
                          .document(widget.postId)
                          .updateData({
                        'NumberOfComments': FieldValue.increment(1) ,
                      });
                      Firestore.instance.collection('groups')
                          .document(widget.documentID)
                          .collection('post')
                          .document((widget.postId)).get().then(
                              (DocumentSnapshot result) async {
                            Firestore.instance
                                .collection('ActivtyLog')
                                .document(auth.userData.ParentID)
                                .collection('ActivtyLogitem')
                                .document()
                                .setData({
                              'commentData':
                              _commentController.currentState.value,
                              'postId':widget.postId,
                              'userid': auth.userData.id,
                              'postData' : result['postData'],
                              'imagePost':result["post_image"],
                              'username': auth.userData.name,
                              'ParentId':auth.userData.ParentID,
                              'userProfileImg':auth.userData.profileImage,
                              'type': 'comment',
                              'timestamp': Timestamp.fromDate(DateTime.now()),  });});
                      Firestore.instance.collection('groups')
                          .document(widget.documentID)
                          .collection('post').document(widget.postId).get().then(
                              (DocumentSnapshot result) async {
                            Firestore.instance
                                .collection('Notification')
                                .document(result["userid"])
                                .collection('Notificationitem')
                                .document().setData({
                              'commentData':
                              _commentController.currentState.value,
                              'postId':widget.postId,
                             // 'postData' : result['postData'],
                             // 'imagePost':result["post_image"],
                              'OwnerId':result["userid"],
                              'username':auth.userData.name,
                              'userid':auth.userData.id,
                              'ParentId':auth.userData.ParentID,
                              'userProfileImg':auth.userData.profileImage,
                              'type': 'comment',
                              'timestamp': Timestamp.fromDate(DateTime.now()),                            }
                            );
                          });
                    }
                    Toast.show("your comment added Successfully", context);

                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}