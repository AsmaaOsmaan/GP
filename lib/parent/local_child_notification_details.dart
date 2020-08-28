import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_shop/Home/Create_Comment/user_comment_screen.dart';
import 'package:flutter_shop/Screenss/comment_screenPages.dart';

import 'package:flutter_shop/Screenss/group_comment_screen.dart';
import 'package:flutter_shop/User/user_comment_screen.dart';
import 'package:provider/provider.dart';

import '../provider_data.dart';

class LocalChildNotificationDetails extends StatefulWidget {
  final String ID;

  LocalChildNotificationDetails(this.ID, {Key key}) : super(key: key);
  @override
  _LocalChildNotificationDetailsState createState() => _LocalChildNotificationDetailsState();
}

class _LocalChildNotificationDetailsState extends State<LocalChildNotificationDetails> {
  bool isLiked = false;
  @override
  void _commentNewFromPage(context,String PageID, String postId) {
    print ("sennnnd");
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return pageComment(PageID, postId,);
      },


      //////////////////


      ///////////////////
      isScrollControlled: true,
    );
  }


  void _commentNewFromGroup(context,String groupID ,String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return GroupComment(groupID, postId);
      },


      //////////////////


      ///////////////////
      isScrollControlled: true,
    );
  }





  void _commentNewFromHome(context,String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return UserComment( postId);
      },


      //////////////////


      ///////////////////
      isScrollControlled: true,
    );
  }





  ////////////////


 /* void _commentNehome(context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Comment( String document, postId);
      },

      //////////////////


      ///////////////////
      isScrollControlled: true,
    );
  }*/








  /////////////////////////


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _post(),
    );
  }


  Widget _post() {
   // final auth = Provider.of<ProviderData>(context);
    final auth = Provider.of<ProviderData>(context);
    return StreamBuilder(
        //stream: Firestore.instance.collection('post').where('id',isEqualTo:widget.ID ).snapshots(),
        stream: Firestore.instance .collection('user_home')
        .document(auth.userData.id)
        .collection('post').where('post_id',isEqualTo:widget.ID ).snapshots(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                height: MediaQuery.of(context).size.height * .70,
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Text(
                                      snapshot.data.documents[index]
                                      ['timestamp'],
                                      style: TextStyle(color: Colors.grey),
                                    ),
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
                                                    await Firestore.instance
                                                        .collection('post')
                                                        .document(
                                                        widget.ID)
                                                        .collection('comment')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                        .collection('like')
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                      for (DocumentSnapshot ds
                                                      in snapshot
                                                          .documents) {
                                                        ds.reference.delete();
                                                      }
                                                    });
                                                    await Firestore.instance
                                                        .collection('post')
                                                        .document(
                                                        widget.ID)
                                                        .delete();
                                                  },
                                                  child: ListTile(
                                                    title: Text(
                                                      'Delete Post',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .purpleAccent),
                                                    ),
                                                    leading: Icon(
                                                      Icons.delete,
                                                      color: Colors.pink,
                                                    ),
                                                  ),
                                                ),
                                                FlatButton(
                                                  onPressed: () {},
                                                  child: ListTile(
                                                    title: Text(
                                                      'Edit Post',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .purpleAccent),
                                                    ),
                                                    leading: Icon(
                                                      Icons.edit,
                                                      color: Colors.pink,
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
                                    left: (MediaQuery.of(context).size.width *
                                        1 /
                                        7),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: (MediaQuery.of(context).size.width *
                                      1 /
                                      500),
                                  right: (MediaQuery.of(context).size.width *
                                      1 /
                                      500),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.documents[index]
                                      ['post_content'],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          height: 1.2,
                                          color: Colors.grey.shade900),
                                    ),
                                    (snapshot.data.documents[index]['post_image']==null)?Container():
                                    Image(
                                      image: NetworkImage(snapshot
                                          .data.documents[index]['post_image']),
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
                                              '30K',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.2,
                                                  color: Colors.grey.shade800),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    1 /
                                                    5)),
                                            child: Text(
                                              '3K Comments.400 Shares',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.2,
                                                  color: Colors.grey.shade800),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: (){
                                        if( snapshot.data.documents[index]
                                        ['groupID']!='null'){
                                          _commentNewFromGroup( context,
                                              snapshot.data.documents[index]
                                              ['groupID'],snapshot.data.documents[index]
                                              ['post_id']);
                                        }
                                        else if( snapshot.data.documents[index]
                                        ['pageID']!='null'){
                                          print("**************");
                                          _commentNewFromPage( context, snapshot.data.documents[index]
                                          ['pageID'],
                                              snapshot.data.documents[index]
                                              ['post_id'] );
                                        }
                                        else if(snapshot.data.documents[index]
                                        ['pageID']=='null'&&snapshot.data.documents[index]
                                        ['groupID']=='null'){

                                          _commentNewFromHome(context, snapshot.data.documents[index]['post_id']);
                                        }

                                      },
                                    )
                                  ],
                                ),
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
                                                      isLiked =
                                                          snapshot.data.exists;
                                                      return Icon(
                                                        Icons.thumb_up,
                                                        size: 18,
                                                        color: isLiked
                                                            ? Colors.blue
                                                            : Colors
                                                            .grey.shade800,
                                                      );
                                                    }),
                                                Text('Like',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                isLiked = !isLiked;
                                              });
                                              if (isLiked) {
                                                Firestore.instance
                                                    .collection('post')
                                                    .document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                    .collection('like')
                                                    .document(
                                                    auth.userData.id)
                                                    .setData({
                                                  'userid':
                                                  auth.userData.id
                                                });
                                                Firestore.instance
                                                    .collection('ActivtyLog')
                                                    .document(auth.userData.ParentID)
                                                    .collection(
                                                    'ActivtyLogitem')
                                                    .document()
                                                    .setData({
                                                  'userid':
                                                  auth.userData.id,
                                                  'type': 'like',
                                                  'userid': auth.userData.id,
                                                  'username':auth.userData.name,
                                                  'ParentId':auth.userData.ParentID,
                                                  'userProfileImg':auth.userData.profileImage,

                                                  'timestamp': Timestamp.fromDate(DateTime.now()),
                                                  'postData': snapshot
                                                      .data.documents[index]['post_content'],
                                                  'imagePost': snapshot
                                                      .data.documents[index]['post_image'],
                                                });
                                              } else {
                                                Firestore.instance
                                                    .collection('post')
                                                    .document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                    .collection('like')
                                                    .document(
                                                    auth.userData.id)
                                                    .delete();
                                                Firestore.instance
                                                    .collection('ActivtyLog')
                                                    .document(auth.userData.ParentID)
                                                    .collection(
                                                    'ActivtyLogitem')
                                                    .document()
                                                    .setData({
                                                  'userid':
                                                  auth.userData.id,
                                                  'type': 'like',
                                                  'userid': auth.userData.id,
                                                  'username':auth.userData.name,
                                                  'ParentId':auth.userData.ParentID,
                                                  'userProfileImg':auth.userData.profileImage,

                                                  'timestamp': Timestamp.fromDate(DateTime.now()),
                                                  'postData': snapshot
                                                      .data.documents[index]['post_content'],
                                                  'imagePost': snapshot
                                                      .data.documents[index]['post_image'],
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
                                                  onPressed: () {

                                                  }),
                                              Text('Comment',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                        /*  onPressed: () => _commentNew(
                                              context,
                                              snapshot.data.documents[index]
                                                  .documentID),*/
                                        onPressed: (){
                                          if( snapshot.data.documents[index]
                                          ['groupID']!='null'){
                                            _commentNewFromGroup( context,
                                                snapshot.data.documents[index]
                                                ['groupID'], snapshot.data.documents[index]
                                                ['post_id']);
                                          }
                                          else if(

                                          snapshot.data.documents[index]
                                          ['pageID']!='null'){
                                            print("doooooooooooooonnnnnnnnnnnne");
                                            print( snapshot.data.documents[index]
                                            ['post_id']);
                                            print(snapshot.data.documents[index]
                                            ['pageID']);
                                            _commentNewFromPage( context, snapshot.data.documents[index]
                                            ['pageID'],
                                                snapshot.data.documents[index]
                                                ['post_id']);
                                          }
                                          else if(snapshot.data.documents[index]
                                          ['pageID']=='null'&&snapshot.data.documents[index]
                                          ['groupID']=='null'){

                                            _commentNewFromHome(context, snapshot.data.documents[index]['post_id']);
                                          }

                                        },







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
                            ),
                          ),
                          Container(
                            height: 5,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      );
                    }),
              );
          }
        });
  }



}
