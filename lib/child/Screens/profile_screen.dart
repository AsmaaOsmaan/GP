import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_shop/User/user_update_post.dart';
//import 'package:first_run/Screenss/user_comment_screen.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:flutter_shop/user_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop/User/user_comment_screen.dart';
import '../../provider_data.dart';


class ProfileScreen extends StatefulWidget {
  final String documentID;
  ProfileScreen(this.documentID ,{Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLiked = false;
  int likecount = 0;
  int commentcount = 0;
  final _formKey = GlobalKey<FormState>();
  //TextEditingController _PostContentController = TextEditingController();
  TextEditingController _postContentController = TextEditingController();
  File _image1;
  String imageurl;
  Future getImage(File requiredImage) async {
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
    //_PostContentController.dispose();
    _postContentController.dispose();
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
        return UserComment( postId);
      },
      isScrollControlled: true,
    );
  }

  Widget build(BuildContext context) {
    UserData userData = Provider.of<ProviderData>(context).userData;
    print(userData.name);
    return Scaffold(
      appBar: null,
      body: new ListView(
        children: <Widget>[

          _profile(),
          _createPost(),
          _drawLine3(),
          _home_posts(),



        ],
      ),
    );
  }
  Widget _profile(){

    return
      FutureBuilder(
          future: Firestore.instance
              .collection('User')
              .document(widget.documentID)
              .get(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return  Column(children: <Widget>[
                  Container(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 200.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://pic.i7lm.com/wp-content/uploads/2019/07/1440009586_large-screenshot1.jpg'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        (snapshot.data['images']==null)?
                        Positioned(
                          top: 100.0,
                          child: Container(
                            height: 198.0,
                            width: MediaQuery.of(context).size.width * 1.65 / 3,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                    AssetImage('images/user_placeholder.jpg')
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width * 1 / 40,
                                )),
                          ),
                        )
                            :Positioned(
                          top: 100.0,
                          child: Container(
                            height: 198.0,
                            width: MediaQuery.of(context).size.width * 1.65 / 3,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:


                                    NetworkImage(
                                        snapshot.data['images'])
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width * 1 / 40,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 140.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          snapshot.data['UserName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 1 / 40),
                        Icon(Icons.check_circle, color: Colors.blueAccent)
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth:  MediaQuery.of(context).size.width * 2 /3 ,
                          height: 40.0,
                          child: RaisedButton(

                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),

                              ),
                              colorBrightness: Brightness.light,
                              color:Colors.purple.shade200,
                              disabledTextColor: Colors.white,

                              child:
                              Row(children: <Widget>[
                                Icon(Icons.person,color: Colors.white),
                                Text(
                                  'My Profile',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],),

                              onPressed: () async{}


                          ),
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.message, color: Colors.blueGrey.shade700),
                            ),

                          ],
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.more_horiz, color: Colors.blueGrey.shade700),
                              onPressed: () {
                                _showMoreOption(context);
                              },
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width * 1 / 40)),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.school,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(height: 50.0),
                            Text(
                              'Awseem School',
                              style:
                              TextStyle(fontSize: 14.0, color: Colors.purple),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width * 1 / 40)),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.home, color: Colors.blueGrey),
                            SizedBox(height: 5.0),
                            Text(
                              'Lives in Giza',
                              style:
                              TextStyle(fontSize: 14.0, color: Colors.purple),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 28.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            'see more about Amal',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 10.0,
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width * 1 / 20)),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Photos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 2.3 / 3,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Card(
                                  child: Image.network(
                                      'http://www.shuuf.com/shof/uploads/2014/08/23/jpg/shof_9e605b2505dedd5.jpg'),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            'see more photos',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 10.0,
                    child: Divider(
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width * 1 / 20)),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Posts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),

                  Container(
                    height: 10.0,
                    child: Divider(
                      color: Colors.deepPurple,
                    ),
                  ),
                ],);
            }
          });
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
                  imageurl = await uploadImage(_image1);
                } else {
                  imageurl = "";
                }
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
        .where('userid', isEqualTo: auth.userData.id)
        .snapshots();

    return StreamBuilder(
        stream: current_user,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                height: MediaQuery.of(context).size.height * 0.79,
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Column(
                          children: snapshot.data.documents
                              .map((document) => Column(
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
                                        if ((snapshot.data.documents[
                                        index]['userid'])==(
                                            auth.userData.id)) {
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
                                                              .document(
                                                              snapshot
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
                                                              .collection('user_home')
                                                              .document(auth.userData.id)
                                                              .collection(
                                                              'post')
                                                              .document(
                                                              snapshot
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
                                                                snapshot.data.documents[index]
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
                                        (snapshot
                                            .data.documents[index]['post_image'] == null)
                                            ? Container()
                                            : Image(
                                          image: NetworkImage(
                                              snapshot
                                                  .data.documents[index]['post_image']),
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
                                                  snapshot.data.documents[index]
                                                  ['NumberOfLikes']
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
                                                        snapshot.data.documents[index]
                                                        ['NumberOfComments']
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
                                              _UsercommentNew(context,
                                                  snapshot
                                                      .data.documents[index].documentID),
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
                                                            .collection('user_home')
                                                            .document(auth.userData.id)
                                                            .collection(
                                                            'post')
                                                            .document(
                                                            snapshot
                                                                .data
                                                                .documents[index]
                                                                .documentID)
                                                            .collection(
                                                            'like')
                                                            .document(snapshot
                                                            .data
                                                            .documents[index]
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
                                                        .collection('user_home')
                                                        .document(auth.userData.id)
                                                        .collection(
                                                        'post')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                        .collection(
                                                        'like')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
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
                                                      'postData' : _postContentController.text,
//                                                      'post_content': document[
//                                                          'post_content']
                                                    });
                                                    Firestore.instance
                                                        .collection('user_home')
                                                        .document(auth.userData.id)
                                                        .collection(
                                                        'post')
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
                                                        .collection('user_home')
                                                        .document(auth.userData.id)
                                                        .collection(
                                                        'post')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                        .updateData({
                                                      'NumberOfLikes':
                                                      FieldValue
                                                          .increment(
                                                          1),
                                                    });
                                                    Firestore.instance
                                                        .collection('user_home')
                                                        .document(auth.userData.id)
                                                        .collection(
                                                        'post')
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
                                                          .document(result[
                                                      "userid"])
                                                          .collection(
                                                          'ActivtyLogitem')
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
                                                        .collection('user_home')
                                                        .document(auth.userData.id)
                                                        .collection(
                                                        'post')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                        .collection(
                                                        'like')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                        .delete();

                                                    Firestore.instance
                                                        .collection('user_home')
                                                        .document(auth.userData.id)
                                                        .collection(
                                                        'post')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
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
                                                          .documents[index]
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
                              .toList());
                    }),
              );
          }
        });
  }



  void _showMoreOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding:
              EdgeInsets.all((MediaQuery.of(context).size.width * 1 / 20)),
              child: Row(
                children: <Widget>[
                  Icon(Icons.feedback, color: Colors.black),
                  SizedBox(width: MediaQuery.of(context).size.width * 1 / 40),
                  Text(
                    'Give Feedback or report this profile',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
              EdgeInsets.all((MediaQuery.of(context).size.width * 1 / 20)),
              child: Row(
                children: <Widget>[
                  Icon(Icons.block, color: Colors.black),
                  SizedBox(width: MediaQuery.of(context).size.width * 1 / 40),
                  Text(
                    'Block',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
              EdgeInsets.all((MediaQuery.of(context).size.width * 1 / 20)),
              child: Row(
                children: <Widget>[
                  Icon(Icons.link, color: Colors.black),
                  SizedBox(width: MediaQuery.of(context).size.width * 1 / 40),
                  Text(
                    'Copy link to profile',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
              EdgeInsets.all((MediaQuery.of(context).size.width * 1 / 20)),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search, color: Colors.black),
                  SizedBox(width: MediaQuery.of(context).size.width * 1 / 40),
                  Text(
                    'Search profile',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

Future<String> uploadImage(File image) async {
  String name = Random().nextInt(1000).toString() + '_profile';
  final StorageReference storageReference = FirebaseStorage().ref().child(name);
  final StorageUploadTask uploadTask = storageReference.putFile(image);
  StorageTaskSnapshot response = await uploadTask.onComplete;
  String url = await response.ref.getDownloadURL();
  return url;
}