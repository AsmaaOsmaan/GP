import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/Screenss/comment_screenPages.dart';
import 'package:flutter_shop/child/Screens/profile_screen.dart';
//import 'package:flutter_shop/page/comment_screenPages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider_data.dart';
import '../edit_post.dart';

//import '../comment_screen.dart';

class Posts extends StatefulWidget {
  final String documentID;

  Posts(this.documentID, {Key key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  TextEditingController _postContentController = TextEditingController();
  bool isLiked = false;
  int likecount = 0;

  int commentcount = 0;
  void _commentNew(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return pageComment(widget.documentID, postId);
      },
      isScrollControlled: true,
    );
  }

  void _EditPost(context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return EditPost(widget.documentID, postId);
      },
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, position) {
        return Card(
          child: Column(
            children: <Widget>[
              _post(),
              //  _cardHeader(),
              //_cardBody(),
              //_drawLine(),
              //_cardFooter(),
            ],
          ),
        );
      },

      // itemCount: 20,
    );
  }

  Widget _post() {
    final auth = Provider.of<ProviderData>(context, listen: false);

    return StreamBuilder(
        stream: Firestore.instance
            .collection('pages')
            .document(widget.documentID)
            .collection('post')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return InkWell(
                onTap: () {
                  final auth =
                  Provider.of<ProviderData>(context, listen: false);

                  if (auth.userData.ParentID == 'parent') {
                  } else
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(auth.userData.id)),
                    );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            InkWell(
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                1 /
                                                26),
                                        child: CircleAvatar(
                                          backgroundImage: ExactAssetImage(
                                              'images/profile_page.jpg'),
                                          radius: 25,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                snapshot.data.documents[index]
                                                ['username'],
                                                style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    1 /
                                                    7,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          /*Text(
                                        snapshot.data.documents[index]
                                            ['timestamp'],
                                        style: TextStyle(color: Colors.grey),
                                      ),*/
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: 200,
                                                  child: Wrap(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: () async {
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                              'pages')
                                                              .document(widget
                                                              .documentID)
                                                              .collection(
                                                              'post')
                                                              .document(snapshot
                                                              .data
                                                              .documents[
                                                          index]
                                                              .documentID)
                                                              .collection(
                                                              'comment')
                                                              .document(snapshot
                                                              .data
                                                              .documents[
                                                          index]
                                                              .documentID)
                                                              .collection(
                                                              'like')
                                                              .getDocuments()
                                                              .then((snapshot) {
                                                            for (DocumentSnapshot ds
                                                            in snapshot
                                                                .documents) {
                                                              ds.reference
                                                                  .delete();
                                                            }
                                                          });
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                              'pages')
                                                              .document(widget
                                                              .documentID)
                                                              .collection(
                                                              'post')
                                                              .document(snapshot
                                                              .data
                                                              .documents[
                                                          index]
                                                              .documentID)
                                                              .delete();
                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            'Delete Post',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          leading: Icon(
                                                            Icons.delete,
                                                            color: Color(
                                                                0xFF9656A1),
                                                          ),
                                                        ),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () =>
                                                            _EditPost(
                                                                context,
                                                                snapshot
                                                                    .data
                                                                    .documents[
                                                                index]
                                                                    .documentID),
                                                        child: ListTile(
                                                          title: Text(
                                                            'Edit Post',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          leading: Icon(
                                                            Icons.edit,
                                                            color: Color(
                                                                0xFF9656A1),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.more_horiz),
                                        padding: EdgeInsets.only(
                                          left: (MediaQuery.of(context)
                                              .size
                                              .width *
                                              1 /
                                              7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  final auth = Provider.of<ProviderData>(
                                      context,
                                      listen: false);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileScreen(auth.userData.id)),
                                  );
                                }),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: (MediaQuery.of(context).size.width *
                                      1 /
                                      40),
                                  right: (MediaQuery.of(context).size.width *
                                      1 /
                                      40),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.documents[index]
                                      ['postData'],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          height: 1.2,
                                          color: Colors.grey.shade900),
                                    ),
                                    (snapshot.data.documents[index]
                                    ['post_image'] ==
                                        null)
                                        ? Container()
                                        : Image(
                                      image: NetworkImage(
                                          snapshot.data.documents[index]
                                          ['post_image']),
                                      fit: BoxFit.cover,
                                    ),
                                    FlatButton(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    1 /
                                                    7)),
                                            child: Text(
                                              snapshot
                                                  .data
                                                  .documents[index]
                                              ['NumberOfLikes']
                                                  .toString(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.2,
                                                  color: Colors.grey.shade800),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                1 /
                                                7,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    1 /
                                                    5)),
                                            child: Text(
                                              snapshot
                                                  .data
                                                  .documents[index]
                                              ['NumberOfComments']
                                                  .toString(),
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.2,
                                                  color: Colors.grey.shade800),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => _commentNew(
                                          context,
                                          snapshot.data.documents[index]
                                              .documentID),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          FlatButton(
                                              child: Row(
                                                children: <Widget>[
                                                  FutureBuilder(
                                                      future: Firestore.instance
                                                          .collection('pages')
                                                          .document(
                                                          widget.documentID)
                                                          .collection('post')
                                                          .document(snapshot
                                                          .data
                                                          .documents[index]
                                                          .documentID)
                                                          .collection('like')
                                                          .document(
                                                          auth.userData.id)
                                                          .get(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                              DocumentSnapshot>
                                                          snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return Icon(
                                                            Icons.thumb_up,
                                                            size: 18,
                                                            color: Colors
                                                                .grey.shade800,
                                                          );
                                                        }
                                                        isLiked = snapshot
                                                            .data.exists;

                                                        return Icon(
                                                          Icons.thumb_up,
                                                          size: 18,
                                                          color: isLiked
                                                              ? Colors.blue
                                                              : Colors.grey
                                                              .shade800,
                                                        );
                                                      }),
                                                  Text('Like',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      )),
                                                ],
                                              ),
                                              onPressed: () {
                                                final auth =
                                                Provider.of<ProviderData>(
                                                    context,
                                                    listen: false);

                                                setState(() {
                                                  isLiked = !isLiked;
                                                });
                                                if (isLiked) {
                                                  Firestore.instance
                                                      .collection('pages')
                                                      .document(
                                                      widget.documentID)
                                                      .collection('post')
                                                      .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                      .collection('like')
                                                      .document(
                                                      auth.userData.id)
                                                      .setData({
                                                    'username':
                                                    auth.userData.name,
                                                    'userid': auth.userData.id,
                                                    'postData':
                                                    _postContentController
                                                        .text,
                                                  });
                                                  Firestore.instance
                                                      .collection('pages')
                                                      .document(
                                                      widget.documentID)
                                                      .collection('post')
                                                      .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                      .get()
                                                      .then((DocumentSnapshot
                                                  result) async {
                                                    Firestore.instance
                                                        .collection(
                                                        'ActivtyLog')
                                                        .document(auth
                                                        .userData.ParentID)
                                                        .collection(
                                                        'ActivtyLogitem')
                                                        .document()
                                                        .setData({
                                                      'postData':
                                                      result["postData"],
                                                      'imagePost':
                                                      result["post_image"],
                                                      'userid':
                                                      auth.userData.id,
                                                      'username':
                                                      auth.userData.name,
                                                      'parentId': auth
                                                          .userData.ParentID,
                                                      'userProfileImg': auth
                                                          .userData
                                                          .profileImage,
                                                      'type': 'like',
                                                      'timestamp':
                                                      Timestamp.fromDate(
                                                          DateTime.now()),
                                                    });
                                                  });
                                                  Firestore.instance
                                                      .collection('pages')
                                                      .document(
                                                      widget.documentID)
                                                      .collection('post')
                                                      .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                      .updateData({
                                                    'NumberOfLikes':
                                                    FieldValue.increment(1),
                                                  });
                                                  Firestore.instance
                                                      .collection('pages')
                                                      .document(
                                                      widget.documentID)
                                                      .collection('post')
                                                      .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                      .get()
                                                      .then((DocumentSnapshot
                                                  result) async {
                                                    Firestore.instance
                                                        .collection(
                                                        'Notification')
                                                        .document(
                                                        result["userid"])
                                                        .collection(
                                                        'Notificationitem')
                                                        .document()
                                                        .setData({
                                                      // 'postData':result["postData"],
                                                      //'imagePost':result["post_image"],
                                                      'postId':
                                                      result["post_id"],
                                                      'OwnerId':
                                                      result["userid"],
                                                      'ParentId': auth
                                                          .userData.ParentID,
                                                      'username':
                                                      auth.userData.name,
                                                      'userProfileImg': auth
                                                          .userData
                                                          .profileImage,
                                                      'userid':
                                                      auth.userData.id,
                                                      'timestamp':
                                                      Timestamp.fromDate(
                                                          DateTime.now()),
                                                      'type': 'like',
                                                    });
                                                  });
                                                } else {
                                                  final auth =
                                                  Provider.of<ProviderData>(
                                                      context);
                                                  Firestore.instance
                                                      .collection('pages')
                                                      .document(
                                                      widget.documentID)
                                                      .collection('post')
                                                      .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                      .collection('like')
                                                      .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                      .delete();

                                                  Firestore.instance
                                                      .collection('pages')
                                                      .document(
                                                      widget.documentID)
                                                      .collection('post')
                                                      .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                      .updateData({
                                                    'NumberOfLikes':
                                                    FieldValue.increment(
                                                        -1),
                                                  });
                                                }
                                              }),
                                          FlatButton(
                                            child: Row(
                                              children: <Widget>[
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.mode_comment,
                                                      size: 18,
                                                    ),
                                                    color: Colors.grey.shade800,
                                                    onPressed: () {}),
                                                Text('Comment',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                            onPressed: () => _commentNew(
                                                context,
                                                snapshot.data.documents[index]
                                                    .documentID),
                                          ),
                                          /* FlatButton(
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.share,
                                                    size: 18,
                                                  ),
                                                  color: Colors.grey.shade800,
                                                  onPressed: () {}),
                                              Text('share',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 5,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        );
                      }),
                ),
              );
          }
        });
  }
}
/*
  Widget _cardHeader() {
    return Row(
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.all(MediaQuery.of(context).size.width*1/26),
          child: CircleAvatar(
            backgroundImage: ExactAssetImage('images/profile_page.jpg'),
            radius: 25,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'MBC3',
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*1/7,
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '27 Nov 2019 at 14:30 PM . ',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        IconButton(
          onPressed: (){},
          icon: Icon(Icons.more_horiz),
          padding: EdgeInsets.only(left:(MediaQuery.of(context).size.width*1/7),),
        ),
      ],
    );
  }



  Widget _cardBody() {
    return Padding(
      padding:  EdgeInsets.only(
        left: (MediaQuery.of(context).size.width*1/40),
        right: (MediaQuery.of(context).size.width*1/40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(

            'Welcome to MBC3 page ',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 16, height: 1.2, color: Colors.grey.shade900),
          ),
          Image(
            image: ExactAssetImage('images/post_page.PNG'),
            fit: BoxFit.cover,
          ),
          FlatButton(
            child: Row(
              children: <Widget>[
                Padding(
                  padding:  EdgeInsets.only(right: (MediaQuery.of(context).size.width*1/7)),
                  child: Text(
                    '30K',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 13, height: 1.2, color: Colors.grey.shade800),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: (MediaQuery.of(context).size.width*1/5)),
                  child: Text(
                    '3K Comments.400 Shares',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 13, height: 1.2, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
            onPressed: () => _commentNew(context),
          )
        ],
      ),
    );
  }

  Widget _cardFooter() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        /*   mainAxisAlignment: MainAxisAlignment.spaceBetween,*/
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            size: 18,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('Like',
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    ],
                  ),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.mode_comment,
                            size: 18,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('Comment',
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    ],
                  ),
                  onPressed: () => _commentNew(context),
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.share,
                            size: 18,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('share',
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    ],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



Widget _drawLine() {
  return Container(
    height: 1,
    color: Colors.grey.shade300,
  );
}

 */
