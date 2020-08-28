import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/Home/Create_Comment/group_comment_screen.dart';
import 'package:flutter_shop/Home/Create_Comment/page_comment_screen.dart';
import 'package:flutter_shop/Home/Create_Comment/user_comment_screen.dart';
import 'package:flutter_shop/Home/DB/friends_db.dart';
import 'package:flutter_shop/Home/DB/user_groups_db.dart';
import 'package:flutter_shop/Home/DB/user_pages_db.dart';
import 'package:flutter_shop/Home/Edit_Post/group_update_post.dart';
//import 'package:flutter_shop/group/group_update_post.dart';
import 'package:flutter_shop/Home/Edit_Post/page_edit_post.dart';
import 'package:flutter_shop/Home/Edit_Post/user_update_post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import '../profile_screen.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLiked = false;
  final _formKey = GlobalKey<FormState>();
  File _image1, _image2;
  TextEditingController _postContentController = TextEditingController();
  List<String> litems = [];
  List<String> litems2 = [];
  String imageUrl1, imageUrl2;
  String imageurl;
  Future getImage(File requiredImage) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      requiredImage = image;
    });
  }

  int likecount = 0;
  int commentcount = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _postContentController.dispose();
  }

  void _PageEditPost(context, String pageId, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return PageUpdatePost(pageId, postId);
      },
      isScrollControlled: true,
    );
  }

  void _GroupEditPost(context, String groupId, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return GroupUpdatePost(groupId, postId);
      },
      isScrollControlled: true,
    );
  }

  void _UserEditPost(context, String postId) {
    final auth = Provider.of<ProviderData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return UserUpdatePost(auth.userData.id, postId);
      },
      isScrollControlled: true,
    );
  }

  @override
  void _UsercommentNew(context, String postId) {
    final auth = Provider.of<ProviderData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return UserComment(postId);
      },
      isScrollControlled: true,
    );
  }

  @override
  void _GroupcommentNew(context, String groupId, String postId) {
    final auth = Provider.of<ProviderData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return GroupComment(groupId, postId);
      },
      isScrollControlled: true,
    );
  }

  @override
  void _PagecommentNew(context, String pageId, String postId) {
    final auth = Provider.of<ProviderData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return PageComment(pageId, postId);
      },
      isScrollControlled: true,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
//      resizeToAvoidBottomPadding: false,

        body: ListView(
      children: <Widget>[
        _createPost(),
        _drawLine3(),
        _home_posts(),
         _friends_posts(),

        _group_posts(),
        _page_posts(),

       

        _drawLine3(),
      ],
    ));
  }

  Widget _drawLine3() {
    return Container(
      height: 15,
      color: Colors.grey.shade300,
    );
  }

  Widget _createPost() {
    final auth = Provider.of<ProviderData>(context, listen: false);
    return Form(
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
                      builder: (context) => ProfileScreen(auth.userData.id)),
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
                      hintText:
                          "What's in your mind " + auth.userData.name + "..?",
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
            color: Colors.white10,
            child: Text(
              'Post',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (_image1 != null) {
                  imageurl = await uploadImage(_image1);}
//                } else {
//                  imageurl = "";
//                }
                final auth = Provider.of<ProviderData>(context);
                print('imageurl');
                print(imageurl);
                DocumentReference documentReference = Firestore.instance
                    .collection('user_home')
                    .document(auth.userData.id)
                    .collection('post')
                    .document();
                documentReference.setData({
                  'postData': _postContentController.text,
                  'post_image': imageurl,
                  'userid': auth.userData.id,
                  'username': auth.userData.name,
                  'timestamp': DateTime.now().toString(),
                  'post_id': documentReference.documentID,
                  'NumberOfComments': 0,
                  'NumberOfLikes': 0,
                  'post_content':_postContentController.text,
                  'pageID':'null',
                  'groupID':'null'
                });
                Firestore.instance
                    .collection('ActivtyLog')
                    .document(auth.userData.ParentID)
                    .collection('ActivtyLogitem')
                    .document()
                    .setData({
                  'postData': _postContentController.text,
                  'imagePost': imageurl,
                  'userid': auth.userData.id,
                  'username': auth.userData.name,
                  'ParentId': auth.userData.ParentID,
                  'userProfileImg': auth.userData.profileImage,
                  'type': 'post',
                  'timestamp': Timestamp.fromDate(DateTime.now()),
                });
                imageurl = " ";
                print('add');
                print(imageurl);
                _postContentController.text = "";
                Toast.show("post shared Successfully", context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _home_posts() {
    final auth = Provider.of<ProviderData>(context, listen: false);
    final current_user = Firestore.instance
        .collection('user_home')
        .document(auth.userData.id)
        .collection('post')
        .orderBy('timestamp', descending: true)
        .where('userid', isEqualTo: auth.userData.id ).where('groupID', isEqualTo: 'null').where('pageID', isEqualTo: 'null')
        .snapshots();

    return StreamBuilder(
        stream: current_user,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
//              return Container(
//                height: MediaQuery.of(context).size.height * 0.79,
//                child: ListView.builder(
//                    itemCount: snapshot.data.documents.length,
//                    itemBuilder: (context, index) {
                      return Column(
                          children: List.generate(
                              snapshot.data.documents.length,
//                              userName.length,
                                  (index) => Column(
                                    children: <Widget>[
                                      Container(
                                        color: Colors.white,
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1 /
                                                      26),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileScreen(
                                                              snapshot.data
                                                                      .documents[
                                                                  index]['userid'],
                                                            )),
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  backgroundImage: ExactAssetImage(
                                                      'images/profile_page.jpg'),
                                                  radius: 25,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      snapshot.data
                                                              .documents[index]
                                                          ['username'],
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade900,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
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
//                                              .hashCode
//                                              .toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if ((snapshot.data
                                                            .documents[index]
                                                        ['userid']) ==
                                                    (auth.userData.id)) {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: 200,
                                                          child: Wrap(
                                                            children: <Widget>[
                                                              FlatButton(
                                                                onPressed:
                                                                    () async {
                                                                  await Firestore
                                                                      .instance
                                                                      .collection(
                                                                          'user_home')
                                                                      .document(auth
                                                                          .userData
                                                                          .id)
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
                                                                      .then(
                                                                          (snapshot) {
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
                                                                          'user_home')
                                                                      .document(auth
                                                                          .userData
                                                                          .id)
                                                                      .collection(
                                                                          'post')
                                                                      .document(snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .documentID)
                                                                      .delete();
                                                                  Toast.show("your post delete Successfully", context);
                                                                },
                                                                child: ListTile(
                                                                  title: Text(
                                                                    'Delete Post',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  leading: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .pink,
                                                                  ),
                                                                ),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    _UserEditPost(
                                                                        context,
                                                                        snapshot
                                                                            .data
                                                                            .documents[index]
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
                                                                    color: Colors
                                                                        .pink,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                } else {
                                                  Container();
                                                }
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
                                      Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1 /
                                                40),
                                            right: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1 /
                                                40),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  500),
                                              right: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  500),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data.documents[index]
                                                      ['postData'],
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      height: 1.2,
                                                      color:
                                                          Colors.grey.shade900),
                                                ),
                                                (snapshot.data.documents[index]
                                                            ['post_image'] ==
                                                        null)
                                                    ? Container()
                                                    : Image(
                                                        image: NetworkImage(
                                                            snapshot.data
                                                                        .documents[
                                                                    index]
                                                                ['post_image']),
                                                        fit: BoxFit.cover,
                                                      ),
//                                        Image(
//                                          image: NetworkImage(
//                                              document['post_image']),
//                                          fit: BoxFit.cover,
//                                        ),
                                                FlatButton(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            right: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                1 /
                                                                7)),
                                                        child: Text(
                                                          snapshot
                                                              .data
                                                              .documents[index][
                                                                  'NumberOfLikes']
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              height: 1.2,
                                                              color: Colors.grey
                                                                  .shade800),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            1 /
                                                            7,
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              left: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  1 /
                                                                  5)),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(
                                                                snapshot
                                                                    .data
                                                                    .documents[
                                                                            index]
                                                                        [
                                                                        'NumberOfComments']
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    height: 1.2,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade800),
                                                              ),
                                                              Text(
                                                                '  Comments',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    height: 1.2,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade800),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                  onPressed: () =>
                                                      _UsercommentNew(
                                                          context,
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .documentID),
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
                                                                future: Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'user_home')
                                                                    .document(auth
                                                                        .userData
                                                                        .id)
                                                                    .collection(
                                                                        'post')
                                                                    .document(snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .documentID)
                                                                    .collection(
                                                                        'like')
                                                                    .document(snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .documentID)
                                                                    .get(),
                                                                builder: (context,
                                                                    AsyncSnapshot<
                                                                            DocumentSnapshot>
                                                                        snapshot) {
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Icon(
                                                                      Icons
                                                                          .thumb_up,
                                                                      size: 18,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade800,
                                                                    );
                                                                  }
//                                                          if (document['userid']
//
//                                                          !=
//                                                              (auth.userData.id)) {
//                                                            return Icon(
//                                                              Icons.thumb_up,
//                                                              size: 18,
//                                                              color: Colors
//                                                                  .grey.shade800,
//                                                            );
//                                                          }
                                                                  isLiked =
                                                                      snapshot
                                                                          .data
                                                                          .exists;
                                                                  return Icon(
                                                                    Icons
                                                                        .thumb_up,
                                                                    size: 18,
                                                                    color: isLiked
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .grey
                                                                            .shade800,
                                                                  );
                                                                }),
                                                            Text('Like',
                                                                style:
                                                                    TextStyle(
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
                                                                .collection(
                                                                    'user_home')
                                                                .document(auth
                                                                    .userData
                                                                    .id)
                                                                .collection(
                                                                    'post')
                                                                .document(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID)
                                                                .collection(
                                                                    'like')
                                                                .document(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID)
                                                                .setData({
                                                              'userid': auth
                                                                  .userData.id,
                                                              'username': auth
                                                                  .userData
                                                                  .name,
//                                                              'postData':
//                                                                  document[
//                                                                      'postData'],
                                                              'postData':
                                                                  _postContentController
                                                                      .text,
//                                                      'post_content': document[
//                                                          'post_content']
                                                            });
                                                            Firestore.instance
                                                                .collection(
                                                                    'user_home')
                                                                .document(auth
                                                                    .userData
                                                                    .id)
                                                                .collection(
                                                                    'post')
                                                                .document(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID)
                                                                .get()
                                                                .then((DocumentSnapshot
                                                                    result) async {
                                                              Firestore.instance
                                                                  .collection(
                                                                      'ActivtyLog')
                                                                  .document(auth
                                                                      .userData
                                                                      .ParentID)
                                                                  .collection(
                                                                      'ActivtyLogitem')
                                                                  .document()
                                                                  .setData({
                                                                'postData': result[
                                                                    "postData"],
                                                                'imagePost': result[
                                                                    "post_image"],
                                                                'userid': auth
                                                                    .userData
                                                                    .id,
                                                                'username': auth
                                                                    .userData
                                                                    .name,
                                                                'parentId': auth
                                                                    .userData
                                                                    .ParentID,
                                                                'userProfileImg': auth
                                                                    .userData
                                                                    .profileImage,
                                                                'type': 'like',
                                                                'timestamp': Timestamp
                                                                    .fromDate(
                                                                        DateTime
                                                                            .now()),
                                                              });
                                                            });
                                                            Firestore.instance
                                                                .collection(
                                                                    'user_home')
                                                                .document(auth
                                                                    .userData
                                                                    .id)
                                                                .collection(
                                                                    'post')
                                                                .document(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID)
                                                                .updateData({
                                                              'NumberOfLikes':
                                                                  FieldValue
                                                                      .increment(
                                                                          1),
                                                            });
                                                            Firestore.instance
                                                                .collection(
                                                                    'user_home')
                                                                .document(auth
                                                                    .userData
                                                                    .id)
                                                                .collection(
                                                                    'post')
                                                                .document(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID)
                                                                .get()
                                                                .then((DocumentSnapshot
                                                                    result) async {
                                                              Firestore.instance
                                                                  .collection(
                                                                      'Notification')
                                                                  .document(result[
                                                                      "userid"])
                                                                  .collection(
                                                                 'Notificationitem' )
                                                                  .document()
                                                                  .setData({
                                                                'postData': result[
                                                                    "postData"],
                                                                'imagePost': result[
                                                                    "post_image"],
                                                                'postId': result[
                                                                    "post_id"],
                                                                'OwnerId': result[
                                                                    "userid"],
                                                                'ParentId': auth
                                                                    .userData
                                                                    .ParentID,
                                                                'username': auth
                                                                    .userData
                                                                    .name,
                                                                'userProfileImg': auth
                                                                    .userData
                                                                    .profileImage,
                                                                'userid': auth
                                                                    .userData
                                                                    .id,
                                                                'timestamp': Timestamp
                                                                    .fromDate(
                                                                        DateTime
                                                                            .now()),
                                                                'type': 'like',
                                                              });
                                                            });
                                                          } else {
                                                            likecount =
                                                                likecount - 1;
                                                            Firestore.instance
                                                                .collection(
                                                                    'user_home')
                                                                .document(auth
                                                                    .userData
                                                                    .id)
                                                                .collection(
                                                                    'post')
                                                                .document(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID)
                                                                .collection(
                                                                    'like')
                                                                .document(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID)
                                                                .delete();

                                                            Firestore.instance
                                                                .collection(
                                                                    'user_home')
                                                                .document(auth
                                                                    .userData
                                                                    .id)
                                                                .collection(
                                                                    'post')
                                                                .document(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .documentID)
                                                                .updateData({
                                                              'NumberOfLikes':
                                                                  FieldValue
                                                                      .increment(
                                                                          -1),
                                                            });
                                                          }
                                                        }),
                                                    FlatButton(
                                                      child: Row(
                                                        children: <Widget>[
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .mode_comment,
                                                                size: 18,
                                                              ),
                                                              color: Colors.grey
                                                                  .shade800,
                                                              onPressed: () {}),
                                                          Text('Comment',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              )),
                                                        ],
                                                      ),
                                                      onPressed: () =>
                                                          _UsercommentNew(
                                                              context,
                                                              snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .documentID),
                                                    ),
                                                    FlatButton(
                                                      child: Row(
                                                        children: <Widget>[
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons.share,
                                                                size: 18,
                                                              ),
                                                              color: Colors.grey
                                                                  .shade800,
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
                                  ))

//                    }
                    );

          }
        });
  }

  Widget _group_posts() {
    final auth = Provider.of<ProviderData>(context);
    return FutureBuilder(
//
        future: UserGroupsDB().getDocs(auth.userData.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              List<String> groupId = [];
              List<String> postId = [];
              List<String> postData = [];
              List<String> postImage = [];
              List<String> userName = [];
              List<int> numberOfLikes = [];
              List<int> numberOfComments = [];
              List<String> timestamp = [];
              List<String> userId = [];
              var items = snapshot.data;
//              var postId=snapshot.data;
              print('items.length ${items.length}');
              for (var item in items) {
                print('item.runtimeType ${item.runtimeType}');
                for (int i = 0; i < item.documents.length; i++) {
                  print(item.documents.length);
                  groupId.add(item.documents[i]['groupID']);
                  postId.add(item.documents[i]['post_id']);
                  userName.add(item.documents[i]['username']);
                  postImage.add(item.documents[i]['post_image']);
                  postData.add(item.documents[i]['postData']);
                  userId.add(item.documents[i]['userid']);
                  timestamp.add(item.documents[i]['timestamp']);
                  numberOfLikes.add(item.documents[i]['NumberOfLikes']);
                  numberOfComments.add(item.documents[i]['NumberOfComments']);
                }
              }

              return Column(
                  children: List.generate(
                      userName.length,
                      (index) => Column(
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
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      userId[index],
                                                    )),
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: ExactAssetImage(
                                              'images/profile_page.jpg'),
                                          radius: 25,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
//                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              userName[index],
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
                                          timestamp[index],
//                                              .hashCode.toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if ((userId[index]) ==
                                            (auth.userData.id)) {
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
                                                                  'groups')
                                                              .document(groupId[
                                                                  index])
                                                              .collection(
                                                                  'post')
                                                              .document(
                                                                  postId[index])
                                                              .collection(
                                                                  'comment')
                                                              .document(
                                                                  postId[index])
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
                                                                  'groups')
                                                              .document(groupId[
                                                                  index])
                                                              .collection(
                                                                  'post')
                                                              .document(
                                                                  postId[index])
                                                              .delete();
                                                          Toast.show("your post delete Successfully", context);
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
                                                            _GroupEditPost(
                                                                context,
                                                                groupId[index],
                                                                postId[index]),
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
                                        } else {
                                          Container();
                                        }
                                      },
                                      icon: Icon(Icons.more_horiz),
                                      padding: EdgeInsets.only(
                                        left:
                                            (MediaQuery.of(context).size.width *
                                                1 /
                                                5),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        postData[index],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 16,
                                            height: 1.2,
                                            color: Colors.grey.shade900),
                                      ),
                                      (postImage[index] == null)
                                          ? Container()
                                          : Image(
                                              image: NetworkImage(
                                                  postImage[index]),
                                              fit: BoxFit.cover,
                                            ),
//                                      Image(
//                                        image: NetworkImage(postImage[index]),
//                                        fit: BoxFit.cover,
//                                      ),
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
                                                numberOfLikes[index].toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    height: 1.2,
                                                    color:
                                                        Colors.grey.shade800),
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
                                                    left:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1 /
                                                            5)),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      numberOfComments[index]
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          height: 1.2,
                                                          color: Colors
                                                              .grey.shade800),
                                                    ),
                                                    Text(
                                                      '  Comments',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          height: 1.2,
                                                          color: Colors
                                                              .grey.shade800),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        onPressed: () => _GroupcommentNew(
                                            context,
                                            groupId[index],
                                            postId[index]),
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
                                                        future: Firestore
                                                            .instance
                                                            .collection(
                                                                'groups')
                                                            .document(
                                                                groupId[index])
                                                            .collection('post')
                                                            .document(
                                                                postId[index])
                                                            .collection('like')
                                                            .document(
                                                                postId[index])
                                                            .get(),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    DocumentSnapshot>
                                                                snapshot) {
//                                                          if (userId[index] !=
//                                                              (auth.userData
//                                                                  .id)) {
//                                                            return Icon(
//                                                              Icons.thumb_up,
//                                                              size: 18,
//                                                              color: Colors.grey
//                                                                  .shade800,
//                                                            );
//                                                          }
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Icon(
                                                              Icons.thumb_up,
                                                              size: 18,
                                                              color: Colors.grey
                                                                  .shade800,
                                                            );
                                                          }
                                                          isLiked = snapshot
                                                              .data.exists;
                                                          return Icon(
                                                            Icons.thumb_up,
                                                            size: 18,
                                                            color: isLiked
                                                                ? Colors.purple
                                                                : Colors.grey
                                                                    .shade800,
                                                          );
                                                        }),
                                                    Text('Like',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        )),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isLiked = !isLiked;
                                                  });
                                                  if (isLiked) {
                                                    final auth = Provider.of<
                                                        ProviderData>(context);
                                                    Firestore.instance
                                                        .collection('groups')
                                                        .document(
                                                            groupId[index])
                                                        .collection('post')
                                                        .document(postId[index])
                                                        .collection('like')
                                                        .document(postId[index])
                                                        .setData({
                                                      'userid':
                                                          auth.userData.id,
                                                      'username':
                                                          auth.userData.name,
                                                      'postData':
                                                          _postContentController
                                                              .text,
                                                    });
                                                    Firestore.instance
                                                        .collection('groups')
                                                        .document(
                                                            groupId[index])
                                                        .collection('post')
                                                        .document(postId[index])
                                                        .get()
                                                        .then((DocumentSnapshot
                                                            result) async {
                                                      Firestore.instance
                                                          .collection(
                                                              'ActivtyLog')
                                                          .document(auth
                                                              .userData
                                                              .ParentID)
                                                          .collection(
                                                              'ActivtyLogitem')
                                                          .document(
                                                              )
                                                          .setData({
                                                        'postData':
                                                            result["postData"],
                                                        'imagePost': result[
                                                            "post_image"],
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
                                                      Firestore.instance
                                                          .collection('groups')
                                                          .document(
                                                              groupId[index])
                                                          .collection('post')
                                                          .document(
                                                              postId[index])
                                                          .updateData({
                                                        'NumberOfLikes':
                                                            FieldValue
                                                                .increment(1),
                                                      });
                                                    });
                                                    Firestore.instance.collection('groups')
                                                        .document(groupId[index])
                                                        .collection('post').document(postId[index]).get().then(
                                                            (DocumentSnapshot result) async {
                                                          Firestore.instance
                                                              .collection('Notification')
                                                              .document(result["userid"])
                                                              .collection('Notificationitem')
                                                              .document()
                                                              .setData({
                                                            'postData':result["postData"],
                                                            'imagePost':result["post_image"],
                                                            'postId':result["post_id"],
                                                            'OwnerId':result["userid"],
                                                            'ParentId':auth.userData.ParentID,
                                                            'username':auth.userData.name,
                                                            'userProfileImg':auth.userData.profileImage,
                                                            'userid':auth.userData.id,
                                                            'timestamp': Timestamp.fromDate(DateTime.now()),
                                                            'type':'like',
                                                          }
                                                          );
                                                        });
                                                  } else {
//                                                    likecount = likecount - 1;
                                                    final auth = Provider.of<
                                                        ProviderData>(context);
                                                    Firestore.instance
                                                        .collection('groups')
                                                        .document(
                                                            groupId[index])
                                                        .collection('post')
                                                        .document(postId[index])
                                                        .collection('like')
                                                        .document(postId[index])
                                                        .delete();
                                                    Firestore.instance
                                                        .collection('groups')
                                                        .document(
                                                            groupId[index])
                                                        .collection('post')
                                                        .document(postId[index])
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
                                                  Icon(
                                                    Icons.mode_comment,
                                                    size: 18,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                  Text('Comment',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      )),
                                                ],
                                              ),
                                              onPressed: () => _GroupcommentNew(
                                                  context,
                                                  groupId[index],
                                                  postId[index]),
                                            ),
                                            FlatButton(
                                              child: Row(
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.share,
                                                        size: 18,
                                                      ),
                                                      color:
                                                          Colors.grey.shade800,
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
                          )));
          }
        });
  }
  Widget _friends_posts() {
    final auth = Provider.of<ProviderData>(context);
    return FutureBuilder(
//
        future: FriendsDB().getDocs(auth.userData.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              List<String> homeId = [];
              List<String> postId = [];
              List<String> postData = [];
              List<String> postImage = [];
              List<String> userName = [];
              List<int> numberOfLikes = [];
              List<int> numberOfComments = [];
              List<String> timestamp = [];
              List<String> userId = [];
              var items = snapshot.data;
//              var postId=snapshot.data;
              print('items.length ${items.length}');
              for (var item in items) {
                print('item.runtimeType ${item.runtimeType}');
                for (int i = 0; i < item.documents.length; i++) {
                  print(item.documents.length);
                  homeId.add(item.documents[i]['userid']);
                  postId.add(item.documents[i]['post_id']);
                  userName.add(item.documents[i]['username']);
                  postImage.add(item.documents[i]['post_image']);
                  postData.add(item.documents[i]['postData']);
                  userId.add(item.documents[i]['userid']);
                  timestamp.add(item.documents[i]['timestamp']);
                  numberOfLikes.add(item.documents[i]['NumberOfLikes']);
                  numberOfComments.add(item.documents[i]['NumberOfComments']);
                }
              }

              return Column(
                  children: List.generate(
                      userName.length,
                          (index) => Column(
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
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen(
                                                  userId[index],
                                                )),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: ExactAssetImage(
                                          'images/profile_page.jpg'),
                                      radius: 25,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
//                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          userName[index],
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
                                      timestamp[index],
//                                              .hashCode.toString(),
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    if ((userId[index]) ==
                                        (auth.userData.id)) {
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
                                                          'user_home')
                                                          .document(homeId[
                                                      index])
                                                          .collection(
                                                          'post')
                                                          .document(
                                                          postId[index])
                                                          .collection(
                                                          'comment')
                                                          .document(
                                                          postId[index])
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
                                                          'user_home')
                                                          .document(homeId[
                                                      index])
                                                          .collection(
                                                          'post')
                                                          .document(
                                                          postId[index])
                                                          .delete();
                                                      Toast.show("your post delete Successfully", context);
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
                                                        _UserEditPost(
                                                            context,

                                                            postId[index]),
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
                                    } else {
                                      Container();
                                    }
                                  },
                                  icon: Icon(Icons.more_horiz),
                                  padding: EdgeInsets.only(
                                    left:
                                    (MediaQuery.of(context).size.width *
                                        1 /
                                        5),
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
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    postData[index],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        color: Colors.grey.shade900),
                                  ),
                                  (postImage[index] == null)
                                      ? Container()
                                      : Image(
                                    image: NetworkImage(
                                        postImage[index]),
                                    fit: BoxFit.cover,
                                  ),
//                                      Image(
//                                        image: NetworkImage(postImage[index]),
//                                        fit: BoxFit.cover,
//                                      ),
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
                                            numberOfLikes[index].toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 13,
                                                height: 1.2,
                                                color:
                                                Colors.grey.shade800),
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
                                                left:
                                                (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    1 /
                                                    5)),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  numberOfComments[index]
                                                      .toString(),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      height: 1.2,
                                                      color: Colors
                                                          .grey.shade800),
                                                ),
                                                Text(
                                                  '  Comments',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      height: 1.2,
                                                      color: Colors
                                                          .grey.shade800),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    onPressed: () => _UsercommentNew(
                                        context,

                                        postId[index]),
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
                                                    future: Firestore
                                                        .instance
                                                        .collection(
                                                        'user_home')
                                                        .document(
                                                        homeId[index])
                                                        .collection('post')
                                                        .document(
                                                        postId[index])
                                                        .collection('like')
                                                        .document(
                                                        postId[index])
                                                        .get(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
//                                                          if (userId[index] !=
//                                                              (auth.userData
//                                                                  .id)) {
//                                                            return Icon(
//                                                              Icons.thumb_up,
//                                                              size: 18,
//                                                              color: Colors.grey
//                                                                  .shade800,
//                                                            );
//                                                          }
                                                      if (!snapshot
                                                          .hasData) {
                                                        return Icon(
                                                          Icons.thumb_up,
                                                          size: 18,
                                                          color: Colors.grey
                                                              .shade800,
                                                        );
                                                      }
                                                      isLiked = snapshot
                                                          .data.exists;
                                                      return Icon(
                                                        Icons.thumb_up,
                                                        size: 18,
                                                        color: isLiked
                                                            ? Colors.purple
                                                            : Colors.grey
                                                            .shade800,
                                                      );
                                                    }),
                                                Text('Like',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    )),
                                              ],
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                isLiked = !isLiked;
                                              });
                                              if (isLiked) {
                                                final auth = Provider.of<
                                                    ProviderData>(context);
                                                Firestore.instance
                                                    .collection('user_home')
                                                    .document(
                                                    homeId[index])
                                                    .collection('post')
                                                    .document(postId[index])
                                                    .collection('like')
                                                    .document(postId[index])
                                                    .setData({
                                                  'userid':
                                                  auth.userData.id,
                                                  'username':
                                                  auth.userData.name,
                                                  'postData':
                                                  _postContentController
                                                      .text,
                                                });
                                                Firestore.instance
                                                    .collection('user_home')
                                                    .document(
                                                    homeId[index])
                                                    .collection('post')
                                                    .document(postId[index])
                                                    .get()
                                                    .then((DocumentSnapshot
                                                result) async {
                                                  Firestore.instance
                                                      .collection(
                                                      'ActivtyLog')
                                                      .document(auth
                                                      .userData
                                                      .ParentID)
                                                      .collection(
                                                      'ActivtyLogitem')
                                                      .document(
                                                  )
                                                      .setData({
                                                    'postData':
                                                    result["postData"],
                                                    'imagePost': result[
                                                    "post_image"],
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
                                                  Firestore.instance
                                                      .collection('user_home')
                                                      .document(
                                                      homeId[index])
                                                      .collection('post')
                                                      .document(
                                                      postId[index])
                                                      .updateData({
                                                    'NumberOfLikes':
                                                    FieldValue
                                                        .increment(1),
                                                  });
                                                });
                                                Firestore.instance.collection('user_home')
                                                    .document(homeId[index])
                                                    .collection('post').document(postId[index]).get().then(
                                                        (DocumentSnapshot result) async {
                                                      Firestore.instance
                                                          .collection('Notification')
                                                          .document(result["userid"])
                                                          .collection('Notificationitem')
                                                          .document()
                                                          .setData({
                                                        'postData':result["postData"],
                                                        'imagePost':result["post_image"],
                                                        'postId':result["post_id"],
                                                        'OwnerId':result["userid"],
                                                        'ParentId':auth.userData.ParentID,
                                                        'username':auth.userData.name,
                                                        'userProfileImg':auth.userData.profileImage,
                                                        'userid':auth.userData.id,
                                                        'timestamp': Timestamp.fromDate(DateTime.now()),
                                                        'type':'like',
                                                      }
                                                      );
                                                    });
                                              } else {
//                                                    likecount = likecount - 1;
                                                final auth = Provider.of<
                                                    ProviderData>(context);
                                                Firestore.instance
                                                    .collection('user_home')
                                                    .document(
                                                    homeId[index])
                                                    .collection('post')
                                                    .document(postId[index])
                                                    .collection('like')
                                                    .document(postId[index])
                                                    .delete();
                                                Firestore.instance
                                                    .collection('user_home')
                                                    .document(
                                                    homeId[index])
                                                    .collection('post')
                                                    .document(postId[index])
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
                                              Icon(
                                                Icons.mode_comment,
                                                size: 18,
                                                color: Colors.grey.shade800,
                                              ),
                                              Text('Comment',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          onPressed: () => _UsercommentNew(
                                              context,

                                              postId[index]),
                                        ),
                                        FlatButton(
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.share,
                                                    size: 18,
                                                  ),
                                                  color:
                                                  Colors.grey.shade800,
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
                      )));
          }
        });
  }

  Widget _page_posts() {
    final auth = Provider.of<ProviderData>(context);
    return FutureBuilder(
//
        future: userPagesDB().getDocs2(auth.userData.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              List<String> pageId = [];
              List<String> postId = [];
              List<String> postData = [];
              List<String> postImage = [];
              List<String> userName = [];
              List<int> numberOfLikes = [];
              List<int> numberOfComments = [];
              List<String> timestamp = [];
              List<String> userId = [];
              var items = snapshot.data;
//              var postId=snapshot.data;
              print('items.length ${items.length}');
              for (var item in items) {
                print('item.runtimeType ${item.runtimeType}');
                for (int i = 0; i < item.documents.length; i++) {
                  print(item.documents.length);
                  pageId.add(item.documents[i]['pageID']);
                  postId.add(item.documents[i]['post_id']);
                  userName.add(item.documents[i]['username']);
                  postImage.add(item.documents[i]['post_image']);
                  postData.add(item.documents[i]['postData']);
                  userId.add(item.documents[i]['userid']);
                  timestamp.add(item.documents[i]['timestamp']);
                  numberOfLikes.add(item.documents[i]['NumberOfLikes']);
                  numberOfComments.add(item.documents[i]['NumberOfComments']);
                }
              }

              return Column(
                  children: List.generate(
                      userName.length,
                      (index) => Column(
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
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      userId[index],
                                                    )),
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: ExactAssetImage(
                                              'images/profile_page.jpg'),
                                          radius: 25,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
//                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              userName[index],
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
                                          timestamp[index],
//                                              .hashCode.toString(),
//                                              .hashCode.toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if ((userId[index]) ==
                                            (auth.userData.id)) {
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
                                                              .document(
                                                                  pageId[index])
                                                              .collection(
                                                                  'post')
                                                              .document(
                                                                  postId[index])
                                                              .collection(
                                                                  'comment')
                                                              .document(
                                                                  postId[index])
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
                                                              .document(
                                                                  pageId[index])
                                                              .collection(
                                                                  'post')
                                                              .document(
                                                                  postId[index])
                                                              .delete();
                                                          Toast.show("your post delete Successfully", context);
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
                                                            _PageEditPost(
                                                                context,
                                                                pageId[index],
                                                                postId[index]),
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
                                        } else {
                                          Container();
                                        }
                                      },
                                      icon: Icon(Icons.more_horiz),
                                      padding: EdgeInsets.only(
                                        left:
                                            (MediaQuery.of(context).size.width *
                                                1 /
                                                5),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        postData[index],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 16,
                                            height: 1.2,
                                            color: Colors.grey.shade900),
                                      ),
                                      (postImage[index] == null)
                                          ? Container()
                                          : Image(
                                              image: NetworkImage(
                                                  postImage[index]),
                                              fit: BoxFit.cover,
                                            ),
//                                      Image(
//                                        image: NetworkImage(postImage[index]),
//                                        fit: BoxFit.cover,
//                                      ),
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
                                                numberOfLikes[index].toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    height: 1.2,
                                                    color:
                                                        Colors.grey.shade800),
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
                                                    left:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1 /
                                                            5)),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      numberOfComments[index]
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          height: 1.2,
                                                          color: Colors
                                                              .grey.shade800),
                                                    ),
                                                    Text(
                                                      '  Comments',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          height: 1.2,
                                                          color: Colors
                                                              .grey.shade800),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        onPressed: () => _PagecommentNew(
                                            context,
                                            pageId[index],
                                            postId[index]),
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
                                                        future: Firestore
                                                            .instance
                                                            .collection('pages')
                                                            .document(
                                                                pageId[index])
                                                            .collection('post')
                                                            .document(
                                                                postId[index])
                                                            .collection('like')
                                                            .document(
                                                                postId[index])
                                                            .get(),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    DocumentSnapshot>
                                                                snapshot) {
//                                                          if (userId[index] !=
//                                                              (auth.userData
//                                                                  .id)) {
//                                                            return Icon(
//                                                              Icons.thumb_up,
//                                                              size: 18,
//                                                              color: Colors.grey
//                                                                  .shade800,
//                                                            );
//                                                          }
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Icon(
                                                              Icons.thumb_up,
                                                              size: 18,
                                                              color: Colors.grey
                                                                  .shade800,
                                                            );
                                                          }
                                                          isLiked = snapshot
                                                              .data.exists;
                                                          return Icon(
                                                            Icons.thumb_up,
                                                            size: 18,
                                                            color: isLiked
                                                                ? Colors.purple
                                                                : Colors.grey
                                                                    .shade800,
                                                          );
                                                        }),
                                                    Text('Like',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        )),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isLiked = !isLiked;
                                                  });
                                                  if (isLiked) {
                                                    final auth = Provider.of<
                                                        ProviderData>(context);
                                                    Firestore.instance
                                                        .collection('pages')
                                                        .document(pageId[index])
                                                        .collection('post')
                                                        .document(postId[index])
                                                        .collection('like')
                                                        .document(postId[index])
                                                        .setData({
                                                      'userid':
                                                          auth.userData.id,
                                                      'username':
                                                          auth.userData.name,
                                                      'postData':
                                                          _postContentController
                                                              .text,
                                                    });
                                                    Firestore.instance
                                                        .collection('pages')
                                                        .document(pageId[index])
                                                        .collection('post')
                                                        .document(postId[index])
                                                        .get()
                                                        .then((DocumentSnapshot
                                                            result) async {
                                                      Firestore.instance
                                                          .collection(
                                                              'ActivtyLog')
                                                          .document(auth
                                                              .userData
                                                              .ParentID)
                                                          .collection(
                                                              'ActivtyLogitem')
                                                          .document(
                                                              )
                                                          .setData({
                                                        'postData':
                                                            result["postData"],
                                                        'imagePost': result[
                                                            "post_image"],
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
                                                      Firestore.instance
                                                          .collection('pages')
                                                          .document(
                                                              pageId[index])
                                                          .collection('post')
                                                          .document(
                                                              postId[index])
                                                          .updateData({
                                                        'NumberOfLikes':
                                                            FieldValue
                                                                .increment(1),
                                                      });
                                                    });
                                                    Firestore.instance.collection('pages')
                                                        .document(pageId[index])
                                                        .collection('post').document(postId[index]).get().then(
                                                            (DocumentSnapshot result) async {
                                                          Firestore.instance
                                                              .collection('Notification')
                                                              .document(result["userid"])
                                                              .collection('Notificationitem')
                                                              .document()
                                                              .setData({
                                                            'postData':result["postData"],
                                                            'imagePost':result["post_image"],
                                                            'postId':result["post_id"],
                                                            'OwnerId':result["userid"],
                                                            'ParentId':auth.userData.ParentID,
                                                            'username':auth.userData.name,
                                                            'userProfileImg':auth.userData.profileImage,
                                                            'userid':auth.userData.id,
                                                            'timestamp': Timestamp.fromDate(DateTime.now()),
                                                            'type':'like',
                                                          }
                                                          );
                                                        });
                                                  } else {

                                                    final auth = Provider.of<
                                                        ProviderData>(context);
                                                    Firestore.instance
                                                        .collection('pages')
                                                        .document(pageId[index])
                                                        .collection('post')
                                                        .document(postId[index])
                                                        .collection('like')
                                                        .document(postId[index])
                                                        .delete();
                                                    Firestore.instance
                                                        .collection('pages')
                                                        .document(pageId[index])
                                                        .collection('post')
                                                        .document(postId[index])
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
                                                  Icon(
                                                    Icons.mode_comment,
                                                    size: 18,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                  Text('Comment',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      )),
                                                ],
                                              ),
                                              onPressed: () => _PagecommentNew(
                                                  context,
                                                  pageId[index],
                                                  postId[index]),
                                            ),
                                            FlatButton(
                                              child: Row(
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.share,
                                                        size: 18,
                                                      ),
                                                      color:
                                                          Colors.grey.shade800,
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
                          )));
          }
        });
  }

}

Future<String> uploadImage(File image) async {
  String name = Random().nextInt(1000).toString() + '_page';
  final StorageReference storageReference = FirebaseStorage().ref().child(name);
  final StorageUploadTask uploadTask = storageReference.putFile(image);
  StorageTaskSnapshot response = await uploadTask.onComplete;
  String url = await response.ref.getDownloadURL();
  return url;
}
